part of 'signup_cubit.dart';

enum SignupStatus { initial, loading, otpRequested, otpVerified, success, failure }

class SignupState extends Equatable {
  const SignupState({
    this.status = SignupStatus.initial,
    this.phoneNumber = '',
    this.countryCode = '',
    this.transactionCode = '',
    this.errorMessage,
  });

  final SignupStatus status;
  final String phoneNumber;
  final String countryCode;
  final String transactionCode;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, phoneNumber, countryCode, transactionCode, errorMessage];

  SignupState copyWith({
    SignupStatus? status,
    String? phoneNumber,
    String? countryCode,
    String? transactionCode,
    String? errorMessage,
  }) {
    return SignupState(
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
      transactionCode: transactionCode ?? this.transactionCode,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
