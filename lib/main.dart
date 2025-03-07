import 'package:allergeo/services/users/user_service.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter'da main'de async işler yapmak için gerekli.

  try {
    UserService service = UserService();
    
    var data = await service.fetchUserTravels(5);
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