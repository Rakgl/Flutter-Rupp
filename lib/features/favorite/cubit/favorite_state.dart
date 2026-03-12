part of 'favorite_cubit.dart';

enum FavoriteStatus { initial, loading, success, failure }

class FavoriteState extends Equatable {
  const FavoriteState({
    this.status = FavoriteStatus.initial,
    this.favorites = const [],
    this.errorMessage,
  });

  final FavoriteStatus status;
  final List<FavoriteItemModel> favorites;
  final String? errorMessage;

  FavoriteState copyWith({
    FavoriteStatus? status,
    List<FavoriteItemModel>? favorites,
    String? errorMessage,
  }) {
    return FavoriteState(
      status: status ?? this.status,
      favorites: favorites ?? this.favorites,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, favorites, errorMessage];
}
