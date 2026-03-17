import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const SignupState());

  final UserRepository _userRepository;

  /// Step A: Request OTP
  Future<void> requestOtp({required String phone, required String countryCode}) async {
    if (isClosed) return;
    emit(state.copyWith(status: SignupStatus.loading, phoneNumber: phone, countryCode: countryCode));

    final response = await _userRepository.verifyPhoneNumber(
      phone: phone,
      countryCode: countryCode,
    );

    await response.when(
      success: (transactionCode) async {
        if (isClosed) return;
        emit(state.copyWith(
          status: SignupStatus.otpRequested,
          transactionCode: transactionCode,
        ));
      },
      failure: (error) async {
        if (isClosed) return;
        emit(state.copyWith(status: SignupStatus.failure, errorMessage: error));
      },
    );
  }

  /// Step B: Verify OTP
  Future<void> verifyOtp({required String otp}) async {
    if (isClosed) return;
    emit(state.copyWith(status: SignupStatus.loading));

    final response = await _userRepository.verifyOTP(
      otp: otp,
      transactionCode: state.transactionCode,
    );

    await response.when(
      success: (_) async {
        if (isClosed) return;
        emit(state.copyWith(status: SignupStatus.otpVerified));
      },
      failure: (error) async {
        if (isClosed) return;
        emit(state.copyWith(status: SignupStatus.failure, errorMessage: error));
      },
    );
  }

  /// Step C: Complete Registration
  Future<void> completeRegistration({
    required String name,
    required String password,
    required String passwordConfirmation,
  }) async {
    if (isClosed) return;
    emit(state.copyWith(status: SignupStatus.loading));

    final response = await _userRepository.register(
      phone: state.phoneNumber,
      name: name,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    await response.when(
      success: (_) async {
        if (isClosed) return;
        emit(state.copyWith(status: SignupStatus.success));
      },
      failure: (error) async {
        if (isClosed) return;
        emit(state.copyWith(status: SignupStatus.failure, errorMessage: error));
      },
    );
  }

  void resetStatus() {
    if (isClosed) return;
    emit(state.copyWith(status: SignupStatus.initial, errorMessage: null));
  }
}
