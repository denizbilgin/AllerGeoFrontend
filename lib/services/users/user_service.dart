import 'package:allergeo/config/constants.dart';
import 'package:allergeo/models/allergies/allergen_model.dart';
import 'package:allergeo/models/allergies/user_allergy_model.dart';
import 'package:allergeo/models/predictors/ai_allergy_attack_prediction_model.dart';
import 'package:allergeo/models/users/travel_model.dart';
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

  // User Allergy Functions
  Future<List<UserAllergyModel>> fetchUserAllergies(int userId) async {
    try {
      final response = await http.get(Uri.parse("$usersUrl$userId/allergies"));

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        UserModel user = await fetchUserById(userId);

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
        userAllergy.user = await fetchUserById(userId);

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

  Future<UserAllergyModel> createUserAllergy(UserAllergyModel userAllergyModel) async {
    try {
      final url = "$usersUrl${userAllergyModel.user?.id}/allergies";
      
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          // "Authorization": "Bearer $token"
        },
        body: jsonEncode(userAllergyModel.toJson()),
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

  Future<UserAllergyModel> updateUserAllergy(UserAllergyModel userAllergyModel) async {
    try {
      final url = "$usersUrl${userAllergyModel.user?.id}/allergies/${userAllergyModel.id}";
      
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          // "Authorization": "Bearer $token"
        },
        body: jsonEncode(userAllergyModel.toJson()),
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
      
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          // "Authorization": "Bearer $token"
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

  // Allergy Attack Functions
  Future<List<AIAllergyAttackPredictionModel>> fetchUserAllergyAttacks(int userId) async {
    try {
      final response = await http.get(Uri.parse("$usersUrl$userId/allergy-attacks"));

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        return aiAllergyAttackPredictionsFromJson(data);
      } else if(response.statusCode == 404){
        throw jsonDecode(response.body).values.first;
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }

  Future<AIAllergyAttackPredictionModel> fetchUserAllergyAttackById(int userId, int allergyAttackId) async {
    try {
      final response = await http.get(Uri.parse("$usersUrl$userId/allergy-attacks/$allergyAttackId"));

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonData = json.decode(data);
        return AIAllergyAttackPredictionModel.fromJson(jsonData);
      } else if(response.statusCode == 404){
        throw jsonDecode(response.body).values.first;
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }

  Future<AIAllergyAttackPredictionModel> createUserAllergyAttack(AIAllergyAttackPredictionModel allergyAttack) async {
    try {
      final url = "$usersUrl${allergyAttack.user.id}/allergy-attacks";
      
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          // "Authorization": "Bearer $token"
        },
        body: jsonEncode(allergyAttack.toJson()),
      );

      if (response.statusCode == 201) {
        String data = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(data);
        return AIAllergyAttackPredictionModel.fromJson(jsonData);
      } else if(response.statusCode == 400){
        print(jsonDecode(response.body));
        throw jsonDecode(response.body).values.first;
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }

  Future<AIAllergyAttackPredictionModel> updateUserAllergyAttack(AIAllergyAttackPredictionModel allergyAttack) async {
    try {
      final url = "$usersUrl${allergyAttack.user.id}/allergy-attacks/${allergyAttack.id}";
      
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          // "Authorization": "Bearer $token"
        },
        body: jsonEncode(allergyAttack.toJson()),
      );

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(data);
        return AIAllergyAttackPredictionModel.fromJson(jsonData);
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

  Future<bool> deleteUserAllergyAttack(int userId, int allergyAttackId) async {
    try {
      final url = "$usersUrl$userId/allergy-attacks/$allergyAttackId";
      
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          // "Authorization": "Bearer $token"
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

  // Travel Functions
  Future<List<TravelModel>> fetchUserTravels(int userId) async {
    try {
      final response = await http.get(Uri.parse("$usersUrl$userId/travels"));

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        print(data);
        return travelsFromJson(data);
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

// TODO: her bir model için güncellenebilecek featurelar final'dan çıkarılsın