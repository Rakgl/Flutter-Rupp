# login/cubit/login_cubit.dart

```dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';
import 'package:api_http_client/api_http_client.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required UserRepository userRepository,
  }) : _userRepository = userRepository,
       super(const LoginState());

  final UserRepository _userRepository;

  Future<void> login({
    required String phone,
    required String password,
  }) async {
    emit(state.copyWith(status: LoginStatus.loading));

    try {
      final request = SignInRequest(
        phone: phone,
        password: password,
      );

      final response = await _userRepository.signIn(request);

      await response.when<SignInResponse>(
        success: (data) async {
          emit(state.copyWith(status: LoginStatus.success));
        },
        failure: (String error) async {
          emit(
            state.copyWith(
              status: LoginStatus.failure,
              errorMessage: error,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: 'An unexpected error occurred',
        ),
      );
    }
  }
}

```

# login/cubit/login_state.dart

```dart
part of 'login_cubit.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.initial,
    this.errorMessage,
  });

  final LoginStatus status;
  final String? errorMessage;

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}

```

# login/login.dart

```dart
export 'cubit/login_cubit.dart';
export 'view/view.dart';

```

# login/view/login_page.dart

```dart
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
                                    const SizedBox(height: 24), // Add spacing for the new button
                                    SizedBox(
                                      width: double.infinity,
                                      height: 54,
                                      child: TextButton(
                                        onPressed: () => context.go(MainView.path),
                                        style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(28),
                                          ),
                                        ),
                                        child: Text(
                                          'Continue as Guest',
                                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                            color: AppColors.grey.shade700,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
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

```

# login/view/view.dart

```dart
export 'login_page.dart';

```

# signup/cubit/signup_cubit.dart

```dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const SignupState());

  final UserRepository _userRepository;

  /// Step A: Request OTP
  Future<void> requestOtp({required String phone, required String countryCode}) async {
    emit(state.copyWith(status: SignupStatus.loading, phoneNumber: phone, countryCode: countryCode));

    final response = await _userRepository.verifyPhoneNumber(
      phone: phone,
      countryCode: countryCode,
    );

    await response.when(
      success: (transactionCode) async {
        emit(state.copyWith(
          status: SignupStatus.otpRequested,
          transactionCode: transactionCode,
        ));
      },
      failure: (error) async {
        emit(state.copyWith(status: SignupStatus.failure, errorMessage: error));
      },
    );
  }

  /// Step B: Verify OTP
  Future<void> verifyOtp({required String otp}) async {
    emit(state.copyWith(status: SignupStatus.loading));

    final response = await _userRepository.verifyOTP(
      otp: otp,
      transactionCode: state.transactionCode,
    );

    await response.when(
      success: (_) async {
        emit(state.copyWith(status: SignupStatus.otpVerified));
      },
      failure: (error) async {
        emit(state.copyWith(status: SignupStatus.failure, errorMessage: error));
      },
    );
  }

  /// Step C: Complete Registration
  Future<void> completeRegistration({
    required String name,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(state.copyWith(status: SignupStatus.loading));

    final response = await _userRepository.register(
      phone: state.phoneNumber,
      name: name,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    await response.when(
      success: (_) async {
        emit(state.copyWith(status: SignupStatus.success));
      },
      failure: (error) async {
        emit(state.copyWith(status: SignupStatus.failure, errorMessage: error));
      },
    );
  }

  void resetStatus() {
    emit(state.copyWith(status: SignupStatus.initial, errorMessage: null));
  }
}

```

# signup/cubit/signup_state.dart

```dart
part of 'signup_cubit.dart';

enum SignupStatus { initial, loading, otpRequested, otpVerified, success, failure }

class SignupState extends Equatable {
  const SignupState({
    this.status = SignupStatus.initial,
    this.phoneNumber = '',
    this.countryCode = '',
    this.transactionCode = '',
    this.errorMessage,
  });

  final SignupStatus status;
  final String phoneNumber;
  final String countryCode;
  final String transactionCode;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, phoneNumber, countryCode, transactionCode, errorMessage];

  SignupState copyWith({
    SignupStatus? status,
    String? phoneNumber,
    String? countryCode,
    String? transactionCode,
    String? errorMessage,
  }) {
    return SignupState(
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
      transactionCode: transactionCode ?? this.transactionCode,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

```

# signup/signup.dart

```dart
export 'cubit/signup_cubit.dart';
export 'view/view.dart';

```

# signup/view/business_verification_page.dart

