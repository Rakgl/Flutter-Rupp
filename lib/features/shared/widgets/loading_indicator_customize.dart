import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingIndicatorCustomize extends StatelessWidget {
  const LoadingIndicatorCustomize({super.key, this.size = 46});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: size,
        width: size,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: LoadingIndicator(
          indicatorType: Indicator.ballSpinFadeLoader,
          colors: const [
            AppColors.primaryColor,
          ],
          strokeWidth: 2,
          pathBackgroundColor: AppColors.primaryColor.withAlpha(10),
        ),
      ),
    );
  }
}
