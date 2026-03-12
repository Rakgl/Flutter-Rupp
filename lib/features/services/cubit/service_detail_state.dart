part of 'service_detail_cubit.dart';

enum ServiceDetailStatus { initial, loading, success, failure }

class ServiceDetailState {
  const ServiceDetailState({
    this.status = ServiceDetailStatus.initial,
    this.service,
    this.errorMessage,
  });

  final ServiceDetailStatus status;
  final ServiceModel? service;
  final String? errorMessage;

  ServiceDetailState copyWith({
    ServiceDetailStatus? status,
    ServiceModel? service,
    String? errorMessage,
  }) {
    return ServiceDetailState(
      status: status ?? this.status,
      service: service ?? this.service,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
