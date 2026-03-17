import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_methgo_app/features/auth/signup/cubit/signup_cubit.dart';
import 'package:flutter_methgo_app/features/shared/widgets/bottom_action_button.dart';
import 'package:flutter_methgo_app/features/shared/widgets/text_form_field_widget.dart';
import 'package:flutter_methgo_app/features/shared/widgets/text_label.dart';
import 'package:flutter_methgo_app/app/view/main_view.dart';
import 'package:go_router/go_router.dart';

class SignupDetailsPage extends StatelessWidget {
  const SignupDetailsPage({super.key});

  static const String path = '/signup-details';

  @override
  Widget build(BuildContext context) {
    return const SignupDetailsView();
  }
}

class SignupDetailsView extends StatefulWidget {
  const SignupDetailsView({super.key});

  @override
  State<SignupDetailsView> createState() => _SignupDetailsViewState();
}

class _SignupDetailsViewState extends State<SignupDetailsView> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isFormValid = false;
  bool _submitAttempted = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updateFormState() {
    final hasInput = _fullNameController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty &&
        _confirmPasswordController.text.trim().isNotEmpty;
    if (hasInput != _isFormValid) {
      setState(() => _isFormValid = hasInput);
    }
  }

  void _submit() {
    setState(() => _submitAttempted = true);
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    context.read<SignupCubit>().completeRegistration(
          name: _fullNameController.text.trim(),
          password: _passwordController.text.trim(),
          passwordConfirmation: _confirmPasswordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final view = View.of(context);
    final size = MediaQueryData.fromView(view).size;
    final fullHeight = view.physicalSize.height / view.devicePixelRatio;
    final whiteBgHeight = fullHeight * 0.545;
    final cardTop = size.height * 0.19;

    return BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state.status == SignupStatus.success) {
          context.go(MainView.path);
        } else if (state.status == SignupStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Registration failed'),
              backgroundColor: Colors.red,
            ),
          );
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
                                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
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
                                              'Complete Account',
                                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 24,
                                                    color: AppColors.black,
                                                  ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              'Enter your name and choose a password',
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                    color: AppColors.paleSky,
                                                    fontSize: 14,
                                                  ),
                                            ),
                                            const SizedBox(height: 28),
                                            const Align(
                                              alignment: Alignment.centerLeft,
                                              child: TextLabel(label: 'Full name'),
                                            ),
                                            const SizedBox(height: 12),
                                            TextFormFieldWidget(
                                              controller: _fullNameController,
                                              labelText: 'John Doe',
                                              onChanged: (_) => _updateFormState(),
                                              validator: (value) {
                                                if (value == null || value.trim().isEmpty) {
                                                  return 'Full name is required';
                                                }
                                                return null;
                                              },
                                            ),
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
                                              onToggleSuffix: () =>
                                                  setState(() => _obscurePassword = !_obscurePassword),
                                              onChanged: (_) => _updateFormState(),
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Password is required';
                                                }
                                                if (value.length < 6) {
                                                  return 'Password must be at least 6 characters';
                                                }
                                                return null;
                                              },
                                            ),
                                            const Align(
                                              alignment: Alignment.centerLeft,
                                              child: TextLabel(label: 'Confirm Password'),
                                            ),
                                            const SizedBox(height: 12),
                                            TextFormFieldWidget(
                                              controller: _confirmPasswordController,
                                              obscureText: _obscureConfirmPassword,
                                              labelText: 'Confirm Password',
                                              isPassword: true,
                                              onToggleSuffix: () => setState(
                                                  () => _obscureConfirmPassword = !_obscureConfirmPassword),
                                              onChanged: (_) => _updateFormState(),
                                              validator: (value) {
                                                if (value != _passwordController.text) {
                                                  return 'Passwords do not match';
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(height: 16),
                                            BlocBuilder<SignupCubit, SignupState>(
                                              builder: (context, state) {
                                                final isLoading = state.status == SignupStatus.loading;
                                                return BottomActionButton(
                                                  title: isLoading ? 'Registering...' : 'Complete Registration',
                                                  onPressed: (_isFormValid && !isLoading) ? _submit : null,
                                                  horizontalPadding: 0,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
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
      ),
    );
  }
}
