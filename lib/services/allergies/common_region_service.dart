import 'package:allergeo/config/constants.dart';
import 'package:allergeo/models/allergies/common_region_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommonRegionsService {
  final String commonRegionsUrl = "${AppConstants.allergiesUrl}common-regions/";

  Future<List<CommonRegionModel>> fetchCommonRegions() async {
    try {
      final response = await http.get(Uri.parse(commonRegionsUrl.substring(0, commonRegionsUrl.length - 1)));

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        return commonRegionsFromJson(data);
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }

  Future<CommonRegionModel> fetchCommonRegionById(int commonRegionId) async {
    try {
      final response = await http.get(Uri.parse("$commonRegionsUrl$commonRegionId"));

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonData = json.decode(data);
        return CommonRegionModel.fromJson(jsonData);
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