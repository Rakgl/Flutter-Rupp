import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class RowButtonWidget extends StatelessWidget {
  const RowButtonWidget({
    required this.leftLabel,
    required this.rightLabel,
    required this.leftOnTap,
    super.key,
    this.rightOnTap,
    this.centerOnTap,
    this.centerLabel,
  });

  final String leftLabel;
  final String rightLabel;
  final String? centerLabel;
  final VoidCallback? leftOnTap;
  final VoidCallback? rightOnTap;
  final VoidCallback? centerOnTap;

  @override
  Widget build(BuildContext context) {
    const mainColor = AppColors.primaryColor;

    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: leftOnTap,
            style: OutlinedButton.styleFrom(
              foregroundColor: leftOnTap == null
                  ? AppColors.grey
                  : AppColors.red,
              side: BorderSide(
                color: leftOnTap == null ? AppColors.grey : AppColors.red,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.xxxlg),
              ),
            ),
            child: Text(
              leftLabel,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: leftOnTap == null ? AppColors.grey : AppColors.red,
              ),
            ),
          ),
        ),
        if (centerOnTap != null)
          Expanded(
            child: OutlinedButton(
              onPressed: centerOnTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: mainColor,
                side: const BorderSide(color: mainColor),
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.xxxlg),
                ),
              ),
              child: Text(
                centerLabel!,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: mainColor,
                ),
              ),
            ),
          ),
        Expanded(
          child: OutlinedButton(
            onPressed: rightOnTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: mainColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.xxxlg),
                side: const BorderSide(color: mainColor),
              ),
            ),
            child: Text(
              rightLabel,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: rightOnTap == null ? AppColors.grey : AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
