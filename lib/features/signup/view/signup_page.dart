import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_super_aslan_app/features/login/view/login_page.dart';
import 'package:flutter_super_aslan_app/features/signup/signup.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  static const String path = '/signup';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupCubit(),
      child: const SignupView(),
    );
  }
}

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  static const Color _accent = Color(0xFFED6B65);

  static const List<_CountryOption> _countries = [
    _CountryOption(name: 'France', dialCode: '+33', flag: '🇫🇷'),
    _CountryOption(name: 'United Kingdom', dialCode: '+44', flag: '🇬🇧'),
    _CountryOption(name: 'Saudi Arabia', dialCode: '+966', flag: '🇸🇦'),
  ];

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  _CountryOption _selectedCountry = _countries.first;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
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

  Future<void> _showCountryPicker() async {
    final selected = await showModalBottomSheet<_CountryOption>(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _countries.map((country) {
              return ListTile(
                leading: Text(country.flag, style: const TextStyle(fontSize: 24)),
                title: Text(country.name),
                trailing: Text(
                  country.dialCode,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                onTap: () => Navigator.of(context).pop(country),
              );
            }).toList(),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() => _selectedCountry = selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final view = View.of(context);
    final size = MediaQueryData.fromView(view).size;
    final fullHeight = view.physicalSize.height / view.devicePixelRatio;
    final whiteBgHeight = fullHeight * 0.54;
    final cardTop = size.height * 0.22;

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
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Stack(
              children: [
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
                Positioned(
                  left: 10,
                  right: 10,
                  top: cardTop,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Welcome to SuperAslan!',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: AppColors.black,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Signup to continue with SuperAslan',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: AppColors.paleSky,
                                fontSize: 14,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Full name',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: AppColors.black,
                                ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _fullNameController,
                          decoration: _inputDec(hint: 'Peter Parker'),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Email',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: AppColors.black,
                                ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _emailController,
                          decoration: _inputDec(hint: 'peterparker@gmail.com'),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Phone number',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: AppColors.black,
                                ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: _showCountryPicker,
                              child: Container(
                                height: 56,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: AppColors.grey.shade300,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      _selectedCountry.flag,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _selectedCountry.dialCode,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SizedBox(
                                height: 56,
                                child: TextField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: _inputDec(hint: '01234'),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Password',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: AppColors.black,
                                ),
                          ),
                        ),
                        const SizedBox(height: 8),
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
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _accent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: const Text(
                              'Get Started',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 24,
                  child: Center(
                    child: GestureDetector(
                      onTap: () => context.go(LoginPage.path),
                      child: Wrap(
                        children: [
                          Text(
                            'Already have an account? ',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontSize: 15),
                          ),
                          Text(
                            'Log In',
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
        ),
      ],
    );
  }
}

class _CountryOption {
  const _CountryOption({
    required this.name,
    required this.dialCode,
    required this.flag,
  });

  final String name;
  final String dialCode;
  final String flag;
}
