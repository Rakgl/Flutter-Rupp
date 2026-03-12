import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:api_http_client/api_http_client.dart';
import 'package:repository/repository.dart';

part 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  ServicesCubit({required ServiceRepository serviceRepository})
      : _serviceRepository = serviceRepository,
        super(const ServicesState());

  final ServiceRepository _serviceRepository;

  Future<void> fetchServices() async {
    emit(state.copyWith(status: ServicesStatus.loading));
    final response = await _serviceRepository.getServices();
    await response.when<void>(
      success: (ServiceResponse serviceResponse) async {
        emit(
          state.copyWith(
            status: ServicesStatus.success,
            services: serviceResponse.services,
            isReachMax: serviceResponse.isReachMax,
          ),
        );
      },
      failure: (String error) async {
        emit(
          state.copyWith(
            status: ServicesStatus.failure,
            errorMessage: error,
          ),
        );
      },
    );
  }
}
