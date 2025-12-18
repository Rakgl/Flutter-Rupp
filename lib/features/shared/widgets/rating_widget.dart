import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class RatingWidget extends StatelessWidget {
  const RatingWidget({
    super.key,
    required this.rate,
  });

  final String rate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          IconlyBold.star,
          color: AppColors.yellow,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          rate,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 12,
                color: AppColors.grey.shade600,
              ),
        ),
        // const SizedBox(width: 8),
        // Text(
        //   "(3,234 reviews)",
        //   style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        //         fontSize: 12,
        //         color: AppColors.grey.shade600,
        //       ),
        // ),
      ],
    );
  }
}
