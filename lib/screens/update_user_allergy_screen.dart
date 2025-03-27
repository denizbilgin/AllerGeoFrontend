import 'package:allergeo/config/colors.dart';
import 'package:allergeo/models/allergies/user_allergy_model.dart';
import 'package:allergeo/models/users/user_model.dart';
import 'package:allergeo/screens/login_screen.dart';
import 'package:allergeo/services/users/user_allergy_service.dart';
import 'package:allergeo/services/users/user_service.dart';
import 'package:dropdown_search/dropdown_search.dart';
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

  final List<(String, int)> _importanceLevels = [
    ("Çok Düşük", 1),
    ("Düşük", 2),
    ("Orta", 3),
    ("Yüksek", 4),
    ("Çok Yüksek", 5),
  ];

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
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Önem Seviyesi:',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 8),
          DropdownSearch<(String, int)>(
            selectedItem: (_importanceLevels.firstWhere(
              (element) => element.$2 == _selectedImportanceLevel,
              orElse: () => ("Orta", 3),
            )),
            items: (f, cs) => _importanceLevels,
            compareFn: (item1, item2) => item1.$2 == item2.$2,
            itemAsString: (item) => item.$1,
            onChanged: (selectedImportance) {
              setState(() {
                _selectedImportanceLevel =
                    selectedImportance?.$2 ?? _selectedImportanceLevel;
              });
            },
            suffixProps: DropdownSuffixProps(
              dropdownButtonProps: DropdownButtonProps(
                iconClosed: Icon(Icons.keyboard_arrow_down),
                iconOpened: Icon(Icons.keyboard_arrow_up),
              ),
            ),
            decoratorProps: DropDownDecoratorProps(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 20),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'Önem Seviyesi Seçin...',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ),
            popupProps: PopupProps.dialog(
              itemBuilder: (context, item, isDisabled, isSelected) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    item.$1,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                );
              },
              showSearchBox: false,
              title: Container(
                decoration: BoxDecoration(color: AppColors.ALLERGEO_GREEN),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Önem Seviyesi',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
              ),
              dialogProps: DialogProps(
                clipBehavior: Clip.antiAlias,
                shape: OutlineInputBorder(
                  borderSide: BorderSide(width: 0),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
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
