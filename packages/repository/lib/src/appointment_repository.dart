import 'package:api_http_client/api_http_client.dart';

class AppointmentRepository {
  AppointmentRepository({
    required ApiHttpClient apiClient,
  }) : _apiClient = apiClient;

  final ApiHttpClient _apiClient;

  Response<String, AppointmentResponse> getAppointments({
    int page = 1,
  }) async {
    final response = await _apiClient.getAppointments(
      page: page,
    );
    return response;
  }

  Response<String, AppointmentDetailResponse> getAppointment({
    required String id,
  }) async {
    final response = await _apiClient.getAppointmentDetail(id: id);
    return response;
  }

  Response<String, AppointmentDetailResponse> bookAppointment(
    BookAppointmentRequest request,
  ) async {
    final response = await _apiClient.bookAppointment(request);
    return response;
  }

  Response<String, AppointmentDetailResponse> cancelAppointment({
    required String appointmentId,
  }) async {
    final response = await _apiClient.cancelAppointment(
      appointmentId: appointmentId,
    );
    return response;
  }
}
