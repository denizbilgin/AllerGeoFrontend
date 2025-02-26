import 'dart:convert';
import 'package:allergeo/models/places/district_model.dart';
import 'package:http/http.dart' as http;
import '../config/constants.dart';

class DistrictService {
  Future<List<DistrictModel>> fetchDistricts() async {
    try {
      final response = await http.get(Uri.parse("${AppConstants.placesUrl}districts"));

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        return districtsFromJson(data);
      } else {
        throw "İlçeler yüklenemedi. Hata kodu: ${response.statusCode}";
      }
    } catch (e) {
      throw "Bir hata oluştu $e";
    }
  }
}