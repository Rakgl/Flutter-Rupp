import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class DropDownFilterWidget extends StatefulWidget {
  const DropDownFilterWidget({
    required this.title,
    required this.items,
    required this.onChanged,
    super.key,
    this.titleTextColor = AppColors.black,
    this.backgroundColor,
    this.height = 46,
  });

  final String title;
  final Color? titleTextColor;
  final List<DropdownMenuItem<Object>>? items;
  final ValueChanged<Object?>? onChanged;
  final Color? backgroundColor;
  final double height;

  @override
  _DropDownFilterWidgetState createState() => _DropDownFilterWidgetState();
}

class _DropDownFilterWidgetState extends State<DropDownFilterWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(32),
      ),
      child: DropdownButtonHideUnderline(
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: DropdownButton(
            elevation: 16,
            iconEnabledColor: AppColors.red,
            focusColor: AppColors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            hint: Text(
              widget.title,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: AppColors.grey.shade600,
                fontWeight: AppFontWeight.medium,
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            icon: const Icon(
              Icons.keyboard_arrow_down_outlined,
              color: AppColors.primaryColor,
              size: 16,
            ),
            onChanged: (newValue) => widget.onChanged?.call(newValue),
            items: widget.items,
          ),
        ),
      ),
    );
  }
}
