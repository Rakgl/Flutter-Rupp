import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit() : super(ScheduleState(focusedDay: DateTime.now(), selectedDay: DateTime.now())) {
    _loadInitialData();
  }

  void _loadInitialData() {
    emit(state.copyWith(
      appointments: [
        const Appointment(
          title: 'Electrical Panel Upgrade',
          clientName: 'Peter Parker',
          address: '123 Main St, San Francisco',
          time: '10:00 AM',
          dateLabel: 'THURSDAY, DECEMBER 18',
        ),
        const Appointment(
          title: 'Lighting Installation',
          clientName: 'Sue Storm',
          address: '456 Oak Ave, Oakland',
          time: '2:00 PM',
          dateLabel: 'THURSDAY, DECEMBER 18',
        ),
        const Appointment(
          title: 'Circuit Breaker Repair',
          clientName: 'Sam Wilson',
          address: '789 Pine St, Berkeley',
          time: '9:00 AM',
          dateLabel: 'FRIDAY, DECEMBER 19',
        ),
        const Appointment(
          title: 'Wiring & Rewiring',
          clientName: 'Scott Lang',
          address: '321 Elm Dr, San Francisco',
          time: '11:00 AM',
          dateLabel: 'SATURDAY, DECEMBER 20',
        ),
      ],
    ));
  }

  void toggleView(ScheduleViewType type) => emit(state.copyWith(viewType: type));

  void selectDay(DateTime selected, DateTime focused) {
    emit(state.copyWith(selectedDay: selected, focusedDay: focused));
  }
}
