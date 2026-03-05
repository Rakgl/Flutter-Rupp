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
  }) async {
    emit(state.copyWith(status: LoginStatus.loading));

    try {
      final request = SignInRequest(
        username: username,
        password: password,
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
