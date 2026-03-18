import 'package:api_http_client/api_http_client.dart';

class OrderResponse extends BaseResponse {
  OrderResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    final data = json.getMapOrNull('data');
    if (data != null) {
      order = OrderModel.fromJson(data);
    }

    final paymentData = json.getMapOrNull('payment_info');
    if (paymentData != null) {
      paymentInfo = PaymentInfoModel.fromJson(paymentData);
    }
  }

  OrderModel? order;
  PaymentInfoModel? paymentInfo;
}

class OrderListResponse extends BaseResponse {
  OrderListResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    final data = json['data'];
    if (data is List) {
      orders = data
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      orders = [];
    }
  }

  late List<OrderModel> orders;
}

class OrderModel {
  final String id;
  final String orderNumber;
  final double subtotal;
  final double deliveryFee;
  final double totalAmount;
  final String status;
  final String paymentStatus;
  final String fulfillmentType;
  final String? deliveryAddress;
  final List<OrderItemModel> items;
  final String createdAt;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.subtotal,
    required this.deliveryFee,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
    required this.fulfillmentType,
    this.deliveryAddress,
    required this.items,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json.getStringOrDefault('id'),
      orderNumber: json.getStringOrDefault('order_number'),
      subtotal: json.getDoubleOrDefault('subtotal'),
      deliveryFee: json.getDoubleOrDefault('delivery_fee'),
      totalAmount: json.getDoubleOrDefault('total_amount'),
      status: json.getStringOrDefault('status'),
      paymentStatus: json.getStringOrDefault('payment_status'),
      fulfillmentType: json.getStringOrDefault('fulfillment_type'),
      deliveryAddress: json.getStringOrNull('delivery_address'),
      items: json['items'] != null
          ? (json['items'] as List)
              .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      createdAt: json.getStringOrDefault('created_at'),
    );
  }

  bool get isPending => status == 'PENDING';
  bool get isProcessing => status == 'PROCESSING';
  bool get isCancelled => status == 'CANCELLED';
  bool get isPaid => paymentStatus == 'PAID';
  bool get isUnpaid => paymentStatus == 'UNPAID';
}

class OrderItemModel {
  final String id;
  final String itemableId;
  final String itemableType;
  final int quantity;
  final double unitPrice;
  final double subtotal;
  final String itemName;
  final String? imageUrl;

  OrderItemModel({
    required this.id,
    required this.itemableId,
    required this.itemableType,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    required this.itemName,
    this.imageUrl,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json.getStringOrDefault('id'),
      itemableId: json.getStringOrDefault('itemable_id'),
      itemableType: json.getStringOrDefault('itemable_type'),
      quantity: json.getIntOrDefault('quantity'),
      unitPrice: json.getDoubleOrDefault('unit_price'),
      subtotal: json.getDoubleOrDefault('subtotal'),
      itemName: json.getStringOrDefault('item_name'),
      imageUrl: json.getStringOrNull('image_url'),
    );
  }
}

class PaymentInfoModel {
  final String transactionNo;
  final String? qrString;
  final String? abapayDeeplink;
  final String? checkoutQrUrl;

  PaymentInfoModel({
    required this.transactionNo,
    this.qrString,
    this.abapayDeeplink,
    this.checkoutQrUrl,
  });

  factory PaymentInfoModel.fromJson(Map<String, dynamic> json) {
    return PaymentInfoModel(
      transactionNo: json.getStringOrDefault('transaction_no'),
      qrString: json.getStringOrNull('qr_string'),
      abapayDeeplink: json.getStringOrNull('abapay_deeplink'),
      checkoutQrUrl: json.getStringOrNull('checkout_qr_url'),
    );
  }

  /// Extract QR data from deeplink if qr_string is null
  String? get qrData {
    if (qrString != null && qrString!.isNotEmpty) return qrString;
    if (abapayDeeplink != null) {
      final uri = Uri.tryParse(abapayDeeplink!);
      if (uri != null) {
        final qrcode = uri.queryParameters['qrcode'];
        if (qrcode != null) {
          return Uri.decodeComponent(qrcode);
        }
      }
    }
    return null;
  }
}
