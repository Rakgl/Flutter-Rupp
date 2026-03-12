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
        emit(
          state.copyWith(
            status: FavoriteStatus.success,
            favorites: favoriteResponse.favorites,
          ),
        );
      },
      failure: (String error) async {
        emit(
          state.copyWith(
            status: FavoriteStatus.failure,
            errorMessage: error,
          ),
        );
      },
    );
  }

  Future<void> addFavorite(String id) async {
    final response = await _favoriteRepository.addFavorite(id: id);
    await response.when<void>(
      success: (String message) async {
        // After adding, fetch the updated list of favorites
        await fetchFavorites();
      },
      failure: (String error) async {
        // Optionally, handle failure, e.g., show an error message
      },
    );
  }

  Future<void> removeFavorite(String id) async {
    final response = await _favoriteRepository.removeFavorite(id: id);
    await response.when<void>(
      success: (String message) async {
        // After removing, fetch the updated list of favorites
        await fetchFavorites();
      },
      failure: (String error) async {
        // Optionally, handle failure
      },
    );
  }
}
