import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    required this.controller,
    super.key,
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
    this.onTap,
    this.readOnly = false,
    this.keyboardType,
    this.margin,
    this.fillColor,
    this.showBorder = false,
    this.enabledBorderColor,
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
  final VoidCallback? onTap;
  final bool readOnly;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry? margin;
  final Color? fillColor;
  final bool showBorder;
  final Color? enabledBorderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: AppSpacing.lg),
      child: TextFormField(
        controller: controller,
        cursorColor: borderColor,
        obscureText: obscureText,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          fontSize: 14,
          fontWeight: AppFontWeight.medium,
        ),
        decoration: InputDecoration(
          errorText: errorText,
          hintText: labelText,
          filled: true,
          prefixIcon: icon == null
              ? null
              : Container(
                  padding: const EdgeInsets.all(AppSpacing.xxs),
                  decoration: BoxDecoration(
                    color: borderColor.withAlpha(10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: borderColor,
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
              : suffixIcon == null
                  ? null
                  : Icon(
                      suffixIcon,
                      color: AppColors.grey,
                    ),
          fillColor: fillColor ?? AppColors.grey.shade100,
          hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: AppColors.grey,
            fontSize: 14,
            fontWeight: AppFontWeight.medium,
          ),
          contentPadding: icon == null
              ? const EdgeInsets.symmetric(horizontal: 16, vertical: 14)
              : const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: showBorder
                ? BorderSide(
                    color: enabledBorderColor ?? AppColors.inputFocused,
                  )
                : BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: borderColor,
              width: 1.2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: showBorder
                ? BorderSide(
                    color: enabledBorderColor ?? AppColors.inputFocused,
                  )
                : BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.red.shade400,
              width: 1.5,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.red.shade400,
              width: 1.5,
            ),
          ),
          errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.red.shade400,
          ),
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
