import 'dart:convert';
import 'package:allergeo/models/places/city_model.dart';
import 'package:allergeo/models/places/city_vegetation_model.dart';
import 'package:http/http.dart' as http;
import '../../config/constants.dart';

class CityService {
  final String citiesUrl = "${AppConstants.placesUrl}cities/";

  Future<List<CityModel>> fetchCities() async {
    try {
      final response = await http.get(Uri.parse(citiesUrl));

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        return citiesFromJson(data);
      } else {
        throw "Şehirler yüklenemedi. Hata kodu: ${response.statusCode}";
      }
    } catch (e) {
      throw "Bir hata oluştu $e";
    }
  }

  Future<CityModel> fetchCityById(int cityId) async {
    try {
      final response = await http.get(Uri.parse("$citiesUrl$cityId"));

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonData = json.decode(data);
        return CityModel.fromJson(jsonData);
      } else {
        throw "Şehir yüklenemedi. Hata kodu: ${response.statusCode}";
      }
    } catch (e) {
      throw "Bir hata oluştu $e";
    }
  }

  Future<CityModel> fetchCityByName(String cityName) async {
    try {
      final response = await http.get(Uri.parse("$citiesUrl$cityName"));

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonData = json.decode(data);
        return CityModel.fromJson(jsonData);
      } else {
        throw "Şehir yüklenemedi. Hata kodu: ${response.statusCode}";
      }
    } catch (e) {
      throw "Bir hata oluştu $e";
    }
  }

  Future<List<CityVegetationModel>> fetchCityVegetation(int cityId) async {
    try {
      final response = await http.get(Uri.parse("$citiesUrl$cityId/vegetation"));

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        return cityVegetationsFromJson(data);
      } else {
        throw "Şehir bitki örtüsü verisi yüklenemedi. Hata kodu: ${response.statusCode}";
      }
    } catch (e) {
      throw "Bir hata oluştu $e";
    }
  }
}