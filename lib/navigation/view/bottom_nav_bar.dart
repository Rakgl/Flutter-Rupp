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
      color: AppColors.white,
      child: Container(
   
        decoration: BoxDecoration(
          color: AppColors.white.withAlpha(0),
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
                iconSize: 22,
                icon: Icons.home,
                isSelected: currentIndex == 0,
                onPressed: () => onTap(0),
              ),
            ),
            Expanded(
              child: BottomAppBarItem(
                title: 'Request',
                icon: Icons.request_page,
                isSelected: currentIndex == 1,
                onPressed: () => onTap(1),
              ),
            ),
            Expanded(
              child: BottomAppBarItem(
                title: 'Schedule',
                icon:  Icons.schedule,
                isSelected: currentIndex == 2,
                onPressed: () => onTap(2),
              ),
            ),
            Expanded(
              child: BottomAppBarItem(
                title: 'Message',
                icon:  Icons.message,
                isSelected: currentIndex == 3,
                onPressed: () => onTap(3),
              ),
            ),
            Expanded(
              child: BottomAppBarItem(
                title: 'Profile',
                icon: Icons.person,
                isSelected: currentIndex == 4,
                onPressed: () => onTap(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
