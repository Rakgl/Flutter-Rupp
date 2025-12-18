import 'package:api_http_client/api_http_client.dart';

class DeliveryTypeResponse extends BaseResponse {
  DeliveryTypeResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    final data = json.getListOrDefault('data');
    deliveryTypes = data.map((item) => DeliveryType.fromJson(item)).toList();
  }

  late List<DeliveryType> deliveryTypes;
}

class DeliveryType {
  final String keyName;
  final String valueName;

  DeliveryType({
    required this.keyName,
    required this.valueName,
  });

  factory DeliveryType.fromJson(Map<String, dynamic> json) {
    return DeliveryType(
      keyName: json.getStringOrDefault('key'),
      valueName: json.getStringOrDefault('name'),
    );
  }
}
