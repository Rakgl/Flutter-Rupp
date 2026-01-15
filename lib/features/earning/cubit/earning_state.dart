part of 'earning_cubit.dart';

enum EarningStatus { initial, loading, success, failure }

class EarningState {
  const EarningState({
    this.status = EarningStatus.initial,
  });

  final EarningStatus status;
}
