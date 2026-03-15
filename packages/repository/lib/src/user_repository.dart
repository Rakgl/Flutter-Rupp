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

  // get doctor
  Response<String, DoctorResponse> getDoctors({
    required int page,
    String? query,
  }) async {
    final response = await _apiClient.getDoctors(
      page: page,
      query: query,
    );
    return response;
  }

  // get doctor detail
  Response<String, DoctorDetailResponse> getDoctorDetail({
    required String id,
  }) async {
    final response = await _apiClient.getDoctorDetail(id: id);
    return response;
  }

  // get speciality
  Response<String, SpecialityResponse> getSpecialities({
    required int page,
  }) async {
    final response = await _apiClient.getSpecialities(page: page);
    return response;
  }

  // get hospital
  Response<String, HospitalResponse> getHospital() async {
    final response = await _apiClient.getHospital();
    return response;
  }

  // get hospital details
  Response<String, HospitalDetailResponse> getHospitalDetails({
    required String id,
  }) async {
    final response = await _apiClient.getHospitalDetails(id: id);
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

  Response<String, DoctorResponse> getDoctorByHospital({
    required String hospitalId,
  }) async {
    final response = await _apiClient.getDoctorByHospital(id: hospitalId);
    return response;
  }

  Response<String, HospitalResponse> getHospitalByDoctor({
    required String hospitalId,
  }) async {
    final response = await _apiClient.getHospitalByDoctor(id: hospitalId);
    return response;
  }

  Response<String, AppointmentResponse> getAppointement({
    required int page,
    required String status,
  }) async {
    final response = await _apiClient.getAppointments(page: page);
    return response;
  }

  Response<String, AvailableTimeSlotResponse> availableTimeSlot({
    required String doctorId,
    required String date,
    required String hospitalId,
  }) async {
    final response = await _apiClient.availableTimeSlot(
      date: date,
      doctorId: doctorId,
      hospitalId: hospitalId,
    );

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
