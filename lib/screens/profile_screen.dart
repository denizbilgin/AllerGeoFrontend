import 'package:allergeo/config/colors.dart';
import 'package:allergeo/models/users/user_model.dart';
import 'package:allergeo/screens/update_profile_screen.dart';
import 'package:allergeo/services/users/user_service.dart';
import 'package:allergeo/widgets/profile_menu.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          user == null
              ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.ALLERGEO_GREEN,
                ),
              )
              : SingleChildScrollView(
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
                              child: Image.asset(
                                service.getUserAvatarImage(user),
                              ),
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
                        Text('Hoş Geldiniz!'),
                        SizedBox(height: 20),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => UpdateProfileScreen(user: user)
                              );
                            },
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
                        const SizedBox(height: 30),
                        const Divider(),
                        const SizedBox(height: 10),

                        ProfileMenu(
                          title: "Ayarlar",
                          icon: Icons.settings,
                          onPress: () {},
                        ),
                        ProfileMenu(
                          title: "Üyeliğim",
                          icon: Icons.wallet,
                          onPress: () {},
                        ),
                        const Divider(),
                        const SizedBox(height: 10),
                        ProfileMenu(
                          title: "AllerGeo Hakkında",
                          icon: Icons.info,
                          onPress: () {},
                        ),
                        ProfileMenu(
                          title: 'Çıkış Yap',
                          icon: Icons.logout,
                          endIcon: false,
                          textColor: Colors.red,
                          onPress: () async {
                            await service.logout();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
