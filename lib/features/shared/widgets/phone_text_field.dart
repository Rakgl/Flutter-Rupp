import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneTextFieldWidget extends StatelessWidget {
  const PhoneTextFieldWidget({
    required this.controller,
    super.key,
    this.labelText,
    this.errorText,
    this.validator,
    this.prefix,
    this.onChanged,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? errorText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  final Widget? prefix;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: AppSpacing.lg,
      ),
      child: TextFormField(
        controller: controller,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          fontSize: 14,
          fontWeight: AppFontWeight.medium,
        ),
        inputFormatters: [
          // allow digit only
          FilteringTextInputFormatter.digitsOnly,
        ],
        cursorColor: AppColors.primaryColor,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          errorText: errorText,
          hintText: labelText,
          counterText: '',
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
          prefix: prefix,
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
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}
