part of 'schedule_cubit.dart';

enum ScheduleViewType { list, calendar }

class Appointment extends Equatable {
  const Appointment({
    required this.title,
    required this.clientName,
    required this.address,
    required this.time,
    required this.dateLabel,
  });

  final String title;
  final String clientName;
  final String address;
  final String time;
  final String dateLabel;

  @override
  List<Object> get props => [title, clientName, address, time, dateLabel];
}

class ScheduleState extends Equatable {
  const ScheduleState({
    this.viewType = ScheduleViewType.list,
    this.appointments = const [],
    this.focusedDay,
    this.selectedDay,
  });

  final ScheduleViewType viewType;
  final List<Appointment> appointments;
  final DateTime? focusedDay;
  final DateTime? selectedDay;

  @override
  List<Object?> get props => [viewType, appointments, focusedDay, selectedDay];

  ScheduleState copyWith({
    ScheduleViewType? viewType,
    List<Appointment>? appointments,
    DateTime? focusedDay,
    DateTime? selectedDay,
  }) {
    return ScheduleState(
      viewType: viewType ?? this.viewType,
      appointments: appointments ?? this.appointments,
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: selectedDay ?? this.selectedDay,
    );
  }
}
