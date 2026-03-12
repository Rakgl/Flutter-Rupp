part of 'appointments_cubit.dart';

enum AppointmentsStatus { initial, loading, success, failure }

class AppointmentsState extends Equatable {
  const AppointmentsState({
    this.status = AppointmentsStatus.initial,
    this.appointments = const <AppointmentModel>[],
    this.isReachMax = false,
    this.errorMessage,
  });

  final AppointmentsStatus status;
  final List<AppointmentModel> appointments;
  final bool isReachMax;
  final String? errorMessage;

  AppointmentsState copyWith({
    AppointmentsStatus? status,
    List<AppointmentModel>? appointments,
    bool? isReachMax,
    String? errorMessage,
  }) {
    return AppointmentsState(
      status: status ?? this.status,
      appointments: appointments ?? this.appointments,
      isReachMax: isReachMax ?? this.isReachMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, appointments, isReachMax, errorMessage];
}
