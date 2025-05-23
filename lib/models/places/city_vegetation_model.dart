import 'dart:convert';
import 'package:allergeo/models/allergies/allergen_model.dart';
import 'package:allergeo/models/places/city_model.dart';
import 'package:allergeo/models/places/abstract/vegetation_model.dart';

class CityVegetationModel extends VegetationModel {
  final CityModel city;

  CityVegetationModel({
    required super.id,
    required super.gbifNumber,
    required super.lastUpdateDate,
    required super.creationDate,
    required super.allergen,
    required this.city,
  });

  factory CityVegetationModel.fromJson(Map<String, dynamic> json) {
    return CityVegetationModel(
      id: json['id'],
      gbifNumber: json["gbif_number"],
      lastUpdateDate: DateTime.parse(json["last_update_date"]).toLocal(),
      creationDate: DateTime.parse(json["creation_date"]).toLocal(),
      allergen: AllergenModel.fromJson(json['allergen']),
      city: CityModel.fromJson(json['city']),
    );
  }

  @override
  String toString() {
    return "${super.toString()} - ${city.name}";
  }
}

List<CityVegetationModel> cityVegetationsFromJson(String str) {
  final jsonData = json.decode(str);
  return List<CityVegetationModel>.from(jsonData.map((x) => CityVegetationModel.fromJson(x)));
}