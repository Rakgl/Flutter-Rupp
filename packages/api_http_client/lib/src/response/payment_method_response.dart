import 'package:api_http_client/api_http_client.dart';

class PaymentMethodResponse extends BaseResponse {
  PaymentMethodResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    final data = json.getListOrDefault('data');
    paymentMethods = data.map((item) => PaymentMethod.fromJson(item)).toList();
  }

  late List<PaymentMethod> paymentMethods;
}


class PaymentMethod {
  final String id;
  final String name;
  final String? image;
  final String? description;
  final String? type;
  PaymentMethod({
    required this.id,
    required this.name,
    this.image,
    this.description,
    this.type,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json.getStringOrDefault('id'),
      name: json.getStringOrDefault('name'),
      image: json.getStringOrDefault('image'),
      description: json.getStringOrDefault('description'),
      type: json.getStringOrDefault('type'),
    );
  }
}
