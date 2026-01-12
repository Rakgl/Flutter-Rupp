import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class IconTextWidget extends StatelessWidget {
  const IconTextWidget({
    required this.icon,
    required this.value,
    super.key,
  });

  final SvgGenImage icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          icon.svg(
            width: 16,
            height: 16,
            color: AppColors.primaryColor,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontSize: 12,
                color: AppColors.grey.shade600,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
