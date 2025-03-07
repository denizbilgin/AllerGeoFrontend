import 'package:allergeo/models/allergies/allergen_model.dart';

class VegetationModel {
  final int id;
  final int gbifNumber;
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  final AllergenModel allergen;

  VegetationModel({
    required this.id,
    required this.gbifNumber,
    required this.lastUpdateDate,
    required this.creationDate,
    required this.allergen,
  });

  // Factory constructor
  factory VegetationModel.fromJson(Map<String, dynamic> json) {
    return VegetationModel(
      id: json['id'],
      gbifNumber: json["gbif_number"],
      lastUpdateDate: DateTime.parse(json["last_update_date"]).toLocal(),
      creationDate: DateTime.parse(json["creation_date"]).toLocal(),
      allergen: AllergenModel.fromJson(json['allergen']),
    );
  }

  @override
  String toString() {
    return "$gbifNumber - ${allergen.name}";
  }
}
