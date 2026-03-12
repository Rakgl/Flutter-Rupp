import 'package:api_http_client/api_http_client.dart';

class ServiceDetailResponse {
  const ServiceDetailResponse({required this.service});

  final ServiceModel service;

  factory ServiceDetailResponse.fromJson(Map<String, dynamic> json) {
    // The endpoint returns the service object directly (unwrapped)
    return ServiceDetailResponse(
      service: ServiceModel.fromJson(json),
    );
  }
}
