import 'package:flutter/material.dart';
import 'package:flutter_super_aslan_app/app/view/main_view.dart';
import 'package:flutter_super_aslan_app/splash/view/splash_page.dart';
import 'package:go_router/go_router.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class GlobalRouter {
  static final GoRouter instance = GoRouter(
    routes: [
      GoRoute(
        path: MainView.path,
        builder: (context, state) => const MainView(),
      ),

      GoRoute(
        path: SplashPage.path,
        builder: (context, state) => const SplashPage(),
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Text(
            'Error: ${state.error}',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
        ),
      );
    },
    navigatorKey: navigatorKey,
  );
}
