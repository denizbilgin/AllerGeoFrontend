import 'package:allergeo/models/allergies/allergen_model.dart';
import 'package:allergeo/models/users/user_model.dart';
import 'package:allergeo/screens/login_screen.dart';
import 'package:allergeo/services/allergies/allergen_service.dart';
import 'package:allergeo/services/users/user_service.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:allergeo/models/allergies/user_allergy_model.dart';
import 'package:allergeo/services/users/user_allergy_service.dart';
import 'package:allergeo/config/colors.dart';

class AddUserAllergyScreen extends StatefulWidget {
  final Function(UserAllergyModel) onAdd;

  const AddUserAllergyScreen({required this.onAdd, super.key});

  @override
  _AddUserAllergyScreenState createState() => _AddUserAllergyScreenState();
}

class _AddUserAllergyScreenState extends State<AddUserAllergyScreen> {
  final UserAllergyService service = UserAllergyService();
  AllergenService allergenService = AllergenService();
  UserService userService = UserService();
  late int _selectedAllergenId = 0;
  late int _selectedImportanceLevel = 3;
  late List<(String, int)> _allergens;

  final List<(String, int)> _importanceLevels = [
    ("Çok Düşük", 1),
    ("Düşük", 2),
    ("Orta", 3),
    ("Yüksek", 4),
    ("Çok Yüksek", 5),
  ];

  Future<void> _loadAllergens() async {
    try {
      List<AllergenModel> allergens = await allergenService.fetchAllergens();

      setState(() {
        _allergens =
            allergens.map((allergen) => (allergen.name, allergen.id)).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Alerjen bilgileri yüklenemedi: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAllergens();
  }

  void _addAllergy() async {
    try {
      if (_selectedAllergenId == 0 || _selectedAllergenId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Lütfen bir alerjen seçiniz.")));
        return;
      }

      int userId = await _getUserId();
      UserModel user = await userService.fetchUserById(userId);
      AllergenModel selectedAllergen = await allergenService.fetchAllergenById(
        _selectedAllergenId,
      );
      UserAllergyModel newUserAllergy = UserAllergyModel(
        allergen: selectedAllergen,
        importanceLevel: _selectedImportanceLevel,
        user: user,
      );

      await service.createUserAllergy(newUserAllergy);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Alerji eklendi")));
      widget.onAdd(newUserAllergy);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Alerji eklenemedi: $e")));
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Alerji Ekle"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Form(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Alerjen', style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 8),
                    DropdownSearch(
                      items: (f, cs) => _allergens,
                      compareFn: (item1, item2) => item1.$2 == item2.$2,
                      itemAsString: (item) => item.$1,
                      onChanged: (selectedAllergen) {
                        _selectedAllergenId = selectedAllergen!.$2;
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
                          hintText: 'Lütfen seçin...',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      popupProps: PopupProps.dialog(
                        itemBuilder: (
                          context,
                          (String, int) item,
                          isDisabled,
                          isSelected,
                        ) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              item.$1,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                        showSearchBox: true,
                        title: Container(
                          decoration: BoxDecoration(
                            color: AppColors.ALLERGEO_GREEN,
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'Alerjenler',
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
                    const SizedBox(height: 28),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Önem Seviyesi',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 8),
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
                              selectedImportance?.$2 ??
                              _selectedImportanceLevel;
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
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                        showSearchBox: false,
                        title: Container(
                          decoration: BoxDecoration(
                            color: AppColors.ALLERGEO_GREEN,
                          ),
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
                      child: ElevatedButton(
                        onPressed: _addAllergy,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.ALLERGEO_GREEN,
                        ),
                        child: Text(
                          "Ekle",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
