import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    super.key,
    required this.controller,
    this.labelText,
    this.errorText,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.borderColor = AppColors.primaryColor,
    this.icon,
    this.suffixIcon,
    this.obscureText = false,
    this.isPassword = false,
    this.onToggleSuffix,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? errorText;
  final void Function(String)? onChanged;
  final void Function(String)? onSaved;
  final String? Function(String?)? validator;

  final Color borderColor;

  final IconData? icon;

  final IconData? suffixIcon;

  final bool obscureText;
  final bool isPassword;
  final VoidCallback? onToggleSuffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: AppSpacing.lg,
      ),
      child: TextFormField(
        controller: controller,
        cursorColor: borderColor,
        obscureText: obscureText,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: 14,
              fontWeight: AppFontWeight.medium,
            ),
        decoration: InputDecoration(
          errorText: errorText,
          hintText: labelText,
          prefixIcon: Container(
            padding: const EdgeInsets.all(AppSpacing.xxs),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withAlpha(10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primaryColor,
            ),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: onToggleSuffix,
                  icon: Icon(
                    obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.grey,
                  ),
                )
              : null,
          fillColor: AppColors.grey.shade50,
          hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: AppColors.grey,
                fontSize: 14,
                fontWeight: AppFontWeight.medium,
              ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              AppSpacing.xxlg,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              AppSpacing.xxlg,
            ),
            borderSide: const BorderSide(
              color: AppColors.primaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              AppSpacing.xxlg,
            ),
            borderSide: BorderSide(
              color: AppColors.grey.shade50,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              AppSpacing.xxlg,
            ),
            borderSide: BorderSide(
              color: AppColors.red.shade100,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              AppSpacing.xxlg,
            ),
            borderSide: BorderSide(
              color: AppColors.red.shade200,
            ),
          ),
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