```dart
import 'package:app_ui/app_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_methgo_app/features/auth/signup/view/payment_setup_page.dart';
import 'package:flutter_methgo_app/features/shared/widgets/bottom_action_button.dart';
import 'package:go_router/go_router.dart';

class BusinessVerificationPage extends StatelessWidget {
  const BusinessVerificationPage({super.key});

  static const String path = '/business-verification';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.transparent,
      body: _BusinessVerificationBody(),
    );
  }
}

class _BusinessVerificationBody extends StatefulWidget {
  const _BusinessVerificationBody();

  @override
  State<_BusinessVerificationBody> createState() =>
      _BusinessVerificationBodyState();
}

class _BusinessVerificationBodyState extends State<_BusinessVerificationBody> {
  final _businessNumberController = TextEditingController();
  String? _businessLicenseFileName;
  String? _registrationProofFileName;

  bool get _isFormComplete =>
      _businessNumberController.text.trim().isNotEmpty &&
      _businessLicenseFileName != null &&
      _registrationProofFileName != null;

  @override
  void dispose() {
    _businessNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final view = View.of(context);
    final fullHeight = view.physicalSize.height / view.devicePixelRatio;
    final whiteBgHeight = fullHeight * 0.5;

    return Stack(
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
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(8, 40, 8, 8),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _HeroCard(),
                  const SizedBox(height: 16),
                  const _StatusBanner(),
                  const SizedBox(height: 16),
                  _BusinessNumberCard(
                    controller: _businessNumberController,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  _UploadCard(
                    businessLicenseFileName: _businessLicenseFileName,
                    registrationProofFileName: _registrationProofFileName,
                    onBusinessLicenseSelected: (fileName) => setState(() {
                      _businessLicenseFileName = fileName;
                    }),
                    onRegistrationProofSelected: (fileName) => setState(() {
                      _registrationProofFileName = fileName;
                    }),
                  ),
                  const SizedBox(height: 16),
                  const _SecurityCard(),
                  const SizedBox(height: 12),
                  BottomActionButton(
                    title: 'Continue Verification',
                    onPressed: _isFormComplete
                        ? () => context.go(PaymentSetupPage.path)
                        : null,
                    horizontalPadding: 0,
                  ),
                  const SizedBox(height: 12),
                  const _FooterHelp(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 6, 4, 2),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              'Business License Verification',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.eerieBlack,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: Text(
              'To ensure legitimacy, safety, and regulatory compliance on the '
              'SuperAslan platform, all service providers must verify their '
              'business registration before becoming active.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.paleSky,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.red.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.red.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.red.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.hourglass_bottom,
              color: AppColors.trendNegative,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verification Pending',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.redWine,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Complete all fields to proceed',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.trendNegative,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BusinessNumberCard extends StatelessWidget {
  const _BusinessNumberCard({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Business Registration Number',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.eerieBlack,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Enter your 9-digit SIREN number',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.paleSky,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.transparent,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.inputFocused),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: '123 456 789',
                      hintStyle: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(
                            color: AppColors.pastelGrey,
                          ),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.eerieBlack,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.red.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Verify',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadCard extends StatelessWidget {
  const _UploadCard({
    required this.businessLicenseFileName,
    required this.registrationProofFileName,
    required this.onBusinessLicenseSelected,
    required this.onRegistrationProofSelected,
  });

  final String? businessLicenseFileName;
  final String? registrationProofFileName;
  final ValueChanged<String> onBusinessLicenseSelected;
  final ValueChanged<String> onRegistrationProofSelected;

  Future<void> _pickDocument({
    required void Function(String fileName) onSelected,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
    );

    final fileName = result?.files.single.name;
    if (fileName == null) {
      return;
    }

    onSelected(fileName);
  }

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionTitle(title: 'Upload Required Documents'),
          const SizedBox(height: 12),
          _UploadTile(
            icon: Assets.svg.businessLicense.svg(
              width: 26,
              height: 26,
              color: AppColors.confirmedColor,
            ),
            title: 'Business License Certificate',
            subtitle: 'PDF, JPG or PNG (Max 5MB)',
            fileName: businessLicenseFileName,
            onTap: () async {
              await _pickDocument(
                onSelected: onBusinessLicenseSelected,
              );
            },
          ),
          const SizedBox(height: 12),
          _UploadTile(
            icon: Assets.svg.registrationProof.svg(
              width: 26,
              height: 26,
              color: AppColors.confirmedColor,
            ),
            title: 'Registration Proof',
            subtitle: 'Supporting documents (Max 5MB)',
            fileName: registrationProofFileName,
            onTap: () async {
              await _pickDocument(
                onSelected: onRegistrationProofSelected,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SecurityCard extends StatelessWidget {
  const _SecurityCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.blueLight),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.blueLight,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Assets.svg.lock.svg(
                width: 18,
                height: 18,
                color: AppColors.confirmedColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Secure Document Handling',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.eerieBlack,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'All documents are encrypted using 256-bit SSL encryption and '
                  'stored securely in compliance with GDPR regulations. Your '
                  'information is never shared with third parties.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.liver,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterHelp extends StatelessWidget {
  const _FooterHelp();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.help_outline,
            size: 16,
            color: AppColors.redWine,
          ),
          const SizedBox(width: 6),
          Text(
            'Need help verifying your license?',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.redWine,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.brightGrey),
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.eerieBlack,
      ),
    );
  }
}

class _UploadTile extends StatelessWidget {
  const _UploadTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.fileName,
  });

  final Widget icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? fileName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: _DashedBorder(
        radius: 18,
        color: AppColors.inputFocused,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: AppColors.surface2,
                  shape: BoxShape.circle,
                ),
                child: Center(child: icon),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.eerieBlack,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.paleSky,
                ),
              ),
              if (fileName != null) ...[
                const SizedBox(height: 8),
                Text(
                  fileName!,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.liver,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 14),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.inputEnabled,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.cloud_upload_outlined,
                        size: 16,
                        color: AppColors.liver,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Choose File',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.liver,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorder extends StatelessWidget {
  const _DashedBorder({
    required this.child,
    required this.radius,
    required this.color,
  });

  final Widget child;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _DashedBorderPainter(
        radius: radius,
        color: color,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: ColoredBox(
          color: AppColors.white,
          child: child,
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({
    required this.radius,
    required this.color,
  });

  static const double _strokeWidth = 1;
  static const double _dashLength = 4;
  static const double _dashGap = 4;

  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(radius),
        ),
      );

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + _dashLength;
        final segment = metric.extractPath(
          distance,
          next.clamp(0.0, metric.length),
        );
        canvas.drawPath(segment, paint);
        distance = next + _dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.radius != radius || oldDelegate.color != color;
  }
}

```

