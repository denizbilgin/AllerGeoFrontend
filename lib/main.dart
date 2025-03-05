import 'package:allergeo/models/allergies/allergen_model.dart';
import 'package:allergeo/models/allergies/user_allergy_model.dart';
import 'package:allergeo/models/predictors/ai_allergy_attack_prediction_model.dart';
import 'package:allergeo/models/users/user_model.dart';
import 'package:allergeo/services/allergies/allergen_service.dart';
import 'package:allergeo/services/places/district_service.dart';
import 'package:allergeo/services/predictors/ai_allergy_attack_prediction_service.dart';
import 'package:allergeo/services/users/user_service.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter'da main'de async işler yapmak için gerekli.

  try {
    UserService service = UserService();
    
    var data = await service.fetchUserAllergyAttackById(5, 13);
    print("Data: $data");
  } catch (e) {
    print(e);
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