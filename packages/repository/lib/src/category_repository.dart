import 'package:api_http_client/api_http_client.dart';

class CategoryRepository {
  CategoryRepository({
    required ApiHttpClient apiClient,
  }) : _apiClient = apiClient;

  final ApiHttpClient _apiClient;

  Response<String, CategoryResponse> getCategories({String? type}) async {
    final response = await _apiClient.getCategories(type: type);
    return response;
  }

  Response<String, CategoryDetailResponse> getCategory({
    required String id,
  }) async {
    final response = await _apiClient.getCategory(id: id);
    return response;
  }
}
