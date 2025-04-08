import 'package:allergeo/screens/home_screen.dart';
import 'package:allergeo/screens/login_screen.dart';
import 'package:allergeo/screens/profile_screen.dart';
import 'package:allergeo/screens/travel_screen.dart';
import 'package:allergeo/screens/user_allergies_screen.dart';
import 'package:allergeo/screens/user_travels_screen.dart';
import 'package:allergeo/widgets/custom_bottom_navigation_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:allergeo/config/colors.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


void main() async {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  await dotenv.load();
  runApp(const AllerGeoApp());
}

class AllerGeoApp extends StatelessWidget {
  const AllerGeoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(primarySwatch: AppColors.ALLERGEO_GREEN),
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
    TravelScreen(),
    UserAllergiesScreen(),
    HomeScreen(),
    UserTravelsScreen(),
    //UserAllergyAttacksScreen(),
    ProfileScreen(),
  ];

  Future<bool> _isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    return isLoggedIn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: FutureBuilder<bool>(
        future: _isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == false) {
            return LoginScreen();
          }

          return Scaffold(
            body: screens[currentIndex],
            bottomNavigationBar: CustomBottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) => setState(() => currentIndex = index),
              navigationKey: navigationKey,
            ),
          );
        },
      ),
    );
  }
}