# signup/view/insurance_information_page.dart

```dart
import 'package:app_ui/app_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_methgo_app/features/shared/widgets/bottom_action_button.dart';
import 'package:flutter_methgo_app/features/shared/widgets/date_input_picker_field_widget.dart';
import 'package:flutter_methgo_app/features/shared/widgets/text_form_field_widget.dart';
import 'package:flutter_methgo_app/features/auth/signup/view/phone_verification_page.dart';
import 'package:go_router/go_router.dart';

class InsuranceInformationPage extends StatelessWidget {
  const InsuranceInformationPage({super.key});

  static const String path = '/insurance-information';

  @override
  Widget build(BuildContext context) {
    return const _InsuranceInformationBody();
  }
}

class _InsuranceInformationBody extends StatefulWidget {
  const _InsuranceInformationBody();

  @override
  State<_InsuranceInformationBody> createState() =>
      _InsuranceInformationBodyState();
}

class _InsuranceInformationBodyState extends State<_InsuranceInformationBody> {
  final _scrollController = ScrollController();
  final _companyController = TextEditingController();
  final _policyController = TextEditingController();
  final _dobController = TextEditingController();
  final _marriedDateController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  final ValueNotifier<DateTime?> _startDateNotifier = ValueNotifier(null);
  final ValueNotifier<DateTime?> _endDateNotifier = ValueNotifier(null);

  String? _certificateFileName;
  String? _coverageFileName;

  final _checklist = [false, false, false, false];

  Future<void> _pickDocument({
    required void Function(String fileName) onSelected,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
    );

    final fileName = result?.files.single.name;
    if (fileName == null) {
      return;
    }

    onSelected(fileName);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _companyController.dispose();
    _policyController.dispose();
    _dobController.dispose();
    _marriedDateController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _startDateNotifier.dispose();
    _endDateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final view = View.of(context);
    final fullHeight = view.physicalSize.height / view.devicePixelRatio;
    final whiteBgHeight = fullHeight * 0.5;
    final today = DateUtils.dateOnly(DateTime.now());

    return Stack(
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
          body: SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(8, 40, 8, 8),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Insurance Information',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.eerieBlack,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Professional liability insurance protects both you '
                      "and your clients. It's mandatory for all service "
                      'providers on SuperAslan to ensure quality and safety '
                      'standards.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.paleSky,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const _AcceptedInsuranceCard(),
                    const SizedBox(height: 16),
                    const _SectionTitle(title: 'Insurance Details'),
                    const SizedBox(height: 10),
                    const _FieldLabel(text: 'Insurance Company Name *'),
                    TextFormFieldWidget(
                      controller: _companyController,
                      labelText: 'e.g., State Farm, Allstate',
                      fillColor: AppColors.white,
                      showBorder: true,
                      enabledBorderColor: AppColors.inputFocused,
                    ),
                    const _FieldLabel(text: 'Policy Number *'),
                    TextFormFieldWidget(
                      controller: _policyController,
                      labelText: 'Enter your policy number',
                      fillColor: AppColors.white,
                      showBorder: true,
                      enabledBorderColor: AppColors.inputFocused,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _FieldLabel(text: 'Date of Birth *'),
                              DateInputPickerFieldWidget(
                                controller: _dobController,
                                firstDate: DateTime(1900),
                                lastDate: today,
                                onDateSelected: (_) {},
                                scrollController: _scrollController,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _FieldLabel(text: 'Married Date'),
                              DateInputPickerFieldWidget(
                                controller: _marriedDateController,
                                firstDate: DateTime(1900),
                                lastDate: today,
                                onDateSelected: (_) {},
                                scrollController: _scrollController,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _FieldLabel(text: 'Start Date *'),
                              DateInputPickerFieldWidget(
                                controller: _startDateController,
                                selectedDateNotifier: _startDateNotifier,
                                firstDate: DateTime(2000),
                                lastDate:
                                    today.add(const Duration(days: 3650)),
                                linkedController: _endDateController,
                                linkedDateNotifier: _endDateNotifier,
                                scrollController: _scrollController,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _FieldLabel(text: 'End Date *'),
                              DateInputPickerFieldWidget(
                                controller: _endDateController,
                                selectedDateNotifier: _endDateNotifier,
                                firstDate: DateTime(2000),
                                minDateListenable: _startDateNotifier,
                                lastDate:
                                    today.add(const Duration(days: 3650)),
                                scrollController: _scrollController,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const _SectionTitle(title: 'Upload Documents'),
                    const SizedBox(height: 10),
                    const _FieldLabel(text: 'Insurance Certificate *'),
                    _UploadTile(
                      title: 'Tap to upload certificate',
                      subtitle: 'PDF, JPG, PNG (Max 5MB)',
                      icon: Icons.cloud_upload_outlined,
                      fileName: _certificateFileName,
                      onTap: () => _pickDocument(
                        onSelected: (fileName) => setState(() {
                          _certificateFileName = fileName;
                        }),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _FieldLabel(text: 'Proof of Coverage'),
                    _UploadTile(
                      title: 'Additional coverage documents',
                      subtitle: 'Optional - PDF, JPG, PNG',
                      icon: Icons.description_outlined,
                      fileName: _coverageFileName,
                      onTap: () => _pickDocument(
                        onSelected: (fileName) => setState(() {
                          _coverageFileName = fileName;
                        }),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const _StatusBanner(),
                    const SizedBox(height: 14),
                    const _RecommendationCard(),
                    const SizedBox(height: 16),
                    const _SectionTitle(title: 'Policy Validation Checklist'),
                    const SizedBox(height: 8),
                    _ChecklistItem(
                      label: 'Policy is currently active',
                      value: _checklist[0],
                      onChanged: (value) => setState(() {
                        _checklist[0] = value;
                      }),
                    ),
                    _ChecklistItem(
                      label: 'Minimum coverage amount met',
                      value: _checklist[1],
                      onChanged: (value) => setState(() {
                        _checklist[1] = value;
                      }),
                    ),
                    _ChecklistItem(
                      label: 'Certificate matches policy details',
                      value: _checklist[2],
                      onChanged: (value) => setState(() {
                        _checklist[2] = value;
                      }),
                    ),
                    _ChecklistItem(
                      label: 'Documents are legible and complete',
                      value: _checklist[3],
                      onChanged: (value) => setState(() {
                        _checklist[3] = value;
                      }),
                    ),
                    const SizedBox(height: 8),
                    const _SecurityNote(),
                    const SizedBox(height: 14),
                    BottomActionButton(
                      title: 'Verify Payment Account',
                      onPressed: () => context.go(PhoneVerificationPage.path),
                      horizontalPadding: 0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AcceptedInsuranceCard extends StatelessWidget {
  const _AcceptedInsuranceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.blueLight.withAlpha(36),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: 'Accepted Insurance Types:'),
          SizedBox(height: 8),
          _AcceptedInsuranceRow(text: 'General Liability Insurance'),
          SizedBox(height: 6),
          _AcceptedInsuranceRow(text: 'Professional Liability Coverage'),
          SizedBox(height: 6),
          _AcceptedInsuranceRow(text: 'Trade-Specific Insurance'),
        ],
      ),
    );
  }
}

class _AcceptedInsuranceRow extends StatelessWidget {
  const _AcceptedInsuranceRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle,
          color: AppColors.growthSuccess,
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.eerieBlack,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warningAccent.withAlpha(31),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.warningAccent.withAlpha(64),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.access_time,
              color: AppColors.warningAccent,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pending Verification',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.eerieBlack,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Documents will be reviewed within 24 hours',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.liver,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.red.shade50.withAlpha(179),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.warning_rounded,
                size: 18,
                color: AppColors.trendNegative,
              ),
              SizedBox(width: 8),
              Text(
                "Don't have insurance?",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.eerieBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'We recommend these trusted agencies where you can purchase '
            'professional liability insurance quickly and affordably.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.liver,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.eerieBlack,
              side: const BorderSide(color: AppColors.brightGrey),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.open_in_new, size: 16),
            label: const Text('View Recommended Agencies'),
          ),
        ],
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (checked) => onChanged(checked ?? false),
          activeColor: AppColors.confirmedColor,
          checkColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          side: const BorderSide(color: AppColors.inputFocused),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.liver,
            ),
          ),
        ),
      ],
    );
  }
}

class _SecurityNote extends StatelessWidget {
  const _SecurityNote();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.lock_outline,
          size: 16,
          color: AppColors.paleSky,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Security & Privacy: Your insurance information is encrypted and '
            'stored securely. We only use this data for verification purposes '
            'and never share it with third parties.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.paleSky,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _UploadTile extends StatelessWidget {
  const _UploadTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.fileName,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final String? fileName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: _DashedBorder(
        radius: 14,
        color: AppColors.inputFocused,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
          child: Column(
            children: [
              Icon(
                icon,
                color: AppColors.paleSky,
                size: 34,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.liver,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.paleSky,
                ),
              ),
              if (fileName != null) ...[
                const SizedBox(height: 8),
                Text(
                  fileName!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.liver,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 10),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.inputEnabled,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Choose File',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.liver,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.eerieBlack,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.eerieBlack,
      ),
    );
  }
}

class _DashedBorder extends StatelessWidget {
  const _DashedBorder({
    required this.child,
    required this.radius,
    required this.color,
  });

  final Widget child;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _DashedBorderPainter(
        radius: radius,
        color: color,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: ColoredBox(
          color: AppColors.white,
          child: child,
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({
    required this.radius,
    required this.color,
  });

  static const double _strokeWidth = 1;
  static const double _dashLength = 4;
  static const double _dashGap = 4;

  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(radius),
        ),
      );

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + _dashLength;
        final segment = metric.extractPath(
          distance,
          next > metric.length ? metric.length : next,
        );
        canvas.drawPath(segment, paint);
        distance = next + _dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.radius != radius || oldDelegate.color != color;
  }
}

```

