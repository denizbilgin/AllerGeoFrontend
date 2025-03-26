import 'package:allergeo/config/constants.dart';
import 'package:allergeo/models/allergies/user_allergy_model.dart';
import 'package:allergeo/models/users/user_model.dart';
import 'package:allergeo/services/users/user_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserAllergyService {
  final String usersUrl = AppConstants.usersUrl;
  final UserService userService = UserService();
  
  Future<List<UserAllergyModel>> fetchUserAllergies(int userId) async {
    try {
      String token = await userService.getUserAccessToken();
      final response = await http.get(
        Uri.parse("$usersUrl$userId/allergies"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        UserModel user = await userService.fetchUserById(userId);

        List<UserAllergyModel> userAllergies = userAllergiesFromJson(data);
        for (var userAllergy in userAllergies) {
          userAllergy.user = user;
        }

        return userAllergies;
      } else if(response.statusCode == 404){
        throw jsonDecode(response.body).values.first;
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }
  
  Future<UserAllergyModel> fetchUserAllergyById(int userId, int userAllergyId) async {
    try {
      final response = await http.get(Uri.parse("$usersUrl$userId/allergies/$userAllergyId"));

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonData = json.decode(data);

        UserAllergyModel userAllergy = UserAllergyModel.fromJson(jsonData);
        userAllergy.user = await userService.fetchUserById(userId);

        return userAllergy;
      } else if(response.statusCode == 404){
        throw jsonDecode(response.body).values.first;
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }

  Future<UserAllergyModel> createUserAllergy(UserAllergyModel userAllergy) async {
    try {
      final url = "$usersUrl${userAllergy.user?.id}/allergies";
      
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          // "Authorization": "Bearer $token"
        },
        body: jsonEncode(userAllergy.toJson()),
      );

      if (response.statusCode == 201) {
        String data = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(data);
        return UserAllergyModel.fromJson(jsonData);
      } else if(response.statusCode == 400){
        throw jsonDecode(response.body).values.first;
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }

  Future<UserAllergyModel> updateUserAllergy(UserAllergyModel userAllergy) async {
    try {
      final url = "$usersUrl${userAllergy.user?.id}/allergies/${userAllergy.id}";

      String token = await userService.getUserAccessToken();
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userAllergy.toJson()),
      );

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(data);
        return UserAllergyModel.fromJson(jsonData);
      } else if(response.statusCode == 400){
        throw jsonDecode(response.body).values.first;
      } else if(response.statusCode == 404){
        throw jsonDecode(response.body).values.first;
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }

  Future<bool> deleteUserAllergy(int userId, int userAllergyId) async {
    try {
      final url = "$usersUrl$userId/allergies/$userAllergyId";

      String token = await userService.getUserAccessToken();
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        }
      );

      if (response.statusCode == 204) {
        return true;
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