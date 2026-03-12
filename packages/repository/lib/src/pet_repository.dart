import 'package:api_http_client/api_http_client.dart';

class PetRepository {
  PetRepository({
    required ApiHttpClient apiClient,
  }) : _apiClient = apiClient;

  final ApiHttpClient _apiClient;

  Response<String, PetResponse> getPets({
    String? categoryId,
    String? search,
    int page = 1,
  }) async {
    final response = await _apiClient.getPets(
      categoryId: categoryId,
      search: search,
      page: page,
    );
    return response;
  }

  Response<String, PetDetailResponse> getPet({
    required String id,
  }) async {
    final response = await _apiClient.getPet(id: id);
    return response;
  }
}
