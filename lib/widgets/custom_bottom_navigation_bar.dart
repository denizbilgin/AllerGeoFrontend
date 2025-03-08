// widgets/custom_bottom_navigation_bar.dart
import 'package:allergeo/config/constants.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final GlobalKey<CurvedNavigationBarState> navigationKey;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.navigationKey,
  });

  @override
  Widget build(BuildContext context) {
    final icons = <Icon>[ 
      Icon(Icons.home),
      Icon(Icons.add_location),
      Icon(Icons.medical_services),
      Icon(Icons.person),
      Icon(Icons.warning),
    ];

    return Theme(
      data: Theme.of(context).copyWith(
        iconTheme: IconThemeData(color: Colors.white),
      ),
      child: CurvedNavigationBar(
        key: navigationKey,
        height: 75,
        color: AppColors.ALLERGEO_GREEN,
        buttonBackgroundColor: AppColors.ALLERGEO_GREEN.shade400,
        backgroundColor: Colors.transparent,
        items: icons,
        index: currentIndex,
        onTap: onTap,
      ),
    );
  }
}