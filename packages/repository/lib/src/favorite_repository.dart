import 'package:api_http_client/api_http_client.dart';

class FavoriteRepository {
  FavoriteRepository({
    required ApiHttpClient apiClient,
  }) : _apiClient = apiClient;

  final ApiHttpClient _apiClient;

  Response<String, FavoriteResponse> getFavorites() async {
    final response = await _apiClient.getFavorites();
    return response;
  }

  Response<String, String> addFavorite({
    required String id,
  }) async {
    final response = await _apiClient.addFavorite(id: id);
    return response;
  }

  Response<String, String> removeFavorite({
    required String id,
  }) async {
    final response = await _apiClient.removeFavorite(id: id);
    return response;
  }
}
