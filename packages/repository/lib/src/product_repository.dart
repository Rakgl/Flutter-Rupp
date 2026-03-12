import 'package:api_http_client/api_http_client.dart';

class ProductRepository {
  ProductRepository({
    required ApiHttpClient apiClient,
  }) : _apiClient = apiClient;

  final ApiHttpClient _apiClient;

  Response<String, ProductResponse> getProducts({
    required int page,
  }) async {
    final response = await _apiClient.getProducts(
      page: page,
    );
    return response;
  }

  Response<String, ProductDetailResponse> getProduct({
    required String id,
  }) async {
    final response = await _apiClient.getProduct(id: id);
    return response;
  }
}
