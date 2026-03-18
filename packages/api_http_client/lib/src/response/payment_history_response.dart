import 'package:api_http_client/api_http_client.dart';

class PaymentHistoryResponse extends BaseResponse {
  PaymentHistoryResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    final data = json['data'];
    if (data is List) {
      orders = data
          .map((e) => PaymentHistoryItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      orders = [];
    }
  }

  late List<PaymentHistoryItem> orders;
}

class PaymentHistoryItem {
  final String id;
  final String orderNumber;
  final double subtotal;
  final double deliveryFee;
  final double totalAmount;
  final String status;
  final String paymentStatus;
  final String fulfillmentType;
  final String? deliveryAddress;
  final PaymentHistoryMethod? paymentMethod;
  final String createdAt;

  PaymentHistoryItem({
    required this.id,
    required this.orderNumber,
    required this.subtotal,
    required this.deliveryFee,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
    required this.fulfillmentType,
    this.deliveryAddress,
    this.paymentMethod,
    required this.createdAt,
  });

  factory PaymentHistoryItem.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryItem(
      id: json.getStringOrDefault('id'),
      orderNumber: json.getStringOrDefault('order_number'),
      subtotal: json.getDoubleOrDefault('subtotal'),
      deliveryFee: json.getDoubleOrDefault('delivery_fee'),
      totalAmount: json.getDoubleOrDefault('total_amount'),
      status: json.getStringOrDefault('status'),
      paymentStatus: json.getStringOrDefault('payment_status'),
      fulfillmentType: json.getStringOrDefault('fulfillment_type'),
      deliveryAddress: json.getStringOrNull('delivery_address'),
      paymentMethod: json['payment_method'] != null
          ? PaymentHistoryMethod.fromJson(
              json['payment_method'] as Map<String, dynamic>)
          : null,
      createdAt: json.getStringOrDefault('created_at'),
    );
  }
}

class PaymentHistoryMethod {
  final String id;
  final String name;

  PaymentHistoryMethod({required this.id, required this.name});

  factory PaymentHistoryMethod.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryMethod(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}
