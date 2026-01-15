import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'welcome_state.dart';

class WelcomeCubit extends Cubit<WelcomeState> {
  WelcomeCubit() : super(const WelcomeState());

  void selectLanguage(Language language, BuildContext context) {
    emit(state.copyWith(selectedLanguage: language));
    // Navigate to login page after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      context.go('/login');
    });
  }
}
