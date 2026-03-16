import 'package:api_http_client/api_http_client.dart';

class CheckoutConfigResponse extends BaseResponse {
  CheckoutConfigResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    final data = json.getMapOrDefault('data');
    
    deliveryTypes = List<String>.from(
      (data['delivery_types'] as List? ?? []).map((e) => e.toString()),
    );
    
    paymentMethods = List<PaymentMethodModel>.from(
      (data['payment_methods'] as List? ?? [])
          .map((e) => PaymentMethodModel.fromJson(e as Map<String, dynamic>)),
    );
  }

  late List<String> deliveryTypes;
  late List<PaymentMethodModel> paymentMethods;
}

class PaymentMethodModel {
  final String id;
  final String name;
  final String? code;
  final String? description;

  PaymentMethodModel({
    required this.id,
    required this.name,
    this.code,
    this.description,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString(),
      description: json['description']?.toString(),
    );
  }
}
