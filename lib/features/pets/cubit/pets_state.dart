part of 'pets_cubit.dart';

enum PetsStatus { initial, loading, success, failure }

class PetsState extends Equatable {
  const PetsState({
    this.status = PetsStatus.initial,
    this.pets = const <Pet>[],
    this.isReachMax = false,
    this.errorMessage,
  });

  final PetsStatus status;
  final List<Pet> pets;
  final bool isReachMax;
  final String? errorMessage;

  PetsState copyWith({
    PetsStatus? status,
    List<Pet>? pets,
    bool? isReachMax,
    String? errorMessage,
  }) {
    return PetsState(
      status: status ?? this.status,
      pets: pets ?? this.pets,
      isReachMax: isReachMax ?? this.isReachMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, pets, isReachMax, errorMessage];
}
