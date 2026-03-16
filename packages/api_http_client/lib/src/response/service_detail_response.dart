import 'package:api_http_client/api_http_client.dart';

class ServiceDetailResponse {
  const ServiceDetailResponse({required this.service});

  final ServiceModel service;

  factory ServiceDetailResponse.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    return ServiceDetailResponse(
      service: ServiceModel.fromJson(data),
    );
  }
}
