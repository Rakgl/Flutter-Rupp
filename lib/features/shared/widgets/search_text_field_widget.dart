import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontWeight: AppFontWeight.regular,
          ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(
          IconlyLight.search,
          color: AppColors.primaryColor,
        ),
        fillColor: AppColors.white,
        hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontWeight: AppFontWeight.regular, color: AppColors.grey.shade500),
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
    );
  }
}
