import 'package:allergeo/config/constants.dart';
import 'package:allergeo/models/allergies/allergen_type_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllergenTypeService {
  final String allergenTypesUrl = "${AppConstants.allergiesUrl}allergen-types/";

  Future<List<AllergenTypeModel>> fetchAllergenTypes() async {
    try {
      final response = await http.get(Uri.parse(allergenTypesUrl.substring(0, allergenTypesUrl.length - 1)));

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        return allergenTypesFromJson(data);
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }

  Future<AllergenTypeModel> fetchAllergenTypeById(int allergenTypeId) async {
    try {
      final response = await http.get(Uri.parse("$allergenTypesUrl$allergenTypeId"));

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonData = json.decode(data);
        return AllergenTypeModel.fromJson(jsonData);
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