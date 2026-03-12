import 'package:api_http_client/api_http_client.dart';

class CartRepository {
  CartRepository({
    required ApiHttpClient apiClient,
  }) : _apiClient = apiClient;

  final ApiHttpClient _apiClient;

  Response<String, CartResponse> getCart() async {
    final response = await _apiClient.getCart();
    return response;
  }

  Response<String, CartResponse> addToCart({
    required String itemId,
    required String itemType,
    required int quantity,
  }) async {
    final response = await _apiClient.addToCart(
      itemId: itemId,
      itemType: itemType,
      quantity: quantity,
    );
    return response;
  }

  Response<String, CartResponse> updateCart({
    required String cartItemId,
    required int quantity,
  }) async {
    final response = await _apiClient.updateCart(
      cartItemId: cartItemId,
      quantity: quantity,
    );
    return response;
  }

  Response<String, CartResponse> removeCartItem({
    required String cartItemId,
  }) async {
    final response = await _apiClient.deleteCartItem(
      cartItemId: cartItemId,
    );
    return response;
  }

  Response<String, CartResponse> clearCart() async {
    final response = await _apiClient.clearCart();
    return response;
  }

  Response<String, DeliveryTypeResponse> getDeliveryType() async {
    final response = await _apiClient.getDeliveryType();
    return response;
  }

  Response<String, PaymentMethodResponse> getPaymentMethods() async {
    final response = await _apiClient.getPaymentMethods();
    return response;
  }

  Response<String, String> placeOrder(PlaceOrderRequest request) async {
    final response = await _apiClient.placeOrder(request);
    return response;
  }
}
