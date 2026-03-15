// cubit/profile_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const ProfileState());

  final UserRepository _userRepository;

  void togglePush(bool value) {
    emit(state.copyWith(isPushEnabled: value));
  }

  void toggleDarkMode(bool value) {
    emit(state.copyWith(isDarkMode: value));
  }

  Future<void> logout() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final success = await _userRepository.signOut();
    if (success) {
      emit(state.copyWith(status: ProfileStatus.logoutSuccess));
    } else {
      emit(state.copyWith(status: ProfileStatus.failure));
    }
  }

  void updateProfile({
    String? name,
    String? email,
    String? location,
    String? phone,
  }) {
    emit(state.copyWith(
      name: name,
      email: email,
      location: location,
      phone: phone,
    ));
  }
}
