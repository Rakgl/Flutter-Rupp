import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    this.label,
    this.child,
    this.padding,
    this.action,
    this.margin = const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
    ),
  });

  final String? label;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final Widget? action;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (label != null) HeaderSection(title: label ?? ''),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: double.infinity,
          padding: padding ?? const EdgeInsets.all(AppSpacing.md),
          margin: margin,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSpacing.md),
          ),
          child: child,
        )
      ],
    );
  }
}
