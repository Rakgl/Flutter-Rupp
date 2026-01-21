import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_super_aslan_app/features/login/view/login_page.dart';
import 'package:flutter_super_aslan_app/features/shared/widgets/phone_text_field.dart';
import 'package:flutter_super_aslan_app/features/shared/widgets/text_form_field_widget.dart';
import 'package:flutter_super_aslan_app/features/shared/widgets/text_label.dart';
import 'package:flutter_super_aslan_app/features/signup/signup.dart';
import 'package:go_router/go_router.dart';

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
  final _formKey = GlobalKey<FormState>();
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
  bool _isFormValid = false;
  bool _submitAttempted = false;
  _CountryOption _selectedCountry = _countries.first;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updateFormState() {
    final hasInput =
        _fullNameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
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
                leading: Text(
                  country.flag,
                  style: const TextStyle(fontSize: 24),
                ),
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
          resizeToAvoidBottomInset: true,
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
                                      24,
                                      24,
                                      24,
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
                                            style:
                                                Theme.of(
                                                      context,
                                                    ).textTheme.bodyMedium
                                                    ?.copyWith(
                                                      color: AppColors.paleSky,
                                                      fontSize: 14,
                                                    ),
                                          ),
                                          const SizedBox(height: 28),
                                          const Align(
                                            alignment: Alignment.centerLeft,
                                            child: TextLabel(
                                              label: 'Full name',
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          TextFormFieldWidget(
                                            controller: _fullNameController,
                                            labelText: 'Peter Parker',
                                            onChanged: (_) =>
                                                _updateFormState(),
                                          ),
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
                                            onChanged: (_) =>
                                                _updateFormState(),
                                            validator: (value) {
                                              final text = value?.trim() ?? '';
                                              if (text.isEmpty) return null;
                                              final emailRegex = RegExp(
                                                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                              );
                                              if (!emailRegex.hasMatch(text)) {
                                                return 'Enter a valid email address';
                                              }
                                              return null;
                                            },
                                          ),
                                          const Align(
                                            alignment: Alignment.centerLeft,
                                            child: TextLabel(
                                              label: 'Phone number',
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          PhoneTextFieldWidget(
                                            controller: _phoneController,
                                            labelText: '01234',
                                            onChanged: (_) =>
                                                _updateFormState(),
                                            validator: (value) {
                                              final text = value?.trim() ?? '';
                                              if (text.isEmpty) {
                                                return null;
                                              }
                                              if (text.length < 6) {
                                                return 'Enter a valid phone number';
                                              }
                                              return null;
                                            },
                                            prefix: GestureDetector(
                                              onTap: _showCountryPicker,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    _selectedCountry.flag,
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    _selectedCountry.dialCode,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  const Icon(
                                                    Icons
                                                        .keyboard_arrow_down_rounded,
                                                    size: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
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
                                            onChanged: (_) =>
                                                _updateFormState(),
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
                                                'Get Started',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () => context.go(LoginPage.path),
                                    child: Wrap(
                                      children: [
                                        Text(
                                          'Already have an account? ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontSize: 15,
                                              ),
                                        ),
                                        Text(
                                          'Log In',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
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
