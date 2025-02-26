import 'dart:convert';
import 'package:allergeo/models/places/city_model.dart';
import 'package:http/http.dart' as http;
import '../config/constants.dart';

class CityService {
  Future<List<CityModel>> fetchCities() async {
    try {
      final response = await http.get(Uri.parse("${AppConstants.placesUrl}cities"));

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
}