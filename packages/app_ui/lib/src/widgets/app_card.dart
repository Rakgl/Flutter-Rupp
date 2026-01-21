import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// A container with standard App UI styling:
/// - White background
/// - Rounded corners (12px)
/// - Subtle grey border
/// - Bottom margin (AppSpacing.md)
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? const EdgeInsets.only(bottom: AppSpacing.md),
        padding: padding,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey.shade200),
        ),
        child: child,
      ),
    );
  }
}
