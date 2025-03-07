import 'package:allergeo/services/users/travel_service.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter'da main'de async işler yapmak için gerekli.

  try {
    var service = TravelService();
    var data = await service.deleteUserTravel(5, 6);
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