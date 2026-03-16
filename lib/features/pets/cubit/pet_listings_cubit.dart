import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:api_http_client/api_http_client.dart';
import 'package:repository/repository.dart';

part 'pet_listings_state.dart';

class PetListingsCubit extends Cubit<PetListingsState> {
  PetListingsCubit({required PetListingRepository petListingRepository})
      : _petListingRepository = petListingRepository,
        super(const PetListingsState());

  final PetListingRepository _petListingRepository;

  Future<void> fetchListings({
    String? categoryId,
    String? search,
  }) async {
    emit(state.copyWith(status: PetListingsStatus.loading));
    final response = await _petListingRepository.getPetListings(
      categoryId: categoryId,
      search: search,
    );
    await response.when<void>(
      success: (PetResponse petResponse) async {
        emit(
          state.copyWith(
            status: PetListingsStatus.success,
            listings: petResponse.listings ?? [],
          ),
        );
      },
      failure: (String error) async {
        emit(
          state.copyWith(
            status: PetListingsStatus.failure,
            errorMessage: error,
          ),
        );
      },
    );
  }
}
