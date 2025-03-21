import 'package:allergeo/config/colors.dart';
import 'package:allergeo/models/users/user_model.dart';
import 'package:allergeo/services/users/user_service.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static final UserService service = UserService();
  UserModel? user;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      String token = await service.getUserAccessToken();
      if (token == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        return;
      }
      final userId = await service.getUserIdFromToken(token);
      final fetchedUser = await service.fetchUserById(userId);
      setState(() {
        user = fetchedUser;
      });
    } catch (e) {
      print('Kullanıcı bilgileri alınırken hata: $e');
    }
  }

  String getUserAvatarImage() {
    if (user?.isMale == true) {
      return 'assets/images/man-avatar.jpg';
    } else {
      return 'assets/images/woman-avatar.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: SizedBox(
                            width: 120,
                            height: 120,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.asset(getUserAvatarImage()),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          '${user?.firstName} ${user?.lastName}',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Hogeldiniz!'),
                        SizedBox(height: 20),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed:
                                () => null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.ALLERGEO_GREEN,
                              side: BorderSide.none,
                              shape: const StadiumBorder(),
                            ),
                            child: const Text(
                              'Profilimi Güncelle',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => service.logout(),
                          child: Text("Çıkış Yap"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
