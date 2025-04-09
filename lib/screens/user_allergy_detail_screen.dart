import 'package:allergeo/config/colors.dart';
import 'package:allergeo/models/allergies/user_allergy_model.dart';
import 'package:allergeo/models/users/user_model.dart';
import 'package:allergeo/screens/login_screen.dart';
import 'package:allergeo/services/users/user_allergy_service.dart';
import 'package:allergeo/services/users/user_service.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UserAllergyDetailScreen extends StatefulWidget {
  final UserAllergyModel userAllergy;
  final Function(UserAllergyModel) onUpdate;

  const UserAllergyDetailScreen({
    required this.userAllergy,
    required this.onUpdate,
  });

  @override
  _UserAllergyDetailScreen createState() => _UserAllergyDetailScreen();
}

class _UserAllergyDetailScreen extends State<UserAllergyDetailScreen> {
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

  Future<void> _launchURL(link) async {
    final Uri url = Uri.parse(link);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Bağlantı açılamadı: $link");
    }
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  service.getAllergenImage(widget.userAllergy),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userAllergy.allergen.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    'Tür: ${widget.userAllergy.allergen.speciesName}',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.grey),
                  ),
                  InkWell(
                    onTap:
                        () =>
                            _launchURL(widget.userAllergy.allergen.familyLink),
                    child: Text(
                      'Aile: ${widget.userAllergy.allergen.family}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  Text(
                    'Alerjen Tipi: ${widget.userAllergy.allergen.allergenType.name}',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.userAllergy.allergen.images.length,
              itemBuilder: (context, index) {
                String imageUrl = widget.userAllergy.allergen.images[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierColor: Colors.black.withOpacity(0.8),
                        builder: (context) {
                          double screenWidth = MediaQuery.of(context).size.width;
                          double screenHeight = MediaQuery.of(context).size.height;
                          double imageSize = screenWidth < screenHeight ? screenWidth * 0.8 : screenHeight * 0.8;

                          return GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  imageUrl,
                                  width: imageSize,
                                  height: imageSize,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _launchURL(widget.userAllergy.allergen.link),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.ALLERGEO_GREEN,
            ),
            child: Text(
              'Detaylı Bilgi İçin Tıklayınız',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 24),
          Text(
            "Alerji Bilgilerim",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Önem Seviyesi:', style: TextStyle(fontSize: 16)),
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
