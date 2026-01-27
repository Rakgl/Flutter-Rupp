import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_super_aslan_app/features/shared/widgets/text_form_field_widget.dart';

class DateInputFieldWidget extends StatelessWidget {
  const DateInputFieldWidget({
    required this.controller,
    super.key,
    this.labelText,
    this.onTap,
    this.isActive = false,
    this.margin,
    this.inactiveBorderColor,
    this.activeBorderColor = AppColors.primaryColor,
  });

  final TextEditingController controller;
  final String? labelText;
  final VoidCallback? onTap;
  final bool isActive;
  final EdgeInsetsGeometry? margin;
  final Color? inactiveBorderColor;
  final Color activeBorderColor;

  @override
  Widget build(BuildContext context) {
    return TextFormFieldWidget(
      controller: controller,
      labelText: labelText,
      fillColor: AppColors.white,
      showBorder: true,
      enabledBorderColor:
          isActive ? activeBorderColor : inactiveBorderColor,
      margin: margin ?? EdgeInsets.zero,
      readOnly: true,
      onTap: onTap,
      suffixIcon: Icons.calendar_month_outlined,
    );
  }
}
