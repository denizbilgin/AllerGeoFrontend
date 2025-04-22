import 'package:allergeo/config/colors.dart';
import 'package:allergeo/models/places/district_model.dart';
import 'package:allergeo/models/predictors/ai_allergy_attack_prediction_model.dart';
import 'package:allergeo/models/users/travel_model.dart';
import 'package:allergeo/models/users/user_model.dart';
import 'package:allergeo/screens/login_screen.dart';
import 'package:allergeo/services/places/district_service.dart';
import 'package:allergeo/services/users/travel_service.dart';
import 'package:allergeo/services/users/user_service.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class TravelWaypointDetailScreen extends StatefulWidget {
  final AIAllergyAttackPredictionModel waypoint;
  final Function(AIAllergyAttackPredictionModel) onUpdate;
  final int travelId;

  const TravelWaypointDetailScreen({
    required this.waypoint,
    required this.onUpdate,
    required this.travelId,
  });

  @override
  _TravelWaypointDetailScreen createState() => _TravelWaypointDetailScreen();
}

class _TravelWaypointDetailScreen extends State<TravelWaypointDetailScreen> {
  late TextEditingController _dateController;
  late DateTime _selectedDate;
  List<(String, int)> _districts = [];
  late (String, int) _selectedDistrict;
  late int _selectedDistrictId;
  late bool? _hadAttack;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.waypoint.date;
    _dateController = TextEditingController(text: _formatDate(_selectedDate));

    _selectedDistrict = (
      widget.waypoint.district.name,
      widget.waypoint.district.id,
    );
    _selectedDistrictId = widget.waypoint.district.id;
    _hadAttack = widget.waypoint.hadAllergyAttack;
    _loadDistricts();
  }

  Future<void> _loadDistricts() async {
    try {
      DistrictService districtService = DistrictService();
      List<DistrictModel> districts = await districtService.fetchDistricts();
      setState(() {
        _districts = districts.map((d) => (d.name, d.id)).toList();

        _selectedDistrict = _districts.firstWhere(
          (d) => d.$2 == _selectedDistrictId,
          orElse: () => ('Seçiniz', 0),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("İlçe bilgileri yüklenemedi: $e")));
    }
  }

  Future<int> _getUserId() async {
    try {
      UserService userService = UserService();
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

  Future<void> _updateWaypoint() async {
    try {
      int userId = await _getUserId();
      UserService userService = UserService();
      UserModel user = await userService.fetchUserById(userId);

      DistrictService districtService = DistrictService();
      DistrictModel selectedDistrict = await districtService.fetchDistrictById(
        _selectedDistrictId,
      );

      TravelService travelService = TravelService();
      TravelModel travel = await travelService.fetchUserTravelById(
        userId,
        widget.travelId,
      );

      AIAllergyAttackPredictionModel updatedData =
          AIAllergyAttackPredictionModel(
            id: widget.waypoint.id,
            user: user,
            travel: travel,
            date: _selectedDate,
            district: selectedDistrict,
            selectedLocation: LatLng(
              selectedDistrict.latitude,
              selectedDistrict.longitude,
            ),
            hadAllergyAttack: _hadAttack,
          );

      AIAllergyAttackPredictionModel updatedWaypoint = await travelService
          .updateUserTravelWaypoint(updatedData);

      _showSnackBar(context, "Durak başarıyla güncellendi");
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      _showSnackBar(context, "Durak güncellenemedi");
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = widget.waypoint.date;
    DateTime firstDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      //initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.ALLERGEO_GREEN,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(message, style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
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
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.place, size: 20, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  "Durak Bilgilerim",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 24),
            Align(alignment: Alignment.centerLeft, child: Text('İlçe:')),
            const SizedBox(height: 8),
            DropdownSearch<(String, int)>(
              selectedItem: _selectedDistrict,
              items: (f, cs) => _districts,
              compareFn: (item1, item2) => item1.$2 == item2.$2,
              itemAsString: (item) => item.$1,
              onChanged: (selectedDistrict) {
                setState(() {
                  _selectedDistrict = selectedDistrict ?? _selectedDistrict;
                  _selectedDistrictId = _selectedDistrict.$2;
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
                  hintText: 'Lütfen seçin...',
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
                showSearchBox: true,
                title: Container(
                  decoration: BoxDecoration(color: AppColors.ALLERGEO_GREEN),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'İlçeler',
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
            TextFormField(
              readOnly: true,
              onTap: () => _selectDate(context),
              controller: _dateController,
              decoration: InputDecoration(
                label: const Text('Tarih'),
                prefixIcon: const Icon(Icons.calendar_today),
                labelStyle: const TextStyle(color: Colors.black),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.ALLERGEO_GREEN,
                    width: 2,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text('Alerji atağı geçirdiniz mi?'),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool?>(
                        value: true,
                        groupValue: _hadAttack,
                        onChanged: (value) {
                          setState(() {
                            _hadAttack = value;
                          });
                        },
                        title: const Text('Evet'),
                        activeColor: AppColors.ALLERGEO_GREEN,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool?>(
                        value: false,
                        groupValue: _hadAttack,
                        onChanged: (value) {
                          setState(() {
                            _hadAttack = value;
                          });
                        },
                        title: const Text('Hayır'),
                        activeColor: AppColors.ALLERGEO_GREEN,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool?>(
                        value: null,
                        groupValue: _hadAttack,
                        onChanged: (value) {
                          setState(() {
                            _hadAttack = value;
                          });
                        },
                        title: const Text('Belirtilmedi'),
                        activeColor: AppColors.ALLERGEO_GREEN,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateWaypoint,
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor: AppColors.ALLERGEO_GREEN,
                ),
                child: const Text(
                  "Güncelle",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              "Yapay Zeka Tahmini",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Model: '),
                Text(
                  widget.waypoint.model != null
                      ? '${widget.waypoint.model!.name} - ${widget.waypoint.model!.version}'
                      : 'Henüz Tanımlanmadı',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sonuç: '),
                Text(
                  widget.waypoint.model != null
                      ? widget.waypoint.aiPrediction.toString()
                      : 'Henüz Belirlenmedi',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
