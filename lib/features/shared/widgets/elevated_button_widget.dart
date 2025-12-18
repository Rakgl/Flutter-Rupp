import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ElevatedButtonWidget extends StatelessWidget {
  const ElevatedButtonWidget({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor = AppColors.primaryColor,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(56),
        ),
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 26,
        ),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: AppColors.white,
              fontSize: 14,
              fontWeight: AppFontWeight.medium,
            ),
      ),
    );
  }
}
