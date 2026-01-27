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
    final field = TextFormField(
      controller: controller,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        fontSize: 14,
        fontWeight: AppFontWeight.medium,
      ),
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
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
        filled: true,
        fillColor: AppColors.white,
        hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: AppColors.grey,
          fontSize: 14,
          fontWeight: AppFontWeight.medium,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.grey.shade300,
          ),
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
      validator: validator,
      onChanged: onChanged,
    );

    return Container(
      margin: const EdgeInsets.only(
        bottom: AppSpacing.lg,
      ),
      child: prefix == null
          ? field
          : IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.grey.shade300,
                      ),
                    ),
                    child: Center(child: prefix),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: field),
                ],
              ),
            ),
    );
  }
}
