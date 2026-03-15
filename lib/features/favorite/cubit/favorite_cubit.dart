import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:api_http_client/api_http_client.dart';
import 'package:repository/repository.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit({required FavoriteRepository favoriteRepository})
      : _favoriteRepository = favoriteRepository,
        super(const FavoriteState());

  final FavoriteRepository _favoriteRepository;

  Future<void> fetchFavorites() async {
    emit(state.copyWith(status: FavoriteStatus.loading));
    final response = await _favoriteRepository.getFavorites();
    await response.when<void>(
      success: (FavoriteResponse favoriteResponse) async {
        log('[FavoriteCubit] Successfully fetched ${favoriteResponse.favorites.length} favorites');
        emit(
          state.copyWith(
            status: FavoriteStatus.success,
            favorites: favoriteResponse.favorites,
          ),
        );
      },
      failure: (String error) async {
        log('[FavoriteCubit] Failed to fetch favorites: $error');
        emit(
          state.copyWith(
            status: FavoriteStatus.failure,
            errorMessage: error,
          ),
        );
      },
    );
  }

  Future<void> toggleFavorite({
    required String id,
    required String itemType,
  }) async {
    final response =
        await _favoriteRepository.toggleFavorite(id: id, itemType: itemType);
    await response.when<void>(
      success: (ToggleFavoriteResponse toggleResponse) async {
        // After toggling, fetch the updated list of favorites
        await fetchFavorites();
      },
      failure: (String error) async {
        // Optionally, handle failure, e.g., show an error message
      },
    );
  }
}
