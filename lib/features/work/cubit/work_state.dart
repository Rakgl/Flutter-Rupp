part of 'work_cubit.dart';

enum WorkStatus { initial, loading, success, failure }

class WorkState {
  const WorkState({
    this.status = WorkStatus.initial,
  });

  final WorkStatus status;
}
