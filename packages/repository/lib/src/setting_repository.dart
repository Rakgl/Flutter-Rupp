import 'package:api_http_client/api_http_client.dart';

class SettingRepository {
  SettingRepository({
    required ApiHttpClient apiClient,
  }) : _apiClient = apiClient;

  final ApiHttpClient _apiClient;

  Response<String, SettingResponse> getSettings() async {
    final response = await _apiClient.getSettings();
    return response;
  }
}
