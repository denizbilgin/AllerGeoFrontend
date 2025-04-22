import 'package:allergeo/config/colors.dart';
import 'package:allergeo/models/places/district_model.dart';
import 'package:allergeo/services/places/district_service.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class AddTravelWaypointScreen extends StatefulWidget {
  final int travelId;
  final DateTime initialDate;
  final void Function(DateTime date, int districtId) onSave;

  const AddTravelWaypointScreen({
    required this.travelId,
    required this.initialDate,
    required this.onSave,
  });

  @override
  _AddTravelWaypointScreen createState() => _AddTravelWaypointScreen();
}

class _AddTravelWaypointScreen extends State<AddTravelWaypointScreen> {
  late TextEditingController _dateController;
  late DateTime _selectedDate;
  (String, int)? _selectedDistrict;
  List<(String, int)> _districts = [];
  late int _selectedDistrictId;

  @override
  void initState() {
    _loadDistricts();
    super.initState();
    _selectedDate = widget.initialDate;
    _dateController = TextEditingController(text: _formatDate(_selectedDate));
  }

  Future<void> _loadDistricts() async {
    try {
      DistrictService service = DistrictService();
      List<DistrictModel> data = await service.fetchDistricts();
      setState(() {
        _districts = data.map((d) => (d.name, d.id)).toList();
        _selectedDistrict = _districts.firstWhere(
          (d) => d.$2 == _selectedDistrictId,
          orElse: () => ('Seçiniz', 0),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("İlçeler yüklenemedi: $e")));
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: widget.initialDate,
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

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
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
            "Durak Ekle",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24),
          Align(alignment: Alignment.centerLeft, child: Text('İlçe:')),
          SizedBox(height: 8),
          DropdownSearch<(String, int)>(
            selectedItem: _selectedDistrict,
            items: (f, cs) => _districts,
            compareFn: (a, b) => a.$2 == b.$2,
            itemAsString: (item) => item.$1,
            onChanged: (selected) {
              setState(() {
                _selectedDistrict = selected ?? _selectedDistrict;
                _selectedDistrictId = _selectedDistrict!.$2;
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
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'Lütfen seçin...',
              ),
            ),
            popupProps: PopupProps.dialog(
              itemBuilder: (context, item, isDisabled, isSelected) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    item.$1,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                );
              },
              showSearchBox: true,
              title: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: AppColors.ALLERGEO_GREEN),
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
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            readOnly: true,
            onTap: _selectDate,
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onSave(_selectedDate, _selectedDistrictId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.ALLERGEO_GREEN,
                shape: const StadiumBorder(),
              ),
              child: const Text(
                "Kaydet",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
