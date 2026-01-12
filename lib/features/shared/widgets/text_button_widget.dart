import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {
  const TextButtonWidget({super.key, this.onTap, this.title});

  final VoidCallback? onTap;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        title ?? 'View all',
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontSize: 12,
          fontWeight: AppFontWeight.medium,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
