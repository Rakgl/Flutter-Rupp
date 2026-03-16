part of 'card_cubit.dart';

enum CardStatus { initial, loading, success, failure }

class CardState extends Equatable {
  const CardState({
    this.status = CardStatus.initial,
    this.cartData,
    this.checkoutConfig,
    this.errorMessage,
  });

  final CardStatus status;
  final CartModel? cartData;
  final CheckoutConfigResponse? checkoutConfig;
  final String? errorMessage;

  CardState copyWith({
    CardStatus? status,
    CartModel? cartData,
    CheckoutConfigResponse? checkoutConfig,
    String? errorMessage,
  }) {
    return CardState(
      status: status ?? this.status,
      cartData: cartData ?? this.cartData,
      checkoutConfig: checkoutConfig ?? this.checkoutConfig,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, cartData, checkoutConfig, errorMessage];
}
