import 'dart:async';

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

  static const _pollingInterval = Duration(seconds: 5);
  static const _paymentTimeout = Duration(minutes: 15);

  Future<void> placeOrder({
    required String fulfillmentType,
    required String paymentMethodId,
    required String paymentMethodName,
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
        final isKhqr = paymentMethodName.toUpperCase() == 'KHQR';

        if (isKhqr) {
          // KHQR payment — show payment screen with deeplink/QR + start polling
          emit(state.copyWith(
            status: OrderStatus.paymentPending,
            order: res.order,
            paymentInfo: res.paymentInfo,
            remainingSeconds: _paymentTimeout.inSeconds,
          ));
          _startPolling(res.order!.id);
          _startCountdown();
        } else {
          // Non-KHQR (e.g. Cash on Delivery) — show order confirmation
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
          // success: true but not yet paid — keep polling
        },
        failure: (error) async {
          // 422 "Payment not found or not completed yet." — keep polling
          // Other errors — also keep polling (don't break the flow)
        },
      );
    } catch (_) {
      // Network error etc — keep polling
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
