import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
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

    if (kDebugMode) {
      for (final controller in _controllers) {
        controller.text = '0';
      }
    }
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
          context.push(
            SignupDetailsPage.path,
            extra: context.read<SignupCubit>(),
          );
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
