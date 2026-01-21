// cubit/profile_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());

  void togglePush(bool value) {
    emit(state.copyWith(isPushEnabled: value));
  }

  void toggleDarkMode(bool value) {
    emit(state.copyWith(isDarkMode: value));
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