# signup/view/payment_setup_page.dart

```dart
import 'package:app_ui/app_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_methgo_app/features/shared/widgets/bottom_action_button.dart';
import 'package:flutter_methgo_app/features/shared/widgets/text_form_field_widget.dart';
import 'package:flutter_methgo_app/features/auth/signup/view/insurance_information_page.dart';
import 'package:go_router/go_router.dart';

class PaymentSetupPage extends StatefulWidget {
  const PaymentSetupPage({super.key});

  static const String path = '/payment-setup';

  @override
  State<PaymentSetupPage> createState() => _PaymentSetupPageState();
}

class _PaymentSetupPageState extends State<PaymentSetupPage> {
  final _fullNameController = TextEditingController();
  final _ibanController = TextEditingController();
  final _routingController = TextEditingController();
  final _billingAddressController = TextEditingController();
  String? _governmentIdFileName;

  final _providers = const [
    _PaymentProvider(
      name: 'Stripe',
      subtitle: 'Express payouts',
      shortLabel: 'S',
      color: AppColors.secondary,
    ),
    _PaymentProvider(
      name: 'Alma',
      subtitle: 'European transfers',
      shortLabel: 'A',
      color: AppColors.growthSuccess,
    ),
  ];

  int _selectedProviderIndex = -1;

  bool get _isFormComplete =>
      _selectedProviderIndex >= 0 &&
      _governmentIdFileName != null &&
      _fullNameController.text.trim().isNotEmpty &&
      _ibanController.text.trim().isNotEmpty &&
      _routingController.text.trim().isNotEmpty &&
      _billingAddressController.text.trim().isNotEmpty;

  Future<void> _pickGovernmentId() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
    );

    final fileName = result?.files.single.name;
    if (fileName == null) {
      return;
    }

    setState(() {
      _governmentIdFileName = fileName;
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _ibanController.dispose();
    _routingController.dispose();
    _billingAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final view = View.of(context);
    final fullHeight = view.physicalSize.height / view.devicePixelRatio;
    final whiteBgHeight = fullHeight * 0.5;

    return Stack(
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
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(8, 24, 8, 8),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Payment Setup',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.eerieBlack,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'To receive payouts securely, we need to verify your '
                      'identity and link a trusted payment method. This '
                      'ensures compliance with financial regulations and '
                      'protects your earnings.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.paleSky,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _InfoCard(),
                    const SizedBox(height: 16),
                    Text(
                      'Choose Payment Provider',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.eerieBlack,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: List.generate(_providers.length, (index) {
                        final provider = _providers[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _ProviderTile(
                            provider: provider,
                            isSelected: _selectedProviderIndex == index,
                            onTap: () => setState(() {
                              _selectedProviderIndex = index;
                            }),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 6),
                    const _FieldLabel(text: 'Full Legal Name'),
                    TextFormFieldWidget(
                      controller: _fullNameController,
                      labelText: 'Enter your full name as shown on ID',
                      fillColor: AppColors.white,
                      showBorder: true,
                      enabledBorderColor: AppColors.inputFocused,
                      onChanged: (_) => setState(() {}),
                    ),
                    const _FieldLabel(text: 'IBAN / Account Number'),
                    TextFormFieldWidget(
                      controller: _ibanController,
                      labelText: 'Enter your bank account number',
                      keyboardType: TextInputType.number,
                      fillColor: AppColors.white,
                      showBorder: true,
                      enabledBorderColor: AppColors.inputFocused,
                      onChanged: (_) => setState(() {}),
                    ),
                    const _FieldLabel(text: 'Routing Number'),
                    TextFormFieldWidget(
                      controller: _routingController,
                      labelText: 'Bank routing number (if applicable)',
                      keyboardType: TextInputType.number,
                      fillColor: AppColors.white,
                      showBorder: true,
                      enabledBorderColor: AppColors.inputFocused,
                      onChanged: (_) => setState(() {}),
                    ),
                    const _FieldLabel(text: 'Billing Address'),
                    TextFormField(
                      controller: _billingAddressController,
                      minLines: 2,
                      maxLines: 3,
                      onChanged: (_) => setState(() {}),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 14,
                        fontWeight: AppFontWeight.medium,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter your complete billing address',
                        hintStyle: Theme.of(context).textTheme.bodyLarge
                            ?.copyWith(
                              color: AppColors.grey,
                              fontSize: 14,
                              fontWeight: AppFontWeight.medium,
                            ),
                        fillColor: AppColors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.inputFocused,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 1.2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.inputFocused,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const _FieldLabel(text: 'Identity Verification'),
                    _UploadCard(
                      title: 'Upload Government ID',
                      subtitle: "Passport, driver's license, or national ID",
                      fileName: _governmentIdFileName,
                      onTap: _pickGovernmentId,
                    ),
                    const SizedBox(height: 16),
                    _SecurityNote(),
                    const SizedBox(height: 12),
                    BottomActionButton(
                      title: 'Verify Payment Account',
                      onPressed: _isFormComplete
                          ? () => context.go(InsuranceInformationPage.path)
                          : null,
                      horizontalPadding: 0,
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        'By continuing, you agree to our payment terms and '
                        'authorize account verification',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.paleSky,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.blueLight.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.blueLight.withOpacity(0.55),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                Assets.svg.infoCircle.svg(
                  width: 22,
                  height: 22,
                ),
                const SizedBox(width: 12),
                Text(
                  'What You Will Need',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.oceanBlue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          const _InfoRow(text: 'Full legal name (as on ID)'),
          const _InfoRow(text: 'Bank account or payment details'),
          const _InfoRow(text: 'Government-issued ID photo'),
          const _InfoRow(text: 'Billing address information'),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 44, bottom: 1),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.check,
              size: 14,
              color: AppColors.oceanBlue,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.oceanBlue,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderTile extends StatelessWidget {
  const _ProviderTile({
    required this.provider,
    required this.isSelected,
    required this.onTap,
  });

  final _PaymentProvider provider;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected
        ? AppColors.confirmedColor
        : AppColors.brightGrey;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: provider.color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  provider.shortLabel,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.eerieBlack,
                    ),
                  ),
                  Text(
                    provider.subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.paleSky,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.confirmedColor
                      : AppColors.inputFocused,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: CircleAvatar(
                        radius: 4,
                        backgroundColor: AppColors.confirmedColor,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.eerieBlack,
        ),
      ),
    );
  }
}

class _UploadCard extends StatelessWidget {
  const _UploadCard({
    required this.title,
    required this.subtitle,
    this.fileName,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String? fileName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: _DashedBorder(
        radius: 14,
        color: AppColors.inputFocused,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
          child: Column(
            children: [
              const Icon(
                Icons.cloud_upload_outlined,
                color: AppColors.paleSky,
                size: 40,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.liver,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.paleSky,
                ),
              ),
              const SizedBox(height: 10),
              if (fileName != null) ...[
                Text(
                  fileName!,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.liver,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
              ],
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Choose File',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecurityNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.green.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Secure & Compliant',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.growthSuccess,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your information is protected with PCI-DSS compliance and '
            'bank-level encryption. We never store sensitive payment details '
            'on our servers.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.liver,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedBorder extends StatelessWidget {
  const _DashedBorder({
    required this.child,
    required this.radius,
    required this.color,
  });

  final Widget child;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _DashedBorderPainter(
        radius: radius,
        color: color,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: ColoredBox(
          color: AppColors.white,
          child: child,
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({
    required this.radius,
    required this.color,
  });

  static const double _strokeWidth = 1;
  static const double _dashLength = 4;
  static const double _dashGap = 4;

  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(radius),
        ),
      );

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + _dashLength;
        final segment = metric.extractPath(
          distance,
          next.clamp(0.0, metric.length),
        );
        canvas.drawPath(segment, paint);
        distance = next + _dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.radius != radius || oldDelegate.color != color;
  }
}

class _PaymentProvider {
  const _PaymentProvider({
    required this.name,
    required this.subtitle,
    required this.shortLabel,
    required this.color,
  });

  final String name;
  final String subtitle;
  final String shortLabel;
  final Color color;
}

```

