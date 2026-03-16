import 'dart:developer' show log;

//
import 'package:api_http_client/api_http_client.dart';
import 'package:token_storage/token_storage.dart';

class UserRepository {
  UserRepository({
    required ApiHttpClient apiClient,
    required TokenStorage tokenStorage,
  })  : _apiClient = apiClient,
        _tokenStorage = tokenStorage;

  final TokenStorage _tokenStorage;
  final ApiHttpClient _apiClient;

  Stream<bool> get authenticationStatus =>
      _tokenStorage.accessTokenStream.map((token) => token != null);

  Future<List<String?>> readToken() => _tokenStorage.readToken();
  Future<void> clearToken() => _tokenStorage.clearToken();

  // sign in
  Response<String, SignInResponse> signIn(SignInRequest request) async {
    final response = await _apiClient.signIn(request);

    await response.when<SignInResponse>(
      success: (data) async {
        log('signIn success: ${data.success}');
        await _tokenStorage.writeToken(
          accessToken: data.accessToken,
          refreshToken: data.refreshToken,
          expireIn: data.expiresIn.toString(),
          deviceId: '',
        );
      },
      failure: (error) async {
        log('signIn failure: $error');
      },
    );
    return response;
  }



  // get category
  Response<String, CategoryResponse> getCategories() async {
    final response = await _apiClient.getCategories();
    return response;
  }

  // get user info
  Response<String, UserInfoResponse> getUserInfo() async {
    final response = await _apiClient.getUserInfo();
    return response;
  }

  // sign out
  Future<bool> signOut() async {
    try {
      final deviceId = await _tokenStorage.getDeviceId();
      await _apiClient.signOut(deviceId: deviceId);
      await _tokenStorage.clearToken();
      return true;
    } catch (e) {
      return false;
    }
  }

  Response<String, AppointmentResponse> getAppointement({
    required int page,
    required String status,
  }) async {
    final response = await _apiClient.getAppointments(page: page);
    return response;
  }

// health ai chart bot
  Response<String, HealthBotChartResponse> healthBotChart({
    required String message,
  }) async {
    final response = await _apiClient.healthBotChart(
      message: message,
    );
    return response;
  }

  Response<String, AppointmentDetailResponse> bookAppointment(
    BookAppointmentRequest request,
  ) async {
    final response = await _apiClient.bookAppointment(request);
    return response;
  }

  Response<String, ServiceResponse> getServices() async {
    final response = await _apiClient.getServices();
    return response;
  }

  Response<String, AppointmentDetailResponse> cancelAppointment(String id) async {
    final response = await _apiClient.cancelAppointment(
      appointmentId: id,
    );
    return response;
  }

  Response<String, CartResponse> getCart() async {
    final response = await _apiClient.getCart();
    return response;
  }

  Response<String, CheckoutConfigResponse> getCheckoutConfig() async {
    final response = await _apiClient.getCheckoutConfig();
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
    required String cartId,
    required int quantity,
  }) async {
    final response = await _apiClient.updateCart(
      cartItemId: cartId,
      quantity: quantity,
    );
    return response;
  }

  Response<String, CartResponse> deleteCartItem(String cartId) async {
    final response = await _apiClient.deleteCartItem(
      cartItemId: cartId,
    );
    return response;
  }

  Response<String, DeliveryTypeResponse> getDeliveryTypes() async {
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

  Response<String, String> reschedule({
    required String slotId,
    required String reason,
    required String appointmentId,
  }) async {
    final response = await _apiClient.reschedule(
      slotId: slotId,
      reason: reason,
      appointmentId: appointmentId,
    );

    return response;
  }
}
