import 'package:allergeo/config/constants.dart';
import 'package:allergeo/models/allergies/allergen_model.dart';
import 'package:allergeo/models/allergies/allergen_region_model.dart';
import 'package:allergeo/services/users/user_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllergenService {
  final String allergensUrl = "${AppConstants.allergiesUrl}allergens/";
  final String allergenTypesUrl = "${AppConstants.allergiesUrl}allergen-types/";
  final String commonRegionsUrl = "${AppConstants.allergiesUrl}common-regions/";
  UserService userService = UserService();

  Future<List<AllergenModel>> fetchAllergens() async {
    try {
      String token = await userService.getUserAccessToken();
      final response = await http.get(
        Uri.parse(allergensUrl.substring(0, allergensUrl.length - 1)),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        return allergensFromJson(data);
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }

  Future<AllergenModel> fetchAllergenById(int allergenId) async {
    try {
      String token = await userService.getUserAccessToken();
      final response = await http.get(
        Uri.parse("$allergensUrl$allergenId"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print("$allergensUrl$allergenId");
      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonData = json.decode(data);
        return AllergenModel.fromJson(jsonData);
      } else if(response.statusCode == 404){
        throw jsonDecode(response.body).values.first;
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }

  Future<List<AllergenRegionModel>> fetchAllergenRegionsByAllergenId(int allergenId) async {
    try {
      final response = await http.get(Uri.parse("$allergensUrl$allergenId/regions"));
      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        return allergenRegionsFromJson(data);
      } else if(response.statusCode == 404){
        throw jsonDecode(response.body).values.first;
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }
  
  Future<List<AllergenModel>> fetchAllergensByAllergenTypeId(int allergenTypeId) async {
    try {
      final response = await http.get(Uri.parse("$allergenTypesUrl$allergenTypeId/allergens"));

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        return allergensFromJson(data);
      } else if(response.statusCode == 404){
        throw jsonDecode(response.body).values.first;
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }

  Future<List<AllergenModel>> fetchAllergensByCommonRegionId(int commonRegionId) async {
    try {
      final response = await http.get(Uri.parse("$commonRegionsUrl$commonRegionId/allergens"));

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        return allergensFromJson(data);
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