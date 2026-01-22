import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class BottomActionButton extends StatelessWidget {
  const BottomActionButton({
    required this.title,
    super.key,
    this.onPressed,
    this.child,
    this.horizontalPadding = 16,
  });

  final String title;
  final VoidCallback? onPressed;
  final Widget? child;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;
    final backgroundColor = isEnabled
        ? AppColors.primaryColor
        : AppColors.red.shade100;
    final textColor = AppColors.white;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(
          top: 16,
          left: horizontalPadding,
          right: horizontalPadding,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        decoration: const BoxDecoration(
          color: AppColors.white,
        ),
        child: Row(
          children: [
            ?child,
            if (child != null) const SizedBox(width: 16),
            Expanded(
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: isEnabled
                      ? [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.17),
                            blurRadius: 14,
                            offset: const Offset(0, 8),
                          ),
                        ]
                      : null,
                ),
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
