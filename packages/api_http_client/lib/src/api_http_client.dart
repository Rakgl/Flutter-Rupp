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
        '/auth/login',
        body: request.toJson(),
      );
      final signInResponse = SignInResponse.fromJson(response);
      if (signInResponse.success) {
        return Right(signInResponse);
      } else {
        return Left(signInResponse.message);
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // sign out
  Response<String, SignInResponse> signOut({String? deviceId}) async {
    try {
      final response = await _httpClient.post(
        '/auth/logout',
        body: deviceId != null ? {'deviceId': deviceId} : null,
      );
      final signInResponse = SignInResponse.fromJson(response);
      if (signInResponse.success) {
        return Right(signInResponse);
      } else {
        return Left(signInResponse.message);
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  /// Get pharmacies
  Response<String, PharmacyResponse> getPharmacies() async {
    try {
      final response = await _httpClient.get('/pharmacies');
      final pharmacyResponse = PharmacyResponse.fromJson(response);
      if (pharmacyResponse.success) {
        return Right(pharmacyResponse);
      } else {
        return Left(pharmacyResponse.message);
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  /// Get pharmacy by ID
  Response<String, PharmacyDetailResponse> showPharmacy(String id) async {
    try {
      final response = await _httpClient.get('/pharmacies/$id');
      final pharmacyDetailResponse = PharmacyDetailResponse.fromJson(response);
      if (pharmacyDetailResponse.success) {
        return Right(pharmacyDetailResponse);
      } else {
        return Left(pharmacyDetailResponse.message);
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  /// get products by pharmacy ID
  Response<String, ProductResponse> getProductsByPharmacyId(
    String pharmacyId,
    String? categoryId, {
    required int page,
  }) async {
    try {
      var baseURL = '/pharmacies/$pharmacyId/products?page=$page';
      if (categoryId != null) {
        baseURL =
            '/pharmacies/$pharmacyId/categories/$categoryId/products?page=$page';
      }
      final response = await _httpClient.get(baseURL);
      final productResponse = ProductResponse.fromJson(response);
      if (productResponse.success) {
        return Right(productResponse);
      } else {
        return const Left('No products found for this pharmacy');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // get categories
  Response<String, CategoryResponse> getCategories() async {
    try {
      final response = await _httpClient.get('/pharmacies/categories');
      final categoryResponse = CategoryResponse.fromJson(response);
      if (categoryResponse.success) {
        return Right(categoryResponse);
      } else {
        return const Left('No categories found');
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
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
          ? '/doctors?page=$page'
          : '/doctors?page=$page&speciality_id=$query';
      final response = await _httpClient.get(baseURL);
      final res = DoctorResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message);
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // get doctor detail
  Response<String, DoctorDetailResponse> getDoctorDetail(
      {required String id}) async {
    try {
      final response = await _httpClient.get('/doctors/$id');
      final res = DoctorDetailResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message);
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // get speciality
  Response<String, SpecialityResponse> getSpecialities(
      {required int page}) async {
    try {
      final response = await _httpClient.get('/specialities?page=$page');
      final res = SpecialityResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message);
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // get hospital
  Response<String, HospitalResponse> getHospital() async {
    try {
      final response = await _httpClient.get('/hospitals');
      final res = HospitalResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message);
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // get user info
  Response<String, UserInfoResponse> getUserInfo() async {
    try {
      final response = await _httpClient.get('/auth/get-user-info');
      final res = UserInfoResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message);
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // get hospital
  Response<String, HospitalDetailResponse> getHospitalDetails(
      {required String id}) async {
    try {
      final response = await _httpClient.get('/hospitals/$id');
      final res = HospitalDetailResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message);
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  Response<String, DoctorResponse> getDoctorByHospital({
    required String id,
  }) async {
    try {
      final response = await _httpClient.get('/doctors/by-hospital/$id');
      final res = DoctorResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message);
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  Response<String, HospitalResponse> getHospitalByDoctor({
    required String id,
  }) async {
    try {
      final response = await _httpClient.get('/doctors/$id/hospitals');
      final res = HospitalResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message);
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
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
          '/appointments/available-slots?doctor_id=$doctorId&date=$date&hospital_id=$hospitalId';
      final response = await _httpClient.get(baseURL);
      final res = AvailableTimeSlotResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message);
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  Response<String, AppointmentResponse> getAppointement({
    required int page,
    required String status,
  }) async {
    try {
      final response =
          await _httpClient.get('/me/appointments?page=$page&status=$status');
      final res = AppointmentResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message);
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  Response<String, BookAppointmentResponse> bookAppointment(
    BookAppointmentRequest request,
  ) async {
    try {
      log('Booking appointment with request: ${request.toJson()}');
      final response = await _httpClient.post(
        '/appointments/book',
        body: request.toJson(),
      );
      final res = BookAppointmentResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message);
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }
  // cancel appointment
  Response<String, String> cancelAppointment({
    required String appointmentId,
    required String reason,
  }) async {
    try {
      final response =
          await _httpClient.post('/appointments/$appointmentId/cancel', body: {
        'cancellation_reason': reason,
      });
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
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // add to cart
  Response<String, CartResponse> addToCart({
    required String phamacyProductId,
    required int quantity,
  }) async {
    try {
      final response = await _httpClient.post(
        '/cart/add',
        body: {
          'pharmacy_product_id': phamacyProductId,
          'quantity': quantity.toString(),
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
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // get cart
  Response<String, CartResponse> getCart() async {
    try {
      final response = await _httpClient.get('/cart');
      final cartResponse = CartResponse.fromJson(response);
      if (cartResponse.success) {
        return Right(cartResponse);
      } else {
        return Left(cartResponse.message);
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
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
        '/cart/items/$cartItemId',
        body: {
          'quantity': quantity,
        },
      );

      final cartResponse = CartResponse.fromJson(response);
      if (cartResponse.success) {
        return Right(cartResponse);
      } else {
        return Left(cartResponse.message);
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
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
      final response = await _httpClient.delete('/cart/items/$cartItemId');
      final cartResponse = CartResponse.fromJson(response);
      if (cartResponse.success) {
        return Right(cartResponse);
      } else {
        return Left(cartResponse.message);
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // get delivery type
  Response<String, DeliveryTypeResponse> getDeliveryType() async {
    try {
      final response = await _httpClient.get('/checkout/delivery-types');
      final deliveryTypeResponse = DeliveryTypeResponse.fromJson(response);
      if (deliveryTypeResponse.success) {
        return Right(deliveryTypeResponse);
      } else {
        return Left(deliveryTypeResponse.message);
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // get payment methods
  Response<String, PaymentMethodResponse> getPaymentMethods() async {
    try {
      final response = await _httpClient.get('/checkout/payment-methods');
      final res = PaymentMethodResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message);
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }

  // place order
  Response<String, String> placeOrder(PlaceOrderRequest request) async {
    try {
      final response = await _httpClient.post(
        '/checkout/place-order',
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
        '/ai/chat',
        body: {
          'message': message,
        },
      );
      final res = HealthBotChartResponse.fromJson(response);
      if (res.success) {
        return Right(res);
      } else {
        return Left(res.message);
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
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
        '/appointments/$appointmentId/reschedule',
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
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }
  Response<String, ServiceResponse> getServices() async {
    try {
      final response = await _httpClient.get('/services');
      final res = ServiceResponse.fromJson(response);
      if (res.success) {        return Right(res);
      } else {
        return Left(res.message);
      }
    } on ApiRequestFailure catch (e) {
      return Left(e.body['message'] as String);
    } on SocketException {
      return const Left('no_internet');
    } catch (e) {
      return const Left(
        'Something went wrong. Try again',
      );
    }
  }


  

}
