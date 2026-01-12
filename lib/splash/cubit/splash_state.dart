part of 'splash_cubit.dart';

enum SplashStatus {
  initial,
  loading,
  loaded,
  error,
}

class SplashState extends Equatable {
  const SplashState({
    this.status = SplashStatus.initial,
  });

  final SplashStatus status;

  // copy with
  SplashState copyWith({
    SplashStatus? status,
  }) {
    return SplashState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [status];
}
