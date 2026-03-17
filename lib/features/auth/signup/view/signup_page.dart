import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_methgo_app/features/auth/login/view/login_page.dart';
import 'package:flutter_methgo_app/features/auth/signup/signup.dart';
import 'package:flutter_methgo_app/features/auth/signup/view/phone_verification_page.dart';
import 'package:flutter_methgo_app/features/shared/widgets/bottom_action_button.dart';
import 'package:flutter_methgo_app/features/shared/widgets/phone_text_field.dart';
import 'package:flutter_methgo_app/features/shared/widgets/text_label.dart';
import 'package:go_router/go_router.dart';
import 'package:repository/repository.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  static const String path = '/signup';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SignupCubit(userRepository: context.read<UserRepository>()),
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
    _CountryOption(name: 'Cambodia', dialCode: '855', flag: '🇰🇭'),
  ];

  final _phoneController = TextEditingController();
  bool _isFormValid = false;
  bool _submitAttempted = false;
  _CountryOption _selectedCountry = _countries.first;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _updateFormState() {
    final hasInput = _phoneController.text.trim().isNotEmpty;
    if (hasInput != _isFormValid) {
      setState(() => _isFormValid = hasInput);
    }
  }

  void _submit() {
    setState(() => _submitAttempted = true);
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    context.read<SignupCubit>().requestOtp(
      phone: _phoneController.text.trim(),
      countryCode: '+${_selectedCountry.dialCode}',
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
                leading: Text(
                  country.flag,
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(country.name),
                trailing: Text(
                  '+${country.dialCode}',
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
    final cardTop = size.height * 0.16;

    return BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state.status == SignupStatus.otpRequested) {
          context.push(
            PhoneVerificationPage.path,
            extra: context.read<SignupCubit>(),
          );
        } else if (state.status == SignupStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Failed to request OTP'),
              backgroundColor: Colors.red,
            ),
          );
          context.read<SignupCubit>().resetStatus();
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
                  Positioned(
                    top: 0,
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
                                        45,
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
                                              'Create Account',
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
                                              'Enter your phone number to receive an OTP',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: AppColors.paleSky,
                                                    fontSize: 14,
                                                  ),
                                            ),
                                            const SizedBox(height: 28),
                                            const Align(
                                              alignment: Alignment.centerLeft,
                                              child: TextLabel(
                                                label: 'Phone number',
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            PhoneTextFieldWidget(
                                              controller: _phoneController,
                                              labelText: '012345678',
                                              onChanged: (_) =>
                                                  _updateFormState(),
                                              validator: (value) {
                                                final text =
                                                    value?.trim() ?? '';
                                                if (text.isEmpty) {
                                                  return 'Phone number is required';
                                                }
                                                return null;
                                              },
                                              prefix: GestureDetector(
                                                onTap: _showCountryPicker,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      _selectedCountry.flag,
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Text(
                                                      '+${_selectedCountry.dialCode}',
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
                                            const SizedBox(height: 24),
                                            BlocBuilder<
                                              SignupCubit,
                                              SignupState
                                            >(
                                              builder: (context, state) {
                                                final isLoading =
                                                    state.status ==
                                                    SignupStatus.loading;
                                                return BottomActionButton(
                                                  title: isLoading
                                                      ? 'Sending OTP...'
                                                      : 'Get OTP',
                                                  onPressed:
                                                      (_isFormValid &&
                                                          !isLoading)
                                                      ? _submit
                                                      : null,
                                                  horizontalPadding: 0,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Wrap(
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
                                        GestureDetector(
                                          onTap: () =>
                                              context.go(LoginPage.path),
                                          child: Text(
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
