import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashState());

  void load() {
    emit(state.copyWith(status: SplashStatus.loading));
    // Simulate a network call
    Future.delayed(const Duration(seconds: 2), () {
      emit(state.copyWith(status: SplashStatus.loaded));
    });
  }
}
