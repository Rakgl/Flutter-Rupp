part of 'card_cubit.dart';

enum CardStatus { initial, loading, success, failure }

class CardState extends Equatable {
  const CardState({
    this.status = CardStatus.initial,
    this.cartData,
    this.errorMessage,
  });

  final CardStatus status;
  final CartModel? cartData;
  final String? errorMessage;

  CardState copyWith({
    CardStatus? status,
    CartModel? cartData,
    String? errorMessage,
  }) {
    return CardState(
      status: status ?? this.status,
      cartData: cartData ?? this.cartData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, cartData, errorMessage];
}
