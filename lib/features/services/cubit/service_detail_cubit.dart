import 'package:bloc/bloc.dart';
import 'package:api_http_client/api_http_client.dart';
import 'package:repository/repository.dart';

part 'service_detail_state.dart';

class ServiceDetailCubit extends Cubit<ServiceDetailState> {
  ServiceDetailCubit({required ServiceRepository serviceRepository})
      : _serviceRepository = serviceRepository,
        super(const ServiceDetailState());

  final ServiceRepository _serviceRepository;

  Future<void> fetchService({required String id}) async {
    emit(state.copyWith(status: ServiceDetailStatus.loading));
    final result = await _serviceRepository.getService(id: id);
    await result.when<void>(
      success: (ServiceDetailResponse response) async {
        emit(state.copyWith(
          status: ServiceDetailStatus.success,
          service: response.service,
        ));
      },
      failure: (String error) async {
        emit(state.copyWith(
          status: ServiceDetailStatus.failure,
          errorMessage: error,
        ));
      },
    );
  }
}
