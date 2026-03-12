import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:api_http_client/api_http_client.dart';
import 'package:repository/repository.dart';

part 'appointments_state.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  AppointmentsCubit({required AppointmentRepository appointmentRepository})
      : _appointmentRepository = appointmentRepository,
        super(const AppointmentsState());

  final AppointmentRepository _appointmentRepository;

  Future<void> fetchAppointments({int page = 1, String status = 'all'}) async {
    emit(state.copyWith(status: AppointmentsStatus.loading));
    final response = await _appointmentRepository.getAppointments(
      page: page,
      status: status,
    );
    await response.when<void>(
      success: (AppointmentResponse appointmentResponse) async {
        emit(
          state.copyWith(
            status: AppointmentsStatus.success,
            appointments: appointmentResponse.appointments,
            isReachMax: appointmentResponse.isReachMax,
          ),
        );
      },
      failure: (String error) async {
        emit(
          state.copyWith(
            status: AppointmentsStatus.failure,
            errorMessage: error,
          ),
        );
      },
    );
  }

  Future<void> cancelAppointment({
    required String appointmentId,
    required String reason,
  }) async {
    emit(state.copyWith(status: AppointmentsStatus.loading));
    final response = await _appointmentRepository.cancelAppointment(
      appointmentId: appointmentId,
      reason: reason,
    );
    await response.when<void>(
      success: (String successMsg) async {
        // Just refetch after cancel
        fetchAppointments();
      },
      failure: (String error) async {
        emit(
          state.copyWith(
            status: AppointmentsStatus.failure,
            errorMessage: error,
          ),
        );
      },
    );
  }
}
