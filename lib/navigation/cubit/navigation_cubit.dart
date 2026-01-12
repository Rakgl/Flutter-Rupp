import 'package:bloc/bloc.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationState.home);

  void setTab(int selectedTab) {
    switch (selectedTab) {
      case 0:
        return emit(NavigationState.home);
      case 1:
        return emit(NavigationState.request);
      case 2:
        return emit(NavigationState.schedule);
      case 3:
        return emit(NavigationState.message);
      case 4:
        return emit(NavigationState.profile);
      default:
        return emit(NavigationState.home);
    }
  }

  void reset() {
    emit(NavigationState.home);
  }
}
