part of 'pet_listings_cubit.dart';

enum PetListingsStatus { initial, loading, success, failure }

class PetListingsState extends Equatable {
  const PetListingsState({
    this.status = PetListingsStatus.initial,
    this.listings = const [],
    this.errorMessage,
  });

  final PetListingsStatus status;
  final List<PetListing> listings;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, listings, errorMessage];

  PetListingsState copyWith({
    PetListingsStatus? status,
    List<PetListing>? listings,
    String? errorMessage,
  }) {
    return PetListingsState(
      status: status ?? this.status,
      listings: listings ?? this.listings,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
