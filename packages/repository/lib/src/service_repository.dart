import 'package:api_http_client/api_http_client.dart';

class ServiceRepository {
  ServiceRepository({
    required ApiHttpClient apiClient,
  }) : _apiClient = apiClient;

  final ApiHttpClient _apiClient;

  Response<String, ServiceResponse> getServices() async {
    final response = await _apiClient.getServices();
    return response;
  }

  Response<String, ServiceDetailResponse> getService({
    required String id,
  }) async {
    final response = await _apiClient.getService(id: id);
    return response;
  }
}
