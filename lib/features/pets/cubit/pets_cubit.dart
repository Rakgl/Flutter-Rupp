import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:api_http_client/api_http_client.dart';
import 'package:repository/repository.dart';

part 'pets_state.dart';

class PetsCubit extends Cubit<PetsState> {
  PetsCubit({required PetRepository petRepository})
      : _petRepository = petRepository,
        super(const PetsState());

  final PetRepository _petRepository;

  Future<void> addPet({
    required String name,
    String? species,
    String? breed,
    String? weight,
    String? dateOfBirth,
    File? image,
  }) async {
    emit(state.copyWith(status: PetsStatus.loading));
    final response = await _petRepository.addPet(
      name: name,
      species: species,
      breed: breed,
      weight: weight,
      dateOfBirth: dateOfBirth,
      image: image,
    );
    await response.when<void>(
      success: (Pet pet) async {
        // Success: Refetch the personal pet list
        await fetchPets();
      },
      failure: (String error) async {
        emit(
          state.copyWith(
            status: PetsStatus.failure,
            errorMessage: error,
          ),
        );
      },
    );
  }

  Future<void> fetchPets({
    String? categoryId,
    String? search,
  }) async {
    emit(state.copyWith(status: PetsStatus.loading));
    final response = await _petRepository.getPets(
      categoryId: categoryId,
      search: search,
    );
    await response.when<void>(
      success: (PetResponse petResponse) async {
        emit(
          state.copyWith(
            status: PetsStatus.success,
            pets: petResponse.pets,
          ),
        );
      },
      failure: (String error) async {
        emit(
          state.copyWith(
            status: PetsStatus.failure,
            errorMessage: error,
          ),
        );
      },
    );
  }
}
