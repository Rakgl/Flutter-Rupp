import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_methgo_app/app/view/main_view.dart';
import 'package:flutter_methgo_app/features/auth/login/login.dart';
import 'package:flutter_methgo_app/features/shared/widgets/text_form_field_widget.dart';
import 'package:flutter_methgo_app/features/shared/widgets/text_label.dart';
import 'package:flutter_methgo_app/features/shared/widgets/bottom_action_button.dart';
import 'package:flutter_methgo_app/features/auth/signup/view/signup_page.dart';
import 'package:go_router/go_router.dart';
import 'package:repository/repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  static const String path = '/login';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(
        userRepository: context.read<UserRepository>(),
      ),
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
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isFormValid = false;
  bool _submitAttempted = false;

  @override
  void initState() {
    super.initState();

    // Keep button enabled/disabled in sync with the text fields
    _phoneController.addListener(_updateFormState);
    _passwordController.addListener(_updateFormState);

    // Initial state
    _updateFormState();
  }

  @override
  void dispose() {
    _phoneController
      ..removeListener(_updateFormState)
      ..dispose();
    _passwordController
      ..removeListener(_updateFormState)
      ..dispose();
    super.dispose();
  }

  void _updateFormState() {
    final hasInput =
        _phoneController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty;

    if (hasInput != _isFormValid) {
      setState(() => _isFormValid = hasInput);
    }
  }

  void _submit() {
    setState(() => _submitAttempted = true);

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    unawaited(
      context.read<LoginCubit>().login(
        phone: _phoneController.text.trim(),
        password: _passwordController.text.trim(),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final view = View.of(context);
    final size = MediaQueryData.fromView(view).size;
    final fullHeight = view.physicalSize.height / view.devicePixelRatio;

    final whiteBgHeight = fullHeight * 0.545;
    final cardTop = size.height * 0.19;

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          context.go(MainView.path);
        } else if (state.status == LoginStatus.failure) {
          final message = (state.errorMessage?.trim().isNotEmpty ?? false)
              ? state.errorMessage!.trim()
              : 'Invalid email or password.';
          _showErrorSnackBar(message);
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Transform.translate(
              offset: const Offset(0, -115),
              child: Assets.img.backgroundImage.image(
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: whiteBgHeight,
            child: Container(color: AppColors.white),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: Stack(
                children: [
                  // Fixed logo (behind the card)
                  Positioned(
                    top: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Assets.img.appLogo.image(
                        width: 150,
                        height: 150,
                      ),
                    ),
                  ),

                  // Scrollable content
                  Positioned.fill(
                    child: LayoutBuilder(
                      builder: (context, viewport) {
                        final minHeight = viewport.maxHeight - cardTop - 20;
                        return SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: cardTop,
                              left: 10,
                              right: 10,
                              bottom: 20,
                            ),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: minHeight > 0 ? minHeight : 0,
                              ),
                              child: IntrinsicHeight(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                        24,
                                        28,
                                        24,
                                        32,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(28),
                                      ),
                                      child: Form(
                                        key: _formKey,
                                        autovalidateMode: _submitAttempted
                                            ? AutovalidateMode.onUserInteraction
                                            : AutovalidateMode.disabled,
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
                                              style:
                                                  Theme.of(
                                                        context,
                                                      ).textTheme.bodyMedium
                                                      ?.copyWith(
                                                        color:
                                                            AppColors.paleSky,
                                                        fontSize: 15,
                                                      ),
                                            ),
                                            const SizedBox(height: 28),
                                            const Align(
                                              alignment: Alignment.centerLeft,
                                              child: TextLabel(
                                                label: 'Phone Number',
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            TextFormFieldWidget(
                                              controller: _phoneController,
                                              labelText: 'Phone Number',
                                              keyboardType: TextInputType.phone,
                                              validator: (value) {
                                                final text =
                                                    value?.trim() ?? '';
                                                if (text.isEmpty) {
                                                  return 'Phone Number is required';
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(height: 16),
                                            const Align(
                                              alignment: Alignment.centerLeft,
                                              child: TextLabel(
                                                label: 'Password',
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            TextFormFieldWidget(
                                              controller: _passwordController,
                                              obscureText: _obscurePassword,
                                              labelText: 'Password',
                                              isPassword: true,
                                              onToggleSuffix: () => setState(
                                                () => _obscurePassword =
                                                    !_obscurePassword,
                                              ),
                                              validator: (value) {
                                                final text =
                                                    value?.trim() ?? '';
                                                if (text.isEmpty) {
                                                  return 'Password is required';
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(height: 16),
                                            BlocBuilder<LoginCubit, LoginState>(
                                              builder: (context, state) {
                                                final isLoading =
                                                    state.status ==
                                                    LoginStatus.loading;
                                                return BottomActionButton(
                                                  title: isLoading
                                                      ? 'Logging in...'
                                                      : 'Log In',
                                                  onPressed:
                                                      (_isFormValid &&
                                                          !isLoading)
                                                      ? _submit
                                                      : null,
                                                  horizontalPadding: 0,
                                                );
                                              },
                                            ),
                                            const SizedBox(height: 16),
                                            GestureDetector(
                                              onTap: () {},
                                              child: Text(
                                                'Forgot password?',
                                                style:
                                                    Theme.of(
                                                          context,
                                                        ).textTheme.bodyLarge
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              AppColors.black,
                                                          fontSize: 15,
                                                        ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Wrap(
                                      children: [
                                        Text(
                                          "Don't have an account? ",
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.bodyMedium?.copyWith(
                                                fontSize: 15,
                                              ),
                                        ),
                                        GestureDetector(
                                          onTap: () =>
                                              context.go(SignupPage.path),
                                          child: Text(
                                            'Register',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.primaryColor,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
