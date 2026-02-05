import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/user_repository.dart';
import 'package:api_http_client/api_http_client.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required UserRepository userRepository,
  }) : _userRepository = userRepository,
       super(const LoginState());

  final UserRepository _userRepository;

  Future<void> login({
    required String username,
    required String password,
    String appContext = 'professional',
  }) async {
    emit(state.copyWith(status: LoginStatus.loading));

    try {
      // Generate a unique device ID (you might want to store this persistently)
      final deviceId =
          '${DateTime.now().millisecondsSinceEpoch}-${username.hashCode}';

      final request = SignInRequest(
        username: username,
        password: password,
        appContext: appContext,
        deviceId: deviceId,
      );

      final response = await _userRepository.signIn(request);

      await response.when<SignInResponse>(
        success: (data) async {
          emit(state.copyWith(status: LoginStatus.success));
        },
        failure: (String error) async {
          emit(
            state.copyWith(
              status: LoginStatus.failure,
              errorMessage: error,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: 'An unexpected error occurred',
        ),
      );
    }
  }
}
