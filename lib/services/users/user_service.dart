import 'package:allergeo/config/constants.dart';
import 'package:allergeo/models/users/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  final String usersUrl = AppConstants.usersUrl;

  Future<UserModel> fetchUserById(int userId) async {
    try {
      final response = await http.get(Uri.parse("$usersUrl$userId"));

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonData = json.decode(data);
        return UserModel.fromJson(jsonData);
      } else if(response.statusCode == 404){
        throw jsonDecode(response.body).values.first;
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }
}