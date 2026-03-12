import 'package:bloc/bloc.dart';
import 'package:api_http_client/api_http_client.dart';
import 'package:repository/repository.dart';
import 'pet_detail_state.dart';

class PetDetailCubit extends Cubit<PetDetailState> {
  PetDetailCubit({
    required PetRepository petRepository,
  })  : _petRepository = petRepository,
        super(const PetDetailState());

  final PetRepository _petRepository;

  Future<void> fetchPet(String id) async {
    emit(state.copyWith(status: PetDetailStatus.loading));
    final response = await _petRepository.getPet(id: id);
    await response.when<void>(
      success: (PetDetailResponse detailResponse) async {
        emit(
          state.copyWith(
            status: PetDetailStatus.success,
            pet: detailResponse.pet,
          ),
        );
      },
      failure: (String error) async {
        emit(
          state.copyWith(
            status: PetDetailStatus.failure,
            errorMessage: error,
          ),
        );
      },
    );
  }
}
