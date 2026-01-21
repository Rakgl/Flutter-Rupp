import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppLogoutButton extends StatelessWidget {
  const AppLogoutButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.red,
          side: BorderSide(
            color: AppColors.red.withValues(alpha: 0.2),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.md),
          ),
        ),
        onPressed: onPressed,
        icon: const Icon(Icons.logout_rounded, size: 18),
        label: Text(
          "Logout",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.red,
              ),
        ),
      ),
    );
  }
}
