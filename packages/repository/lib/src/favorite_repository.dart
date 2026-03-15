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

  Response<String, ToggleFavoriteResponse> toggleFavorite({
    required String id,
    required String itemType,
  }) async {
    final response = await _apiClient.toggleFavorite(id: id, itemType: itemType);
    return response;
  }
}
