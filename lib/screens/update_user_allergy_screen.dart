import 'package:allergeo/config/colors.dart';
import 'package:allergeo/models/allergies/user_allergy_model.dart';
import 'package:allergeo/models/users/user_model.dart';
import 'package:allergeo/screens/login_screen.dart';
import 'package:allergeo/services/users/user_allergy_service.dart';
import 'package:allergeo/services/users/user_service.dart';
import 'package:flutter/material.dart';

class UpdateUserAllergyScreen extends StatefulWidget {
  final UserAllergyModel userAllergy;
  final Function(UserAllergyModel) onUpdate;

  const UpdateUserAllergyScreen({
    required this.userAllergy,
    required this.onUpdate,
  });

  @override
  _UpdateUserAllergyScreen createState() => _UpdateUserAllergyScreen();
}

class _UpdateUserAllergyScreen extends State<UpdateUserAllergyScreen> {
  late int _selectedImportanceLevel;
  UserAllergyService service = UserAllergyService();
  UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    _selectedImportanceLevel = widget.userAllergy.importanceLevel;
  }

  void _updateAllergy() async {
    try {
      int userId = await _getUserId();
      UserModel user = await userService.fetchUserById(userId);

      UserAllergyModel updatedAllergy = UserAllergyModel(
        id: widget.userAllergy.id,
        allergen: widget.userAllergy.allergen,
        importanceLevel: _selectedImportanceLevel,
        creationDate: widget.userAllergy.creationDate,
        user: user,
      );

      await service.updateUserAllergy(updatedAllergy);

      widget.onUpdate(updatedAllergy);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Alerji güncellendi")));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Alerji güncellenemedi: $e")));
    }
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Alerji Güncelle",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          DropdownButton<int>(
            value: _selectedImportanceLevel,
            isExpanded: true,
            items: [
              DropdownMenuItem(value: 1, child: Text("Çok Düşük")),
              DropdownMenuItem(value: 2, child: Text("Düşük")),
              DropdownMenuItem(value: 3, child: Text("Orta")),
              DropdownMenuItem(value: 4, child: Text("Yüksek")),
              DropdownMenuItem(value: 5, child: Text("Çok Yüksek")),
            ],
            onChanged: (value) {
              setState(() {
                _selectedImportanceLevel = value!;
              });
            },
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: _updateAllergy,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.ALLERGEO_GREEN,
                ),
                child: Text("Güncelle", style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
