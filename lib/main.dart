import 'package:allergeo/models/places/city_model.dart';
import 'package:allergeo/models/places/city_vegetation_model.dart';
import 'package:allergeo/models/places/district_model.dart';
import 'package:allergeo/models/places/district_vegetation_model.dart';
import 'package:allergeo/screens/districts_list_screen.dart';
import 'package:allergeo/services/places/city_service.dart';
import 'package:allergeo/services/places/district_service.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter'da main'de async işler yapmak için gerekli.

  try {
    DistrictService service = DistrictService();
    List<DistrictVegetationModel> vegetations = await service.fetchDistrictVegetation(114);
    print("Data: $vegetations");
  } catch (e) {
    print("Hata oluştu: $e");
  }
}

/*
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'İlçeler Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DistrictListScreen(),
    );
  }
}
*/