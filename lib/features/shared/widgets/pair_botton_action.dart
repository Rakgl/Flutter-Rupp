import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class PairButtonAction extends StatelessWidget {
  const PairButtonAction({
    super.key,
    required this.leftTitle,
    required this.rightTitle,
    required this.onLeftPressed,
    required this.onRightPressed,
  });

  final String leftTitle;
  final String rightTitle;
  final VoidCallback? onLeftPressed;
  final VoidCallback? onRightPressed;

  static const mainColor = AppColors.primaryColor;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onLeftPressed,
                style: OutlinedButton.styleFrom(
                  foregroundColor: mainColor,
                  side: const BorderSide(color: mainColor),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.xxxlg),
                  ),
                ),
                child: Text(
                  leftTitle,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: onRightPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.xxxlg),
                  ),
                ),
                child: Text(
                  rightTitle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SingleButtonAction extends StatelessWidget {
  const SingleButtonAction({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: PairButtonAction.mainColor,
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.xxxlg),
            ),
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
