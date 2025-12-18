import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingFetchDataIndicator extends StatelessWidget {
  const LoadingFetchDataIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Loading...",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: AppFontWeight.medium,
                  color: AppColors.primaryColor,
                ),
          ),
          const SizedBox(width: AppSpacing.xxs),
          Container(
            height: 14,
            width: 14,
            margin: const EdgeInsets.only(top: 6),
            child: LoadingIndicator(
              indicatorType: Indicator.ballPulse,
              colors: [
                AppColors.primaryColor,
                AppColors.primaryColor.withAlpha(90),
                AppColors.primaryColor.withAlpha(80),
                AppColors.primaryColor.withAlpha(70),
                AppColors.primaryColor.withAlpha(10),
              ],
              strokeWidth: 2,
              backgroundColor: Colors.transparent,
              pathBackgroundColor: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
