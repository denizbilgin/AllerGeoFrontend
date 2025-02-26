import 'dart:convert';

import 'package:allergeo/models/allergies/allergen_type_model.dart';

class AllergenModel {
  final int id;
  final String name;
  final String speciesName;
  final String family;
  final String familyLink;
  final List<String> images;
  final String link;
  final AllergenTypeModel allergenType;

  AllergenModel({
    required this.id,
    required this.name,
    required this.speciesName,
    required this.family,
    required this.familyLink,
    required this.images,
    required this.link,
    required this.allergenType,
  });

  // Factory constructor
  factory AllergenModel.fromJson(Map<String, dynamic> json) {
    return AllergenModel(
      id: json['id'],
      name: json['name'],
      speciesName: json['species_name'],
      family: json['family'],
      familyLink: json['family_link'],
      images: json['images'] == null ? [] : json['images'].split(';'),
      link: json['link'],
      allergenType: AllergenTypeModel.fromJson(json['allergen_type']),
    );
  }

  @override
  String toString() {
    return "$name - $speciesName - ${allergenType.name}";
  }
}

List<AllergenModel> allergensFromJson(String str) {
  final jsonData = json.decode(str);
  return List<AllergenModel>.from(jsonData.map((x) => AllergenModel.fromJson(x)));
}
