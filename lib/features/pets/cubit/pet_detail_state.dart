import 'package:equatable/equatable.dart';
import 'package:api_http_client/api_http_client.dart';

enum PetDetailStatus { initial, loading, success, failure }

class PetDetailState extends Equatable {
  const PetDetailState({
    this.status = PetDetailStatus.initial,
    this.pet,
    this.errorMessage,
  });

  final PetDetailStatus status;
  final Pet? pet;
  final String? errorMessage;

  PetDetailState copyWith({
    PetDetailStatus? status,
    Pet? pet,
    String? errorMessage,
  }) {
    return PetDetailState(
      status: status ?? this.status,
      pet: pet ?? this.pet,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, pet, errorMessage];
}
