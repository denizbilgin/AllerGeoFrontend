import 'dart:convert';
import 'package:allergeo/models/places/district_model.dart';
import 'package:allergeo/models/places/district_vegetation_model.dart';
import 'package:allergeo/services/users/user_service.dart';
import 'package:http/http.dart' as http;
import '../../config/constants.dart';

class DistrictService {
  final String districtsUrl = "${AppConstants.placesUrl}districts/";
  final UserService userService = UserService();

  Future<List<DistrictModel>> fetchDistricts() async {
    try {
      String token = await userService.getUserAccessToken();
      final response = await http.get(
        Uri.parse(districtsUrl.substring(0, districtsUrl.length - 1)),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        return districtsFromJson(data);
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }

  Future<DistrictModel> fetchDistrictById(int districtId) async {
    try {
      final response = await http.get(Uri.parse("$districtsUrl$districtId"));

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonData = json.decode(data);
        return DistrictModel.fromJson(jsonData);
      } else if(response.statusCode == 404){
        throw jsonDecode(response.body).values.first;
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }

  Future<DistrictModel> fetchDistrictByName(String districtName) async {
    try {
      final response = await http.get(Uri.parse("$districtsUrl$districtName"));

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonData = json.decode(data);
        return DistrictModel.fromJson(jsonData);
      } else if(response.statusCode == 404){
        throw jsonDecode(response.body).values.first;
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }

  Future<List<DistrictVegetationModel>> fetchDistrictVegetation(int districtId) async {
    try {
      final response = await http.get(Uri.parse("$districtsUrl$districtId/vegetation"));

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        return districtVegetationsFromJson(data);
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