# signup/view/phone_verification_page.dart

```dart
import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_methgo_app/features/auth/signup/cubit/signup_cubit.dart';
import 'package:flutter_methgo_app/features/auth/signup/view/signup_details_page.dart';
import 'package:go_router/go_router.dart';

class PhoneVerificationPage extends StatefulWidget {
  const PhoneVerificationPage({super.key});

  static const String path = '/phone-verification';

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  static const int _codeLength = 6;
  static const int _resendTimeout = 60;

  final List<TextEditingController> _controllers = List.generate(
    _codeLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _nodes = List.generate(
    _codeLength,
    (_) => FocusNode(),
  );

  Timer? _timer;
  int _remainingSeconds = _resendTimeout;

  bool get _isCodeComplete =>
      _controllers.every((controller) => controller.text.trim().length == 1);

  bool get _canResend => _remainingSeconds == 0;

  @override
  void initState() {
    super.initState();
    for (final controller in _controllers) {
      controller.addListener(_handleCodeChanged);
    }
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final controller in _controllers) {
      controller
        ..removeListener(_handleCodeChanged)
        ..dispose();
    }
    for (final node in _nodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _remainingSeconds = _resendTimeout;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            _timer?.cancel();
          }
        });
      }
    });
  }

  void _handleCodeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _handleDigitChanged(int index, String value) {
    if (value.length > 1) {
      _controllers[index].text = value.substring(0, 1);
      _controllers[index].selection = const TextSelection.collapsed(offset: 1);
    }
    if (value.isNotEmpty && index < _codeLength - 1) {
      _nodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _nodes[index - 1].requestFocus();
    }
  }

  Future<void> _handleVerify() async {
    if (!_isCodeComplete) {
      return;
    }

    final code = _controllers.map((c) => c.text).join();
    context.read<SignupCubit>().verifyOtp(otp: code);
  }

  Future<void> _handleResend() async {
    if (!_canResend) {
      return;
    }

    final state = context.read<SignupCubit>().state;
    context.read<SignupCubit>().requestOtp(
          phone: state.phoneNumber,
          countryCode: state.countryCode,
        );
    
    _startTimer();
    for (final controller in _controllers) {
      controller.clear();
    }
    _nodes[0].requestFocus();
  }

  Widget _buildActionButtons(BuildContext context, SignupStatus status) {
    final isLoading = status == SignupStatus.loading;
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (_isCodeComplete && !isLoading) ? _handleVerify : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.white,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Verify',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                  ),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () => context.pop(),
          child: Text(
            'Back',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.paleSky,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final view = View.of(context);
    final mediaQuery = MediaQueryData.fromView(view);
    final size = mediaQuery.size;
    final fullHeight = view.physicalSize.height / view.devicePixelRatio;
    final whiteBgHeight = fullHeight * 0.545;
    final cardTop = size.height * 0.19;
    final isKeyboardVisible = mediaQuery.viewInsets.bottom > 0;

    return BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state.status == SignupStatus.otpVerified) {
          context.push(SignupDetailsPage.path);
        } else if (state.status == SignupStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Verification failed'),
              backgroundColor: Colors.red,
            ),
          );
          // We don't necessarily reset here, just let them try again or resend
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
                                child: BlocBuilder<SignupCubit, SignupState>(
                                  builder: (context, state) {
                                    return Column(
                                      children: [
                                        Text(
                                          'Phone Verification',
                                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.eerieBlack,
                                              ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "We've sent a 6-digit code to +${state.countryCode} ${state.phoneNumber}",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: AppColors.paleSky,
                                                height: 1.4,
                                              ),
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: List.generate(_codeLength, (index) {
                                            return _OtpBox(
                                              controller: _controllers[index],
                                              focusNode: _nodes[index],
                                              autoFocus: index == 0,
                                              onChanged: (value) => _handleDigitChanged(index, value),
                                            );
                                          }),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          "Didn't receive the code?",
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: AppColors.liver,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        GestureDetector(
                                          onTap: _canResend ? _handleResend : null,
                                          child: Text(
                                            _canResend ? 'Resend code' : 'Resend code in ${_remainingSeconds}s',
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: _canResend ? AppColors.primaryColor : AppColors.paleSky,
                                                  fontWeight: _canResend ? FontWeight.w600 : FontWeight.normal,
                                                ),
                                          ),
                                        ),
                                        if (isKeyboardVisible) ...[
                                          const SizedBox(height: 20),
                                          _buildActionButtons(context, state.status),
                                        ],
                                      ],
                                    );
                                  },
                                ),
                              ),
                              if (!isKeyboardVisible) const Spacer(),
                              if (!isKeyboardVisible)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  child: BlocBuilder<SignupCubit, SignupState>(
                                    builder: (context, state) {
                                      return _buildActionButtons(context, state.status);
                                    },
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
          ),
        ],
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.autoFocus = false,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool autoFocus;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autoFocus,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.eerieBlack,
            ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: AppColors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.inputFocused),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primaryColor,
              width: 1.4,
            ),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

```

