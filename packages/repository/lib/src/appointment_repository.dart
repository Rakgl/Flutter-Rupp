import 'package:api_http_client/api_http_client.dart';

class AppointmentRepository {
  AppointmentRepository({
    required ApiHttpClient apiClient,
  }) : _apiClient = apiClient;

  final ApiHttpClient _apiClient;

  Response<String, AppointmentResponse> getAppointments({
    required int page,
    required String status,
  }) async {
    final response = await _apiClient.getAppointement(
      page: page,
      status: status,
    );
    return response;
  }

  Response<String, AppointmentDetailResponse> getAppointment({
    required String id,
  }) async {
    final response = await _apiClient.getAppointmentDetail(id: id);
    return response;
  }

  Response<String, AvailableTimeSlotResponse> getAvailableTimeSlots({
    required String doctorId,
    required String hospitalId,
    required String date,
  }) async {
    final response = await _apiClient.availableTimeSlot(
      doctorId: doctorId,
      hospitalId: hospitalId,
      date: date,
    );
    return response;
  }

  Response<String, BookAppointmentResponse> bookAppointment(
    BookAppointmentRequest request,
  ) async {
    final response = await _apiClient.bookAppointment(request);
    return response;
  }

  Response<String, String> cancelAppointment({
    required String appointmentId,
    required String reason,
  }) async {
    final response = await _apiClient.cancelAppointment(
      appointmentId: appointmentId,
      reason: reason,
    );
    return response;
  }

  Response<String, String> rescheduleAppointment({
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
