import 'dart:developer';
import 'dart:io';

import 'package:api_http_client/api_http_client.dart';
import 'package:http_client/http_client.dart';

/// A base type for all API clients responses.
typedef Response<L, R> = Future<Either<L, R>>;

// Sealed extension for [Response] by using when
// method to handle success and failure cases
extension ResponseExtension<L, R> on Either<L, R> {
  /// Handles success and failure cases.
  /// [success] is called when the [Response] is a [Right].
  /// [failure] is called when the [Response] is a [Left].
  Future<dynamic> when<T>({
    required Future<dynamic> Function(R) success,
    required Future<dynamic> Function(L) failure,
  }) async {
    /// [this] is the current instance of [Response]
    final response = this;

    /// [fold] is a method of [Either] class that takes
    /// two functions as parameters. The first function
    /// is called when the [Either] is a [Left] and the
    /// second function is called when the [Either] is a [Right].
    return response.fold(
      (l) => failure(l),
      (r) => success(r),
    );
  }
}

class ApiHttpClient {
  ApiHttpClient({
    required HttpClient httpClient,
  }) : _httpClient = httpClient;

  final HttpClient _httpClient;

  /// login with username and password
  Response<String, SignInResponse> signIn(SignInRequest request) async {
    try {
      final response = await _httpClient.post(
        'auth/login',
        body: request.toJson(),
      );
      final signInResponse = SignInResponse.fromJson(response);
      if (signInResponse.success) {
        return Right(signInResponse);
      } else {
        return Left(signInResponse.message ?? 'Sign in failed');
      }
    } on ApiRequestFailure catch (e) {
      final msg = e.body['message'];
      return Left(msg is String ? msg : 'Login failed (${e.statusCode})');
    } on SocketException catch (e) {
      return Left('No internet connection: ${e.message}');
    } catch (e) {
      log('Login network error: $e');
      return Left(
          'Cannot connect to server. Check your connection or API URL (is $e reachable?).');
    }
  }

