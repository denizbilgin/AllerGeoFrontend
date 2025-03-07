import 'dart:convert';
import 'package:allergeo/models/allergies/allergen_model.dart';
import 'package:allergeo/models/places/district_model.dart';
import 'package:allergeo/models/places/abstract/vegetation_model.dart';

class DistrictVegetationModel extends VegetationModel {
  final DistrictModel district;

  DistrictVegetationModel({
    required super.id,
    required super.gbifNumber,
    required super.lastUpdateDate,
    required super.creationDate,
    required super.allergen,
    required this.district,
  });

  factory DistrictVegetationModel.fromJson(Map<String, dynamic> json) {
    return DistrictVegetationModel(
      id: json['id'],
      gbifNumber: json["gbif_number"],
      lastUpdateDate: DateTime.parse(json["last_update_date"]).toLocal(),
      creationDate: DateTime.parse(json["creation_date"]).toLocal(),
      allergen: AllergenModel.fromJson(json['allergen']),
      district: DistrictModel.fromJson(json['district']),
    );
  }

  @override
  String toString() {
    return "${super.toString()} - ${district.name}";
  }
}

List<DistrictVegetationModel> districtVegetationsFromJson(String str) {
  final jsonData = json.decode(str);
  return List<DistrictVegetationModel>.from(jsonData.map((x) => DistrictVegetationModel.fromJson(x)));
}