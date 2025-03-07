import 'package:allergeo/config/constants.dart';
import 'package:allergeo/models/predictors/ai_allergy_attack_prediction_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllergyAttackService {
  final String usersUrl = AppConstants.usersUrl;

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
}