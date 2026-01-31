import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppSliverAppBar extends StatelessWidget {
  const AppSliverAppBar({
    required this.title,
    super.key,
    this.bottom,
    this.centerTitle = false,
    this.expandedHeight = 80,
    this.collapsedHeight = 80,
    this.titlePadding,
    this.backgroundContent,
    this.toolbarHeight = kToolbarHeight,
  });

  final Widget title;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;
  final double expandedHeight;
  final double collapsedHeight;
  final EdgeInsetsGeometry? titlePadding;
  final Widget? backgroundContent;
  final double toolbarHeight;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: expandedHeight,
      collapsedHeight: collapsedHeight,
      toolbarHeight: toolbarHeight,
      backgroundColor: Colors.transparent, // Background handled by flexibleSpace
      automaticallyImplyLeading: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
        child: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          titlePadding: titlePadding,
          centerTitle: centerTitle,
          background: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                Assets.img.spaceBg.path,
                package: 'app_ui',
                fit: BoxFit.cover,
              ),
              if (backgroundContent != null) backgroundContent!,
            ],
          ),
          title: title,
        ),
      ),
      bottom: bottom,
    );
  }
}
