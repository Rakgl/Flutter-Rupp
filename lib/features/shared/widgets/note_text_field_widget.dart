import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class NoteTextField extends StatelessWidget {
  const NoteTextField({
    required this.hintText,
    super.key,
    this.controller,
    this.onTap,
    this.maxLines = 2,
    this.onChanged,
    this.backgroundColor = AppColors.white,
    this.readOnly = false,
  });

  final TextEditingController? controller;
  final String hintText;
  final VoidCallback? onTap;
  final int maxLines;
  final void Function(String)? onChanged;
  final Color? backgroundColor;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      onTap: onTap,
      onChanged: onChanged,
      readOnly: readOnly,
      cursorColor: AppColors.primaryColor,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontWeight: AppFontWeight.medium,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontWeight: AppFontWeight.medium,
          fontSize: 13,
          color: AppColors.grey.shade600,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppSpacing.sm),
          ),
          borderSide: BorderSide.none,
        ),
        fillColor: backgroundColor,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppSpacing.sm),
          ),
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppSpacing.sm),
          ),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
      ),
    );
  }
}
