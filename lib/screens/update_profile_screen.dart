import 'package:allergeo/config/colors.dart';
import 'package:allergeo/models/places/district_model.dart';
import 'package:allergeo/models/users/user_model.dart';
import 'package:allergeo/services/places/district_service.dart';
import 'package:flutter/material.dart';
import 'package:allergeo/services/users/user_service.dart';
import 'package:dropdown_search/dropdown_search.dart';

class UpdateProfileScreen extends StatefulWidget {
  final UserModel? user;
  const UpdateProfileScreen({super.key, this.user});

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  static final UserService service = UserService();
  static final DistrictService districtService = DistrictService();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _dateOfBirthController;
  late (String, int) _selectedDistrict = ('Seçiniz', 0);
  late int _selectedDistrictId;
  late List<(String, int)> _districts;

  @override
  void initState() {
    super.initState();
    final user = widget.user;
    _firstNameController = TextEditingController(text: user?.firstName);
    _lastNameController = TextEditingController(text: user?.lastName);
    _emailController = TextEditingController(text: user?.email);
    _phoneNumberController = TextEditingController(text: user?.phoneNumber);
    _dateOfBirthController = TextEditingController(
      text: user?.dateOfBirth.toIso8601String().split('T')[0],
    );
    _selectedDistrictId = user?.residenceDistrict.id ?? 1;
    _districts = [];
    _loadDistricts();
  }

  Future<void> _loadDistricts() async {
    try {
      List<DistrictModel> districts = await districtService.fetchDistricts();
      setState(() {
        _districts =
            districts.map((district) => (district.name, district.id)).toList();

        _selectedDistrict = _districts.firstWhere(
          (district) => district.$2 == _selectedDistrictId,
          orElse: () => ('Seçiniz', 0),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("İlçe bilgileri yüklenemedi: $e")));
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    final updatedData = {
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'email': _emailController.text,
      'phone_number': _phoneNumberController.text,
      'date_of_birth': _dateOfBirthController.text,
      'is_male': widget.user?.isMale ?? true,
      'residence_district': _selectedDistrictId,
    };

    try {
      UserModel updatedUser = await service.updateUser(
        widget.user?.id ?? 0,
        updatedData,
      );
      setState(() {
        widget.user?.firstName = updatedUser.firstName;
        widget.user?.lastName = updatedUser.lastName;
        widget.user?.email = updatedUser.email;
        widget.user?.phoneNumber = updatedUser.phoneNumber;
        widget.user?.dateOfBirth = updatedUser.dateOfBirth;
        widget.user?.residenceDistrict = updatedUser.residenceDistrict;

        Navigator.pop(context);
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Profil güncellendi")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Profil güncellenemedi: $e")));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        _dateOfBirthController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profilimi Güncelle"),
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
              SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(service.getUserAvatarImage(user)),
                ),
              ),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        label: Text('İsim'),
                        prefixIcon: Icon(Icons.verified_user_rounded),
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.ALLERGEO_GREEN,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        label: Text('Soyisim'),
                        prefixIcon: Icon(Icons.verified_user_rounded),
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.ALLERGEO_GREEN,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        label: Text('E-posta'),
                        prefixIcon: Icon(Icons.email),
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.ALLERGEO_GREEN,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneNumberController,
                      decoration: const InputDecoration(
                        label: Text('Telefon Numarası'),
                        prefixIcon: Icon(Icons.phone),
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.ALLERGEO_GREEN,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _dateOfBirthController,
                      decoration: const InputDecoration(
                        label: Text('Doğum Tarihi (YYYY-AA-GG)'),
                        prefixIcon: Icon(Icons.calendar_today),
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.ALLERGEO_GREEN,
                            width: 2,
                          ),
                        ),
                      ),
                      readOnly: true, // Sadece takvimle seçilmesini sağlıyoruz.
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 16),

                    DropdownSearch<(String, int)>(
                      selectedItem: _selectedDistrict,
                      items: (f, cs) => _districts,
                      compareFn: (item1, item2) => item1.$2 == item2.$2,
                      itemAsString: (item) => item.$1,
                      onChanged: (selectedDistrict) {
                        _selectedDistrict =
                            selectedDistrict ?? _selectedDistrict;
                        _selectedDistrictId = _selectedDistrict.$2;
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
                          decoration: BoxDecoration(
                            color: AppColors.ALLERGEO_GREEN,
                          ),
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
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _updateProfile,
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
                    const SizedBox(height: 32),
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