  // sign out
  Response<String, SignInResponse> signOut({String? deviceId}) async {
    try {
      final response = await _httpClient.post(
        'auth/logout',
        body: deviceId != null ? {'deviceId': deviceId} : null,
      );
      final signInResponse = SignInResponse.fromJson(response);
      if (signInResponse.success) {
        return Right(signInResponse);
      } else {
        return Left(signInResponse.message ?? 'Sign out failed');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in signOut: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  /// get products
  Response<String, ProductResponse> getProducts({
    required int page,
  }) async {
    try {
      var baseURL = 'products?page=$page';
      final response = await _httpClient.get(baseURL);
      final productResponse = ProductResponse.fromJson(response);

      if (productResponse.products.isNotEmpty || (response['data'] != null)) {
        return Right(productResponse);
      } else {
        return const Left('No products found');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in getProducts: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // get categories
  Response<String, CategoryResponse> getCategories({String? type}) async {
    try {
      final queryParams = <String, String>{};
      if (type != null) queryParams['type'] = type;
      final path = queryParams.isEmpty
          ? 'categories'
          : 'categories?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}';
      final response = await _httpClient.get(path);
      final categoryResponse = CategoryResponse.fromJson(response);
      if (categoryResponse.categories.isNotEmpty || response['data'] != null) {
        return Right(categoryResponse);
      } else {
        return const Left('No categories found');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in getCategories: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // get doctor
  Response<String, DoctorResponse> getDoctors(
      {required int page, String? query}) async {
    try {
      final baseURL = query == null
          ? 'doctors?page=$page'
          : 'doctors?page=$page&speciality_id=$query';
      final response = await _httpClient.get(baseURL);
      final res = DoctorResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message ?? 'Failed to get doctors');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in getDoctors: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // get doctor detail
  Response<String, DoctorDetailResponse> getDoctorDetail(
      {required String id}) async {
    try {
      final response = await _httpClient.get('doctors/$id');
      final res = DoctorDetailResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message ?? 'Failed to get doctor detail');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in getDoctorDetail: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // get speciality
  Response<String, SpecialityResponse> getSpecialities(
      {required int page}) async {
    try {
      final response = await _httpClient.get('specialities?page=$page');
      final res = SpecialityResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message ?? 'Failed to get specialities');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in getSpecialities: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // get hospital
  Response<String, HospitalResponse> getHospital() async {
    try {
      final response = await _httpClient.get('hospitals');
      final res = HospitalResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message ?? 'Failed to get hospitals');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in getHospital: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // get user info
  Response<String, UserInfoResponse> getUserInfo() async {
    try {
      final response = await _httpClient.get('auth/get-user-info');
      final res = UserInfoResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message ?? 'Failed to get user info');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in getUserInfo: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // get hospital
  Response<String, HospitalDetailResponse> getHospitalDetails(
      {required String id}) async {
    try {
      final response = await _httpClient.get('hospitals/$id');
      final res = HospitalDetailResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message ?? 'Failed to get hospital details');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in getHospitalDetails: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  Response<String, DoctorResponse> getDoctorByHospital({
    required String id,
  }) async {
    try {
      final response = await _httpClient.get('doctors/by-hospital/$id');
      final res = DoctorResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message ?? 'Failed to get doctors by hospital');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in getDoctorByHospital: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  Response<String, HospitalResponse> getHospitalByDoctor({
    required String id,
  }) async {
    try {
      final response = await _httpClient.get('doctors/$id/hospitals');
      final res = HospitalResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message ?? 'Failed to get hospitals');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in getHospitalByDoctor: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  Response<String, AvailableTimeSlotResponse> availableTimeSlot({
    required String doctorId,
    required String hospitalId,
    required String date,
  }) async {
    try {
      final baseURL =
          'appointments/available-slots?doctor_id=$doctorId&date=$date&hospital_id=$hospitalId';
      final response = await _httpClient.get(baseURL);
      final res = AvailableTimeSlotResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message ?? 'Failed to get available time slots');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in availableTimeSlot: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  Response<String, AppointmentResponse> getAppointments({
    int page = 1,
  }) async {
    try {
      final response = await _httpClient.get('appointments?page=$page');
      final res = AppointmentResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message ?? 'Failed to get appointments');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in getAppointments: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  Response<String, AppointmentDetailResponse> bookAppointment(
    BookAppointmentRequest request,
  ) async {
    try {
      log('Booking appointment with request: ${request.toJson()}');
      final response = await _httpClient.post(
        'appointments',
        body: request.toJson(),
      );
      final res = AppointmentDetailResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message ?? 'Failed to book appointment');
      }
    } on ApiRequestFailure catch (e) {
      final message = e.body['message'];
      return Left(message is String ? message : 'Failed to book appointment');
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in bookAppointment: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // cancel appointment
  Response<String, AppointmentDetailResponse> cancelAppointment({
    required String appointmentId,
  }) async {
    try {
      final response =
          await _httpClient.post('appointments/$appointmentId/cancel');
      final res = AppointmentDetailResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message ?? 'Failed to cancel appointment');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in cancelAppointment: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // add to cart
  Response<String, CartResponse> addToCart({
    required String itemId,
    required String itemType,
    required int quantity,
  }) async {
    try {
      final response = await _httpClient.post(
        'cart/add',
        body: {
          'item_id': itemId,
          'item_type': itemType,
          'quantity': quantity,
        },
      );
      final cartResponse = CartResponse.fromJson(response);
      if (cartResponse.success) {
        return Right(cartResponse);
      } else {
        return Left(response['message'] as String);
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in addToCart: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // get cart
  Response<String, CartResponse> getCart() async {
    try {
      final response = await _httpClient.get('cart');
      final cartResponse = CartResponse.fromJson(response);
      if (cartResponse.success) {
        return Right(cartResponse);
      } else {
        return Left(cartResponse.message ?? 'Failed to get cart');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in getCart: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // update cart item
  Response<String, CartResponse> updateCart({
    required String cartItemId,
    required int quantity,
  }) async {
    try {
      final response = await _httpClient.put(
        'cart/items/$cartItemId',
        body: {
          'quantity': quantity,
        },
      );

      final cartResponse = CartResponse.fromJson(response);
      if (cartResponse.success) {
        return Right(cartResponse);
      } else {
        return Left(cartResponse.message ?? 'Failed to update cart');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in updateCart: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // delete cart item
  Response<String, CartResponse> deleteCartItem({
    required String cartItemId,
  }) async {
    try {
      final response = await _httpClient.delete('cart/items/$cartItemId');
      final cartResponse = CartResponse.fromJson(response);
      if (cartResponse.success) {
        return Right(cartResponse);
      } else {
        return Left(cartResponse.message ?? 'Failed to delete cart item');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in deleteCartItem: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // get delivery type
  Response<String, DeliveryTypeResponse> getDeliveryType() async {
    try {
      final response = await _httpClient.get('checkout/delivery-types');
      final deliveryTypeResponse = DeliveryTypeResponse.fromJson(response);
      if (deliveryTypeResponse.success) {
        return Right(deliveryTypeResponse);
      } else {
        return Left(
            deliveryTypeResponse.message ?? 'Failed to fetch delivery types');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in getDeliveryType: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // get payment methods
  Response<String, PaymentMethodResponse> getPaymentMethods() async {
    try {
      final response = await _httpClient.get('checkout/payment-methods');
      final res = PaymentMethodResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message ?? 'Failed to fetch payment methods');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in getPaymentMethods: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // place order
  Response<String, String> placeOrder(PlaceOrderRequest request) async {
    try {
      final response = await _httpClient.post(
        'checkout/place-order',
        body: request.toJson(),
      );
      log('placeOrder response: $response');

      if (response['success'] == true) {
        return Right(response['message'] as String);
      } else {
        return Left(response['message'] as String);
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in placeOrder: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  Response<String, HealthBotChartResponse> healthBotChart({
    required String message,
  }) async {
    try {
      final response = await _httpClient.post(
        'ai/chat',
        body: {
          'message': message,
        },
      );
      final res = HealthBotChartResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message ?? 'Failed to process AI chat message');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in healthBotChart: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // reschedule appointment
  Response<String, String> reschedule({
    required String slotId,
    required String reason,
    required String appointmentId,
  }) async {
    try {
      final response = await _httpClient.put(
        'appointments/$appointmentId/reschedule',
        body: {
          'slot_id': slotId,
          'reason_for_reschedule': reason,
        },
      );

      if (response['success'] == true) {
        return Right(response['message'] as String);
      } else {
        return Left(response['message'] as String);
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in reschedule: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  Response<String, ServiceResponse> getServices() async {
    try {
      final response = await _httpClient.get('services');
      final res = ServiceResponse.fromJson(response);
      if (res.services.isNotEmpty || response['data'] != null) {
        return Right(res);
      } else {
        return const Left('No services found');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in getServices: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // get settings
  Response<String, SettingResponse> getSettings() async {
    try {
      final response = await _httpClient.get('settings');
      final res = SettingResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message ?? 'Failed to fetch settings');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in getSettings: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // get single product
  Response<String, ProductDetailResponse> getProduct({
    required String id,
  }) async {
    try {
      final response = await _httpClient.get('products/$id');
      final res = ProductDetailResponse.fromJson(response);
      return Right(res);
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in getProduct: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // get pets
  Response<String, PetResponse> getPets({
    String? categoryId,
    String? search,
    int page = 1,
  }) async {
    try {
      final queryParams = <String, String>{'page': '$page'};
      if (categoryId != null) queryParams['category_id'] = categoryId;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      final path =
          'pets?${queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&')}';
      final response = await _httpClient.get(path);
      final res = PetResponse.fromJson(response);
      if (res.pets.isNotEmpty || response['data'] != null) {
        return Right(res);
      } else {
        return const Left('No pets found');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in getPets: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // get single pet
  Response<String, PetDetailResponse> getPet({
    required String id,
  }) async {
    try {
      final response = await _httpClient.get('pets/$id');
      log('[DEBUG] getPet keys: ${response.keys.toList()}');
      final res = PetDetailResponse.fromJson(response);
      log('[DEBUG] getPet res.pet: ${res.pet?.name}');
      if (res.pet != null) {
        return Right(res);
      } else {
        return const Left('Pet not found');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e, s) {
      log('[DEBUG] getPet caught error: $e\n$s');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // get single category
  Response<String, CategoryDetailResponse> getCategory({
    required String id,
  }) async {
    try {
      final response = await _httpClient.get('categories/$id');
      final res = CategoryDetailResponse.fromJson(response);
      return Right(res);
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in getCategory: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // get single service
  Response<String, ServiceDetailResponse> getService({
    required String id,
  }) async {
    try {
      final response = await _httpClient.get('services/$id');
      final res = ServiceDetailResponse.fromJson(response);
      return Right(res);
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      return const Left('Something went wrong. Try again');
    }
  }

  // clear cart
  Response<String, CartResponse> clearCart() async {
    try {
      final response = await _httpClient.delete('cart/clear');
      final cartResponse = CartResponse.fromJson(response);
      if (cartResponse.success) {
        return Right(cartResponse);
      } else {
        return Left(cartResponse.message ?? 'Failed to update cart');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in clearCart: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // get single appointment
  Response<String, AppointmentDetailResponse> getAppointmentDetail({
    required String id,
  }) async {
    try {
      final response = await _httpClient.get('appointments/$id');
      final res = AppointmentDetailResponse.fromJson(response);
      if (res.success || res.data != null || response['data'] != null) {
        return Right(res);
      } else {
        return Left(res.message ?? 'Failed to fetch appointment detail');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in getAppointmentDetail: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // get favorites
  Response<String, FavoriteResponse> getFavorites() async {
    try {
      final response = await _httpClient.get('favorites');
      final res = FavoriteResponse.fromJson(response);
      return Right(res);
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message']?.toString() ?? 'Failed to fetch favorites');
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in getFavorites: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // toggle favorite
  Response<String, ToggleFavoriteResponse> toggleFavorite({
    required String id,
    required String itemType,
  }) async {
    try {
      final response = await _httpClient.post(
        'favorites',
        body: {
          'item_id': id,
          'item_type': itemType,
        },
      );
      final res = ToggleFavoriteResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message ?? 'Failed to toggle favorite');
      }
    } on ApiRequestFailure catch (e) {
      final message =
          e.body['message']?.toString() ?? 'Failed to toggle favorite';
      return Left(message);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      log('[ApiHttpClient] Error in toggleFavorite: $e');
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }
}
