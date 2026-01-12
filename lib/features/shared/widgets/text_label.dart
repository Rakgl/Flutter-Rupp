import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class TextLabel extends StatelessWidget {
  const TextLabel({
    required this.label,
    super.key,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontWeight: AppFontWeight.medium,
        fontSize: 14,
      ),
    );
  }
}
