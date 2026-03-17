part of 'appointments_cubit.dart';

enum AppointmentsStatus { initial, loading, success, failure }

class AppointmentsState extends Equatable {
  const AppointmentsState({
    this.status = AppointmentsStatus.initial,
    this.appointments = const <AppointmentModel>[],
    this.isReachMax = false,
    this.errorMessage,
    this.lastBookedAppointment,
  });

  final AppointmentsStatus status;
  final List<AppointmentModel> appointments;
  final bool isReachMax;
  final String? errorMessage;
  final AppointmentModel? lastBookedAppointment;

  AppointmentsState copyWith({
    AppointmentsStatus? status,
    List<AppointmentModel>? appointments,
    bool? isReachMax,
    String? errorMessage,
    bool clearErrorMessage = false,
    AppointmentModel? lastBookedAppointment,
    bool clearLastBookedAppointment = false,
  }) {
    return AppointmentsState(
      status: status ?? this.status,
      appointments: appointments ?? this.appointments,
      isReachMax: isReachMax ?? this.isReachMax,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      lastBookedAppointment: clearLastBookedAppointment
          ? null
          : (lastBookedAppointment ?? this.lastBookedAppointment),
    );
  }

  @override
  List<Object?> get props =>
      [status, appointments, isReachMax, errorMessage, lastBookedAppointment];
}