# signup/view/signup_details_page.dart

```dart
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

```

# signup/view/signup_page.dart

```dart
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
      create: (context) => SignupCubit(userRepository: context.read<UserRepository>()),
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
          countryCode: _selectedCountry.dialCode,
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
          context.push(PhoneVerificationPage.path);
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
                                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 45),
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
                                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 24,
                                                    color: AppColors.black,
                                                  ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              'Enter your phone number to receive an OTP',
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                                              onChanged: (_) => _updateFormState(),
                                              validator: (value) {
                                                final text = value?.trim() ?? '';
                                                if (text.isEmpty) {
                                                  return 'Phone number is required';
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
                                                      '+${_selectedCountry.dialCode}',
                                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    const Icon(
                                                      Icons.keyboard_arrow_down_rounded,
                                                      size: 20,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 24),
                                            BlocBuilder<SignupCubit, SignupState>(
                                              builder: (context, state) {
                                                final isLoading = state.status == SignupStatus.loading;
                                                return BottomActionButton(
                                                  title: isLoading ? 'Sending OTP...' : 'Get OTP',
                                                  onPressed: (_isFormValid && !isLoading) ? _submit : null,
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
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                fontSize: 15,
                                              ),
                                        ),
                                        GestureDetector(
                                          onTap: () => context.go(LoginPage.path),
                                          child: Text(
                                            'Log In',
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

```

# signup/view/view.dart

```dart
export 'signup_page.dart';

```

