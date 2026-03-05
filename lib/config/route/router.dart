import 'package:flutter/material.dart';
import 'package:flutter_super_aslan_app/app/view/main_view.dart';
import 'package:flutter_super_aslan_app/features/auth/signup/view/business_verification_page.dart';
import 'package:flutter_super_aslan_app/features/auth/signup/view/payment_setup_page.dart';
import 'package:flutter_super_aslan_app/features/auth/login/view/login_page.dart';
import 'package:flutter_super_aslan_app/features/profile/view/business_info_page.dart';
import 'package:flutter_super_aslan_app/features/profile/view/edit_profile_page.dart';
import 'package:flutter_super_aslan_app/features/profile/view/portfolio_page.dart';
import 'package:flutter_super_aslan_app/features/profile/view/services_pricing_page.dart';
import 'package:flutter_super_aslan_app/features/profile/view/transaction_history_page.dart';
import 'package:flutter_super_aslan_app/features/profile/view/working_hours_page.dart';
import 'package:flutter_super_aslan_app/features/profile/view/settings_page.dart';
import 'package:flutter_super_aslan_app/features/auth/signup/view/signup_page.dart';
import 'package:flutter_super_aslan_app/features/welcome/view/welcome_page.dart';
import 'package:flutter_super_aslan_app/splash/view/splash_page.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_super_aslan_app/features/profile/cubit/profile_cubit.dart';
import 'package:flutter_super_aslan_app/features/auth/signup/view/insurance_information_page.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class GlobalRouter {
  static final GoRouter instance = GoRouter(
    initialLocation: SplashPage.path,
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(
        path: SplashPage.path,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: MainView.path,
        builder: (context, state) => const MainView(),
      ),
      GoRoute(
        path: EditProfilePage.path,
        builder: (context, state) {
          final cubit = state.extra as ProfileCubit;
          return BlocProvider.value(
            value: cubit,
            child: const EditProfilePage(),
          );
        },
      ),
      GoRoute(
        path: SettingsPage.path,
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: BusinessInfoPage.path,
        builder: (context, state) => const BusinessInfoPage(),
      ),
      GoRoute(
        path: ServicesPricingPage.path,
        builder: (context, state) => const ServicesPricingPage(),
      ),
      GoRoute(
        path: PortfolioPage.path,
        builder: (context, state) => const PortfolioPage(),
      ),
      GoRoute(
        path: WorkingHoursPage.path,
        builder: (context, state) => const WorkingHoursPage(),
      ),
      GoRoute(
        path: TransactionHistoryPage.path,
        builder: (context, state) => const TransactionHistoryPage(),
      ),
      GoRoute(
        path: WelcomePage.path,
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: SignupPage.path,
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: BusinessVerificationPage.path,
        builder: (context, state) => const BusinessVerificationPage(),
      ),
      GoRoute(
        path: PaymentSetupPage.path,
        builder: (context, state) => const PaymentSetupPage(),
      ),
      GoRoute(
        path: InsuranceInformationPage.path,
        builder: (context, state) => const InsuranceInformationPage(),
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
  );
}
