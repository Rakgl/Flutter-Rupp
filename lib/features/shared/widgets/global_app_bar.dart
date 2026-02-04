import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GlobalAppBar({
    super.key,
    required this.title,
    this.actions,
    this.backgroundColor = AppColors.white,
    this.elevation = 0,
    this.centerTitle = true,
    this.leading,
    this.titleWidget,
    this.onLeadingPressed,
  });

  final String title;
  final List<Widget>? actions;
  final Color backgroundColor;
  final double elevation;
  final bool centerTitle;
  final Widget? leading;
  final Widget? titleWidget;
  final VoidCallback? onLeadingPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: backgroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
      leading: leading ??
          IconButton(
            icon: const Icon(IconlyLight.arrowLeft, color: AppColors.black),
            onPressed: onLeadingPressed ?? () => context.pop(),
          ),
      title: titleWidget ??
          Text(
            title,
            style: UITextStyle.headline4.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
