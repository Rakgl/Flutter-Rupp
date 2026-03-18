import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_methgo_app/app/view/main_view.dart';
import 'package:flutter_methgo_app/features/auth/signup/cubit/signup_cubit.dart';
import 'package:flutter_methgo_app/features/auth/signup/view/business_verification_page.dart';
import 'package:flutter_methgo_app/features/auth/signup/view/payment_setup_page.dart';
import 'package:flutter_methgo_app/features/auth/login/view/login_page.dart';
import 'package:flutter_methgo_app/features/profile/view/business_info_page.dart';
import 'package:flutter_methgo_app/features/profile/view/edit_profile_page.dart';
import 'package:flutter_methgo_app/features/profile/view/portfolio_page.dart';
import 'package:flutter_methgo_app/features/profile/view/services_pricing_page.dart';
import 'package:flutter_methgo_app/features/profile/view/transaction_history_page.dart';
import 'package:flutter_methgo_app/features/profile/view/working_hours_page.dart';
import 'package:flutter_methgo_app/features/profile/view/settings_page.dart';
import 'package:flutter_methgo_app/features/appointments/view/appointments_page.dart';
import 'package:flutter_methgo_app/features/auth/signup/view/signup_details_page.dart';
import 'package:flutter_methgo_app/features/auth/signup/view/signup_page.dart';
import 'package:flutter_methgo_app/features/products/view/products_page.dart';
import 'package:flutter_methgo_app/features/products/view/product_detail_page.dart';
import 'package:flutter_methgo_app/features/pets/view/pets_page.dart';
import 'package:flutter_methgo_app/features/pets/view/pet_detail_page.dart';
import 'package:flutter_methgo_app/features/categories/view/categories_page.dart';
import 'package:flutter_methgo_app/features/categories/view/category_detail_page.dart';
import 'package:flutter_methgo_app/features/services/view/services_page.dart';
import 'package:flutter_methgo_app/features/ai_chat/view/ai_chat_page.dart';
import 'package:flutter_methgo_app/splash/view/splash_page.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_methgo_app/features/auth/signup/view/phone_verification_page.dart';
import 'package:flutter_methgo_app/features/auth/signup/view/insurance_information_page.dart';

import 'package:flutter_methgo_app/features/appointments/view/booking_success_page.dart';
import 'package:flutter_methgo_app/features/order/view/payment_screen.dart';
import 'package:flutter_methgo_app/features/order/view/order_success_page.dart';
import 'package:flutter_methgo_app/features/order/view/payment_history_page.dart';
import 'package:api_http_client/api_http_client.dart';

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
        builder: (context, state) => const EditProfilePage(),
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
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: SignupPage.path,
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: PhoneVerificationPage.path,
        builder: (context, state) {
          final cubit = state.extra as SignupCubit;
          return BlocProvider.value(
            value: cubit,
            child: const PhoneVerificationPage(),
          );
        },
      ),
      GoRoute(
        path: SignupDetailsPage.path,
        builder: (context, state) {
          final cubit = state.extra as SignupCubit;
          return BlocProvider.value(
            value: cubit,
            child: const SignupDetailsPage(),
          );
        },
      ),
      GoRoute(
        path: AppointmentsPage.path,
        builder: (context, state) => const AppointmentsPage(),
      ),
      GoRoute(
        path: BookingSuccessPage.path,
        builder: (context, state) {
          final appointment = state.extra as AppointmentModel;
          return BookingSuccessPage(appointment: appointment);
        },
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
      GoRoute(
        path: ProductsPage.path,
        builder: (context, state) => const ProductsPage(),
      ),
      GoRoute(
        path: PetsPage.path,
        builder: (context, state) => const PetsPage(),
      ),
      GoRoute(
        path: CategoriesPage.path,
        builder: (context, state) => const CategoriesPage(),
      ),
      GoRoute(
        path: '/categories/:id',
        builder: (context, state) {
          final categoryId = state.pathParameters['id'] ?? '';
          return CategoryDetailPage(categoryId: categoryId);
        },
      ),
      GoRoute(
        path: ServicesPage.path,
        builder: (context, state) => const ServicesPage(),
      ),
      GoRoute(
        path: AiChatPage.path,
        builder: (context, state) => const AiChatPage(),
      ),
      GoRoute(
        path: ProductDetailPage.path,
        builder: (context, state) {
          final productId = state.extra as String? ?? '';
          return ProductDetailPage(productId: productId);
        },
      ),
      GoRoute(
        path: PetDetailPage.path,
        builder: (context, state) {
          final petId = state.extra as String? ?? '';
          return PetDetailPage(petId: petId);
        },
      ),
      GoRoute(
        path: PaymentHistoryPage.path,
        builder: (context, state) => const PaymentHistoryPage(),
      ),
      GoRoute(
        path: PaymentScreen.path,
        builder: (context, state) => const PaymentScreen(),
      ),
      GoRoute(
        path: OrderSuccessPage.path,
        builder: (context, state) {
          final order = state.extra as OrderModel?;
          return OrderSuccessPage(order: order);
        },
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
