import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_super_aslan_app/app/view/main_view.dart';
import 'package:flutter_super_aslan_app/features/login/login.dart';
import 'package:flutter_super_aslan_app/features/shared/widgets/text_form_field_widget.dart';
import 'package:flutter_super_aslan_app/features/shared/widgets/text_label.dart';
import 'package:flutter_super_aslan_app/features/signup/view/signup_page.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isFormValid = false;
  bool _submitAttempted = false;

  @override
  void initState() {
    super.initState();

    // Keep button enabled/disabled in sync with the text fields
    _emailController.addListener(_updateFormState);
    _passwordController.addListener(_updateFormState);

    // Initial state
    _updateFormState();
  }

  @override
  void dispose() {
    _emailController
      ..removeListener(_updateFormState)
      ..dispose();
    _passwordController
      ..removeListener(_updateFormState)
      ..dispose();
    super.dispose();
  }

  void _updateFormState() {
    final hasInput =
        _emailController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty;

    if (hasInput != _isFormValid) {
      setState(() => _isFormValid = hasInput);
    }
  }

  void _submit() {
    setState(() => _submitAttempted = true);

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    context.go(MainView.path);
  }

  @override
  Widget build(BuildContext context) {
    final view = View.of(context);
    final size = MediaQueryData.fromView(view).size;
    final fullHeight = view.physicalSize.height / view.devicePixelRatio;

    final whiteBgHeight = fullHeight * 0.545;
    final cardTop = size.height * 0.19;

    return Stack(
      fit: StackFit.expand,
      children: [
        Assets.img.spaceBg.image(fit: BoxFit.cover),
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
                                                      color: AppColors.paleSky,
                                                      fontSize: 15,
                                                    ),
                                          ),
                                          const SizedBox(height: 28),
                                          const Align(
                                            alignment: Alignment.centerLeft,
                                            child: TextLabel(
                                              label: 'Email address',
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          TextFormFieldWidget(
                                            controller: _emailController,
                                            labelText: 'Email address',
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            validator: (value) {
                                              final text = value?.trim() ?? '';
                                              if (text.isEmpty) {
                                                return 'Email is required';
                                              }
                                              final emailRegex = RegExp(
                                                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                              );
                                              if (!emailRegex.hasMatch(text)) {
                                                return 'Enter a valid email address';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          const Align(
                                            alignment: Alignment.centerLeft,
                                            child: TextLabel(label: 'Password'),
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
                                              final text = value?.trim() ?? '';
                                              if (text.isEmpty) {
                                                return 'Password is required';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          SizedBox(
                                            width: double.infinity,
                                            height: 56,
                                            child: ElevatedButton(
                                              onPressed: _isFormValid
                                                  ? _submit
                                                  : null,
                                              style: ButtonStyle(
                                                elevation:
                                                    WidgetStateProperty.all(
                                                      0,
                                                    ),
                                                backgroundColor:
                                                    WidgetStateProperty.resolveWith(
                                                      (states) {
                                                        if (states.contains(
                                                          WidgetState.disabled,
                                                        )) {
                                                          return AppColors
                                                              .primaryColor
                                                              .withOpacity(0.4);
                                                        }
                                                        return AppColors
                                                            .primaryColor;
                                                      },
                                                    ),
                                                foregroundColor:
                                                    WidgetStateProperty.resolveWith(
                                                      (states) {
                                                        if (states.contains(
                                                          WidgetState.disabled,
                                                        )) {
                                                          return AppColors.white
                                                              .withOpacity(0.7);
                                                        }
                                                        return AppColors.white;
                                                      },
                                                    ),
                                                shape: WidgetStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          28,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              child: const Text(
                                                'Log In',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
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
                                                        color: AppColors.black,
                                                        fontSize: 15,
                                                      ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () => context.go(SignupPage.path),
                                    child: Wrap(
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
                                        Text(
                                          'Register',
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.bodyMedium?.copyWith(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primaryColor,
                                              ),
                                        ),
                                      ],
                                    ),
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
    );
  }
}
