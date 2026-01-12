import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class DialogCustomize {
  static Future<void> customAnimatedDialog(
    BuildContext context,
    String title,
    String bodyContent,
    String actionText1,
    String actionText2,
    VoidCallback cancelAction,
    VoidCallback confirmAction,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.lg),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xlg,
            vertical: AppSpacing.xlg,
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          title: Center(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: AppFontWeight.medium,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                bodyContent,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  height: 1.7,
                ),
              ),
              const SizedBox(height: AppSpacing.xlg),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.red,
                        backgroundColor: Colors.red.shade50,
                      ),
                      onPressed: cancelAction,
                      child: Text(
                        actionText1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: confirmAction,
                      child: Text(
                        actionText2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
