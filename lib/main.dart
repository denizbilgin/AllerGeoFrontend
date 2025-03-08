import 'package:allergeo/config/constants.dart';
import 'package:allergeo/screens/home_screen.dart';
import 'package:allergeo/screens/profile_screen.dart';
import 'package:allergeo/screens/travel_creation_screen.dart';
import 'package:allergeo/screens/user_allergies_screen.dart';
import 'package:allergeo/screens/user_allergy_attacks_screen.dart';
import 'package:allergeo/utils/strings.dart';
import 'package:allergeo/widgets/custom_bottom_navigation_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AllerGeoApp());
}

class AllerGeoApp extends StatelessWidget {
  const AllerGeoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AllerGeo',
      theme: ThemeData(
        primarySwatch: AppColors.ALLERGEO_GREEN,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int currentIndex = 2;

  final List<Widget> screens = [
    HomeScreen(),
    TravelCreationScreen(),
    UserAllergiesScreen(),
    ProfileScreen(),
    UserAllergyAttacksScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.ALLERGEO_GREEN,
      child: SafeArea(
        top: false,
        child: ClipRect(
          child: Scaffold(
            extendBody: true,
            appBar: AppBar(
              title: Text(Strings.APP_NAME),
              elevation: 0,
              centerTitle: true,
            ),
            body: screens[currentIndex],
            bottomNavigationBar: CustomBottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) => setState(() => currentIndex = index),
              navigationKey: navigationKey,
            ),
          ),
        ),
      ),
    );
  }
}