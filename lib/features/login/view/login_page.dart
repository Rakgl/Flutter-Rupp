import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_super_aslan_app/app/view/main_view.dart';
import 'package:flutter_super_aslan_app/features/login/login.dart';
import 'package:flutter_super_aslan_app/features/signup/view/signup_page.dart';
import 'package:flutter_super_aslan_app/features/shared/widgets/bottom_action_button.dart';
import 'package:flutter_super_aslan_app/features/shared/widgets/text_form_field_widget.dart';
import 'package:flutter_super_aslan_app/features/shared/widgets/text_label.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  static const String path = '/login';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  static const Color _accent = Color(0xFFED6B65);

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateFormState);
    _passwordController.addListener(_updateFormState);
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateFormState);
    _passwordController.removeListener(_updateFormState);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updateFormState() {
    final isValid =
        _emailController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty;
    if (isValid != _isFormValid) {
      setState(() => _isFormValid = isValid);
    }
  }

  void _submit() {
    if (_isFormValid) {
      context.go(MainView.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final view = View.of(context);
    final size = MediaQueryData.fromView(view).size;
    final fullHeight = view.physicalSize.height / view.devicePixelRatio;

    // White background = 50% of screen
    final whiteBgHeight = fullHeight * 0.545;

    const logoSize = 150.0;
    const estimatedCardHeight = 520.0;
    const bottomContentSpacing = 120.0;

    // Card position (slightly higher than before)
    final cardTop = size.height * 0.26;

    // Logo position (sit just above the card)
    final logoTop = (cardTop - logoSize * 1.2)
        .clamp(24.0, size.height)
        .toDouble();

    return Stack(
      fit: StackFit.expand,
      children: [
        // 🌌 Background
        Assets.img.spaceBg.image(fit: BoxFit.cover),

        // Flat white background (50%, no radius)
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: whiteBgHeight,
          child: Container(color: AppColors.white),
        ),

        // Logo (behind the card)
        Positioned(
          top: logoTop,
          left: 0,
          right: 0,
          child: Center(
            child: Assets.img.appLogo.image(
              width: logoSize,
              height: logoSize,
            ),
          ),
        ),

        Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final contentHeight = math.max(
                  constraints.maxHeight,
                  cardTop + estimatedCardHeight + bottomContentSpacing,
                );

                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: SizedBox(
                    height: contentHeight,
                    child: Stack(
                      children: [
                        // Flat white background (50%, no radius)
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          height: whiteBgHeight,
                          child: Container(color: AppColors.white),
                        ),

                        // Login card (NO shadow)
                        Positioned(
                          left: 10,
                          right: 10,
                          top: cardTop,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Welcome back!',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28,
                                        color: AppColors.black,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Login to continue with SuperAslan',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: AppColors.paleSky,
                                        fontSize: 15,
                                      ),
                                ),
                                const SizedBox(height: 28),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: const TextLabel(
                                    label: 'Email or Phone Number',
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextFormFieldWidget(
                                  controller: _emailController,
                                  labelText: 'peterparker@gmail.com',
                                  icon: Icons.email_outlined,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: const TextLabel(
                                    label: 'Password',
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextFormFieldWidget(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  labelText: '••••••••',
                                  icon: Icons.lock_outline,
                                  isPassword: true,
                                  onToggleSuffix: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                ),
                                const SizedBox(height: 28),
                                BottomActionButton(
                                  title: 'Log In',
                                  onPressed: _isFormValid ? _submit : null,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Forgot password?',
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.black,
                                        fontSize: 15,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Bottom register text
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 24,
                          child: Center(
                            child: GestureDetector(
                              onTap: () => context.go(SignupPage.path),
                              child: Wrap(
                                children: [
                                  Text(
                                    'Don’t have an account? ',
                                    style:
                                        Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.copyWith(
                                          fontSize: 15,
                                        ),
                                  ),
                                  Text(
                                    'Register',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: _accent,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
