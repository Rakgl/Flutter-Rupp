part of 'services_cubit.dart';

enum ServicesStatus { initial, loading, success, failure }

class ServicesState extends Equatable {
  const ServicesState({
    this.status = ServicesStatus.initial,
    this.services = const <ServiceModel>[],
    this.isReachMax = false,
    this.errorMessage,
  });

  final ServicesStatus status;
  final List<ServiceModel> services;
  final bool isReachMax;
  final String? errorMessage;

  ServicesState copyWith({
    ServicesStatus? status,
    List<ServiceModel>? services,
    bool? isReachMax,
    String? errorMessage,
  }) {
    return ServicesState(
      status: status ?? this.status,
      services: services ?? this.services,
      isReachMax: isReachMax ?? this.isReachMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, services, isReachMax, errorMessage];
}
