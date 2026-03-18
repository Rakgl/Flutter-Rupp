import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:api_http_client/api_http_client.dart';
import 'package:repository/repository.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit({required OrderRepository orderRepository})
      : _orderRepository = orderRepository,
        super(const OrderState());

  final OrderRepository _orderRepository;
  Timer? _pollingTimer;
  Timer? _countdownTimer;

  static const _pollingInterval = Duration(seconds: 4);
  static const _paymentTimeout = Duration(minutes: 15);

  Future<void> placeOrder({
    required String fulfillmentType,
    String? paymentMethodId,
    String? deliveryAddress,
  }) async {
    emit(state.copyWith(status: OrderStatus.loading));

    final response = await _orderRepository.placeOrder(
      fulfillmentType: fulfillmentType,
      paymentMethodId: paymentMethodId,
      deliveryAddress: deliveryAddress,
    );

    await response.when<void>(
      success: (OrderResponse res) async {
        if (res.paymentInfo != null) {
          // KHQR payment — navigate to payment screen
          emit(state.copyWith(
            status: OrderStatus.paymentPending,
            order: res.order,
            paymentInfo: res.paymentInfo,
            remainingSeconds: _paymentTimeout.inSeconds,
          ));
          _startPolling(res.order!.id);
          _startCountdown();
        } else {
          // Non-KHQR payment — order placed directly
          emit(state.copyWith(
            status: OrderStatus.success,
            order: res.order,
          ));
        }
      },
      failure: (error) async {
        emit(state.copyWith(
          status: OrderStatus.failure,
          errorMessage: error,
        ));
      },
    );
  }

  void _startPolling(String orderId) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(_pollingInterval, (_) async {
      if (state.status != OrderStatus.paymentPending) {
        _pollingTimer?.cancel();
        return;
      }
      await _verifyPayment(orderId);
    });
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final remaining = state.remainingSeconds - 1;
      if (remaining <= 0) {
        _stopTimers();
        emit(state.copyWith(
          status: OrderStatus.paymentExpired,
          remainingSeconds: 0,
        ));
      } else {
        emit(state.copyWith(remainingSeconds: remaining));
      }
    });
  }

  Future<void> _verifyPayment(String orderId) async {
    try {
      final response = await _orderRepository.verifyPayment(orderId: orderId);
      await response.when<void>(
        success: (OrderResponse res) async {
          if (res.order != null && res.order!.isPaid) {
            _stopTimers();
            emit(state.copyWith(
              status: OrderStatus.paymentConfirmed,
              order: res.order,
            ));
          }
        },
        failure: (error) async {
          // Payment not yet confirmed — keep polling
          log('[OrderCubit] Payment not yet confirmed: $error');
        },
      );
    } catch (e) {
      log('[OrderCubit] Error verifying payment: $e');
    }
  }

  Future<void> cancelOrder() async {
    final orderId = state.order?.id;
    if (orderId == null) return;

    emit(state.copyWith(status: OrderStatus.cancelling));
    _stopTimers();

    final response = await _orderRepository.cancelOrder(orderId: orderId);
    await response.when<void>(
      success: (OrderResponse res) async {
        emit(state.copyWith(
          status: OrderStatus.cancelled,
          order: res.order,
        ));
      },
      failure: (error) async {
        emit(state.copyWith(
          status: OrderStatus.failure,
          errorMessage: error,
        ));
      },
    );
  }

  void _stopTimers() {
    _pollingTimer?.cancel();
    _countdownTimer?.cancel();
  }

  void reset() {
    _stopTimers();
    emit(const OrderState());
  }

  @override
  Future<void> close() {
    _stopTimers();
    return super.close();
  }
}
