import 'package:api_http_client/api_http_client.dart';

class ServiceResponse extends BaseResponse {
  ServiceResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    final data = json.getListOrDefault('data');
    services = data.map((e) => ServiceModel.fromJson(e)).toList();
    isReachMax = json.getBoolOrDefault('reach_max');
  }

  late List<ServiceModel> services;
  late bool isReachMax;
}

class ServiceModel {
  final String id;
  final String name;

  ServiceModel({
    required this.id,
    required this.name,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json.getStringOrDefault('id'),
      name: json.getStringOrDefault('name'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
