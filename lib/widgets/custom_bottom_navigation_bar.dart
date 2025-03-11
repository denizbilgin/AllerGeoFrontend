// widgets/custom_bottom_navigation_bar.dart
import 'package:allergeo/config/constants.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
    final icons = <Widget>[ 
      Padding(
        padding: const EdgeInsets.all(4),
        child: SvgPicture.asset(
          'assets/icons/map-icon.svg',
          width: 22,
          height: 22,
          color: Colors.white,
        ),
      ),
      Icon(Icons.grass),
      Icon(Icons.home),
      Icon(Icons.warning),
      Icon(Icons.person),
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