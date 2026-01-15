import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_super_aslan_app/app/view/main_view.dart';
import 'package:flutter_super_aslan_app/features/login/login.dart';
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

  InputDecoration _inputDec({
    required String hint,
    Widget? suffixIcon,
    bool isPassword = false,
  }) {
    final borderRadius = BorderRadius.circular(14);
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppColors.grey.shade500,
        fontSize: isPassword ? 18 : 15,
        letterSpacing: isPassword ? 3.5 : 0,
      ),
      filled: true,
      fillColor: AppColors.inputEnabled,
      border: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          color: AppColors.grey.shade200,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(
          color: _accent,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final view = View.of(context);
    final size = MediaQueryData.fromView(view).size;
    final fullHeight = view.physicalSize.height / view.devicePixelRatio;

    // White background = 50% of screen
    final whiteBgHeight = fullHeight * 0.545;

    const logoSize = 150.0;

    // Card position (slightly higher than before)
    final cardTop = size.height * 0.26;

    // Logo position (sit just above the card)
    final logoTop =
        (cardTop - logoSize * 1.2).clamp(24.0, size.height).toDouble();

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

        Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Stack(
              children: [
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
                          style: Theme.of(context).textTheme.headlineMedium
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
                          child: Text(
                            'Email or Phone Number',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: AppColors.black,
                                ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _emailController,
                          decoration: _inputDec(
                            hint: 'peterparker@gmail.com',
                          ),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Password',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: AppColors.black,
                                ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(
                            fontSize: 18,
                            letterSpacing: 3.5,
                          ),
                          decoration: _inputDec(
                            hint: '••••••••',
                            isPassword: true,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.grey.shade500,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isFormValid ? _submit : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _accent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: const Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
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

                // Logo
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
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(fontSize: 15),
                          ),
                          Text(
                            'Register',
                            style: Theme.of(context).textTheme.bodyMedium
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
        ),
      ],
    );
  }
}
