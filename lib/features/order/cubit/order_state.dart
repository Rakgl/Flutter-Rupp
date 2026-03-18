part of 'order_cubit.dart';

enum OrderStatus {
  initial,
  loading,
  paymentPending,
  paymentConfirmed,
  paymentExpired,
  cancelling,
  cancelled,
  success,
  failure,
}

class OrderState extends Equatable {
  const OrderState({
    this.status = OrderStatus.initial,
    this.order,
    this.paymentInfo,
    this.remainingSeconds = 0,
    this.errorMessage,
  });

  final OrderStatus status;
  final OrderModel? order;
  final PaymentInfoModel? paymentInfo;
  final int remainingSeconds;
  final String? errorMessage;

  String get formattedCountdown {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  OrderState copyWith({
    OrderStatus? status,
    OrderModel? order,
    PaymentInfoModel? paymentInfo,
    int? remainingSeconds,
    String? errorMessage,
  }) {
    return OrderState(
      status: status ?? this.status,
      order: order ?? this.order,
      paymentInfo: paymentInfo ?? this.paymentInfo,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        order?.id,
        paymentInfo?.transactionNo,
        remainingSeconds,
        errorMessage,
      ];
}
