import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import 'package:flutter_super_aslan_app/navigation/widgets/bottom_nav_bar_item.dart';

@visibleForTesting
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueSetter<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      padding: EdgeInsets.zero,
      elevation: 0,
      color: const Color(0xFF3B82F6), // Methgo blue
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            top: BorderSide(
              color: AppColors.grey.withAlpha(20),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: BottomAppBarItem(
                title: 'Home',
                iconSize: 24,
                icon: Icons.home_filled,
                isSelected: currentIndex == 0,
                onPressed: () => onTap(0),
              ),
            ),
            Expanded(
              child: BottomAppBarItem(
                title: 'Accessory',
                icon: Icons.category_rounded,
                isSelected: currentIndex == 1,
                onPressed: () => onTap(1),
              ),
            ),
            const SizedBox(width: 48), // Space for FAB
            Expanded(
              child: BottomAppBarItem(
                title: 'About',
                icon: Icons.account_tree_rounded,
                isSelected: currentIndex == 2,
                onPressed: () => onTap(2),
              ),
            ),
            Expanded(
              child: BottomAppBarItem(
                title: 'Favorites',
                icon: Icons.favorite,
                isSelected: currentIndex == 3,
                onPressed: () => onTap(3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
