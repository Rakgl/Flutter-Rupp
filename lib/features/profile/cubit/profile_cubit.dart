// cubit/profile_cubit.dart
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:repository/repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const ProfileState());

  final UserRepository _userRepository;

  Future<void> loadProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final response = await _userRepository.getUserProfile();
    await response.when(
      success: (data) async {
        if (isClosed) return;
        emit(state.copyWith(
          status: ProfileStatus.success,
          name: data.user.name,
          email: data.user.email,
          phone: data.user.phone,
          image: data.user.image,
          deliveryAddress: data.user.deliveryAddress,
        ));
      },
      failure: (error) async {
        if (isClosed) return;
        emit(state.copyWith(status: ProfileStatus.failure, errorMessage: error));
      },
    );
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      emit(state.copyWith(pickedImage: File(picked.path)));
    }
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? deliveryAddress,
  }) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final response = await _userRepository.updateUserProfile(
      name: name,
      email: email,
      deliveryAddress: deliveryAddress,
      image: state.pickedImage,
    );
    await response.when(
      success: (data) async {
        if (isClosed) return;
        emit(state.copyWith(
          status: ProfileStatus.updateSuccess,
          name: data.user.name,
          email: data.user.email,
          phone: data.user.phone,
          image: data.user.image,
          deliveryAddress: data.user.deliveryAddress,
        ));
      },
      failure: (error) async {
        if (isClosed) return;
        emit(state.copyWith(status: ProfileStatus.failure, errorMessage: error));
      },
    );
  }

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
}
