import 'dart:convert';
import 'package:allergeo/models/allergies/allergen_model.dart';
import 'package:allergeo/models/allergies/common_region_model.dart';

class AllergenRegionModel {
  final int id;
  final AllergenModel allergen;
  final CommonRegionModel commonRegion;

  AllergenRegionModel({
    required this.id,
    required this.allergen,
    required this.commonRegion
  });

  // Factory constructor
  factory AllergenRegionModel.fromJson(Map<String, dynamic> json) {
    return AllergenRegionModel(
      id: json['id'],
      allergen: AllergenModel.fromJson(json['allergen']),
      commonRegion: CommonRegionModel.fromJson(json['common_region'])
    );
  }

  @override
  String toString() {
    return "${allergen.name} - ${commonRegion.name}";
  }
}

List<AllergenRegionModel> allergenRegionsFromJson(String str) {
  final jsonData = json.decode(str);
  return List<AllergenRegionModel>.from(jsonData.map((x) => AllergenRegionModel.fromJson(x)));
}
