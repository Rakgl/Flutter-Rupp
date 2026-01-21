import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_super_aslan_app/features/welcome/welcome.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  static const String path = '/welcome';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WelcomeCubit(),
      child: const WelcomeView(),
    );
  }
}

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        /// Background image
        Assets.img.backgroundImage.image(
          fit: BoxFit.cover,
        ),

        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                const Spacer(flex: 2),

                /// Logo (floats naturally above the card)
                Assets.img.appLogo.image(
                  width: 150,
                  height: 150,
                ),

                /// Push content to bottom
                const Spacer(),

                /// Bottom card (anchored)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Welcome!',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Let's get started with SuperAslan for Professional!",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.grey.shade600,
                              ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Select Language',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                        ),
                        const SizedBox(height: 16),
                        BlocBuilder<WelcomeCubit, WelcomeState>(
                          builder: (context, state) {
                            return Column(
                              children: [
                                _LanguageOption(
                                  languageCode: 'ENGLISH',
                                  flag: '🇬🇧',
                                  isSelected:
                                      state.selectedLanguage ==
                                      Language.english,
                                  onTap: () => context
                                      .read<WelcomeCubit>()
                                      .selectLanguage(
                                        Language.english,
                                        context,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                _LanguageOption(
                                  languageCode: 'FRENCH (française)',
                                  flag: '🇫🇷',
                                  isSelected:
                                      state.selectedLanguage == Language.french,
                                  onTap: () => context
                                      .read<WelcomeCubit>()
                                      .selectLanguage(
                                        Language.french,
                                        context,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                _LanguageOption(
                                  languageCode: 'ARABIC (عربي)',
                                  flag: '🇸🇦',
                                  isSelected:
                                      state.selectedLanguage == Language.arabic,
                                  onTap: () => context
                                      .read<WelcomeCubit>()
                                      .selectLanguage(
                                        Language.arabic,
                                        context,
                                      ),
                                ),
                              ],
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
      ],
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.languageCode,
    required this.flag,
    required this.isSelected,
    required this.onTap,
  });

  final String languageCode;
  final String flag;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.grey.shade200,
            width: isSelected ? 2.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                languageCode,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.grey.shade100,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                flag,
                style: const TextStyle(fontSize: 28),
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryColor,
                size: 24,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
