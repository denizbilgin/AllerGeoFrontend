import 'package:allergeo/config/colors.dart';
import 'package:allergeo/models/allergies/user_allergy_model.dart';
import 'package:allergeo/screens/add_user_allergy_screen.dart';
import 'package:allergeo/screens/login_screen.dart';
import 'package:allergeo/services/users/user_allergy_service.dart';
import 'package:allergeo/services/users/user_service.dart';
import 'package:allergeo/widgets/user_allergies_list_item.dart';
import 'package:flutter/material.dart';

class UserAllergiesScreen extends StatefulWidget {
  const UserAllergiesScreen({super.key});

  @override
  _UserAllergiesScreen createState() => _UserAllergiesScreen();
}

class _UserAllergiesScreen extends State<UserAllergiesScreen> {
  UserAllergyService service = UserAllergyService();
  UserService userService = UserService();
  List<UserAllergyModel>? userAllergies;

  @override
  void initState() {
    super.initState();
    _fetchUserAllergies();
  }

  Future<int> _getUserId() async {
    try {
      String token = await userService.getUserAccessToken();
      if (token == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        return 0;
      }
      final userId = await userService.getUserIdFromToken(token);
      return userId;
    } catch (e) {
      print('User ID alınırken hata: $e');
      return 0;
    }
  }

  Future<void> _fetchUserAllergies() async {
    try {
      int userId = await _getUserId();
      final fetchedUserAllergies = await service.fetchUserAllergies(userId);
      setState(() {
        userAllergies = fetchedUserAllergies;
      });
    } catch (e) {
      print('Alerji bilgileri alınırken hata: $e');
    }
  }

  void _handleUpdate(UserAllergyModel updatedAllergy) {
    setState(() {
      int index = userAllergies!.indexWhere((a) => a.id == updatedAllergy.id);
      if (index != -1) {
        userAllergies![index] = updatedAllergy;
      }
    });
  }

  void _deleteAllergy(UserAllergyModel allergyToDelete) async {
    try {
      int userId = await _getUserId();
      bool isDeleted = await service.deleteUserAllergy(
        userId,
        allergyToDelete.id!,
      );

      if (isDeleted) {
        setState(() {
          userAllergies?.removeWhere(
            (allergy) => allergy.id == allergyToDelete.id,
          );
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Alerji başarıyla silindi")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Alerji silinemedi: $e")));
    }
  }

  void _showAddAllergyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => AddUserAllergyScreen(
            onAdd: (newAllergy) {
              setState(() {
                _fetchUserAllergies();
              });
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alerjilerim')),
      body:
          userAllergies == null
              ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.ALLERGEO_GREEN,
                ),
              )
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: userAllergies!.length,
                      itemBuilder: (context, index) {
                        return UserAllergiesListItem(
                          userAllergy: userAllergies![index],
                          onUpdate: _handleUpdate,
                          onDelete: (deletedAllergy) {
                            _deleteAllergy(deletedAllergy);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAllergyModal(context),
        backgroundColor: AppColors.ALLERGEO_GREEN,
        child: const Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}
