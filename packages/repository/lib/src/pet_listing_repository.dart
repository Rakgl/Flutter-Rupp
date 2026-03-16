import 'package:api_http_client/api_http_client.dart';

class PetListingRepository {
  PetListingRepository({
    required ApiHttpClient apiClient,
  }) : _apiClient = apiClient;

  final ApiHttpClient _apiClient;

  Response<String, PetResponse> getPetListings({
    String? categoryId,
    String? search,
    int page = 1,
  }) async {
    final response = await _apiClient.getPetListings(
      categoryId: categoryId,
      search: search,
      page: page,
    );
    return response;
  }
}
