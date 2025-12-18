import 'package:flutter/material.dart';
import 'package:flutter_super_aslan_app/features/counter/view/counter_page.dart';
import 'package:go_router/go_router.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class GlobalRouter {
  static final GoRouter instance = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const CounterPage(),
      ),
      // GoRoute(
      //   path: MainView.path,
      //   builder: (context, state) => const MainView(),
      // ),
      //
      // // sign in
      // GoRoute(
      //   path: SignInPage.path,
      //   builder: (context, state) => const SignInPage(),
      // ),
      //
      // // sign up
      // GoRoute(
      //   path: SignUpPage.path,
      //   builder: (context, state) => const SignUpPage(),
      // ),
      //
      // // verification
      // GoRoute(
      //   path: VerificationPage.path,
      //   builder: (context, state) => const VerificationPage(),
      // ),
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
