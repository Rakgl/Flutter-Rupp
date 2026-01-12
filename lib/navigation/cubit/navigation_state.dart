part of 'navigation_cubit.dart';

enum NavigationState {
  home(0),
  request(1),
  schedule(2),
  message(3),
  profile(4);

  const NavigationState(this.tabIndex);

  final int tabIndex;
}
