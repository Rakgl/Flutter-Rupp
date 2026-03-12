import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:api_http_client/api_http_client.dart';
import 'package:repository/repository.dart';

part 'card_state.dart';

class CardCubit extends Cubit<CardState> {
  CardCubit({required CartRepository cartRepository})
      : _cartRepository = cartRepository,
        super(const CardState());

  final CartRepository _cartRepository;

  Future<void> fetchCart() async {
    emit(state.copyWith(status: CardStatus.loading));
    final response = await _cartRepository.getCart();
    await response.when<void>(
      success: (CartResponse cartResponse) async {
        emit(
          state.copyWith(
            status: CardStatus.success,
            cartData: cartResponse.carts,
          ),
        );
      },
      failure: (error) async {
        emit(
          state.copyWith(
            status: CardStatus.failure,
            errorMessage: error,
          ),
        );
      },
    );
  }

  Future<void> clearCart() async {
    emit(state.copyWith(status: CardStatus.loading));
    final response = await _cartRepository.clearCart();
    await response.when<void>(
      success: (CartResponse cartResponse) async {
        emit(
          state.copyWith(
            status: CardStatus.success,
            cartData: cartResponse.carts,
          ),
        );
      },
      failure: (error) async {
        emit(
          state.copyWith(
            status: CardStatus.failure,
            errorMessage: error,
          ),
        );
      },
    );
  }

  Future<void> addToCart(String id, {String itemType = 'product'}) async {
    // We don't necessarily want to show a full-page loading spinner for adding to cart
    // so we skip mutating to loading status, just silently call it and update on success
    final response = await _cartRepository.addToCart(itemId: id, itemType: itemType, quantity: 1);
    await response.when<void>(
      success: (CartResponse cartResponse) async {
        emit(
          state.copyWith(
            status: CardStatus.success,
            cartData: cartResponse.carts,
          ),
        );
      },
      failure: (error) async {
        emit(
          state.copyWith(
            status: CardStatus.failure,
            errorMessage: error,
          ),
        );
      },
    );
  }

  Future<void> updateCart(String cartItemId, int quantity) async {
    final response = await _cartRepository.updateCart(
      cartItemId: cartItemId,
      quantity: quantity,
    );
    await response.when<void>(
      success: (CartResponse cartResponse) async {
        emit(
          state.copyWith(
            status: CardStatus.success,
            cartData: cartResponse.carts,
          ),
        );
      },
      failure: (error) async {
        emit(
          state.copyWith(
            status: CardStatus.failure,
            errorMessage: error,
          ),
        );
      },
    );
  }

  Future<void> removeCartItem(String cartItemId) async {
    final response = await _cartRepository.removeCartItem(
      cartItemId: cartItemId,
    );
    await response.when<void>(
      success: (CartResponse cartResponse) async {
        emit(
          state.copyWith(
            status: CardStatus.success,
            cartData: cartResponse.carts,
          ),
        );
      },
      failure: (error) async {
        emit(
          state.copyWith(
            status: CardStatus.failure,
            errorMessage: error,
          ),
        );
      },
    );
  }
}
