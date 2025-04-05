import 'dart:convert';
import 'package:allergeo/models/places/city_model.dart';
import 'package:allergeo/models/places/city_vegetation_model.dart';
import 'package:allergeo/services/users/user_service.dart';
import 'package:http/http.dart' as http;
import '../../config/constants.dart';

class CityService {
  final String citiesUrl = "${AppConstants.placesUrl}cities/";
  final UserService userService = UserService();

  Future<List<CityModel>> fetchCities() async {
    try {
      final response = await http.get(Uri.parse(citiesUrl.substring(0, citiesUrl.length - 1)));

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        return citiesFromJson(data);
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }

  Future<CityModel> fetchCityById(int cityId) async {
    try {
      final response = await http.get(Uri.parse("$citiesUrl$cityId"));

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonData = json.decode(data);
        return CityModel.fromJson(jsonData);
      } else if(response.statusCode == 404){
        throw jsonDecode(response.body).values.first;
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }

  Future<CityModel> fetchCityByName(String cityName) async {
    try {
      String token = await userService.getUserAccessToken();
      final response = await http.get(
        Uri.parse("$citiesUrl$cityName"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonData = json.decode(data);
        return CityModel.fromJson(jsonData);
      } else if(response.statusCode == 404){
        throw jsonDecode(response.body).values.first;
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }

  Future<List<CityVegetationModel>> fetchCityVegetation(int cityId) async {
    try {
      final response = await http.get(Uri.parse("$citiesUrl$cityId/vegetation"));

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        return cityVegetationsFromJson(data);
      } else if(response.statusCode == 404){
        throw jsonDecode(response.body).values.first;
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }

  Future<CityModel> fetchCityByCoordinates(double latitude, double longitude) async {
    try {
      String token = await userService.getUserAccessToken();
      final Uri url = Uri.parse("${citiesUrl}retrieve-by-coordinates?latitude=$latitude&longitude=$longitude");
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonData = json.decode(data);
        return CityModel.fromJson(jsonData);
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