import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppSwitchTile extends StatelessWidget {
  const AppSwitchTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.activeColor = AppColors.primaryColor,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: subtitle != null
            ? Text(subtitle!, style: const TextStyle(fontSize: 12, color: AppColors.grey))
            : null,
        value: value,
        onChanged: onChanged,
        activeTrackColor: activeColor,
      ),
    );
  }
}
