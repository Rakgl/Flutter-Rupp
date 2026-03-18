import 'package:api_http_client/api_http_client.dart';

class OrderRepository {
  OrderRepository({
    required ApiHttpClient apiClient,
  }) : _apiClient = apiClient;

  final ApiHttpClient _apiClient;

  Response<String, OrderResponse> placeOrder({
    required String fulfillmentType,
    String? paymentMethodId,
    String? deliveryAddress,
  }) async {
    return _apiClient.placeNewOrder(
      fulfillmentType: fulfillmentType,
      paymentMethodId: paymentMethodId,
      deliveryAddress: deliveryAddress,
    );
  }

  Response<String, OrderResponse> verifyPayment({
    required String orderId,
  }) async {
    return _apiClient.verifyPayment(orderId: orderId);
  }

  Response<String, OrderResponse> cancelOrder({
    required String orderId,
  }) async {
    return _apiClient.cancelOrder(orderId: orderId);
  }

  Response<String, OrderResponse> getOrder({
    required String orderId,
  }) async {
    return _apiClient.getOrder(orderId: orderId);
  }

  Response<String, OrderListResponse> getOrders() async {
    return _apiClient.getOrders();
  }
}
