import 'dart:convert';
import 'package:allergeo/models/allergies/allergen_model.dart';
import 'package:allergeo/models/users/user_model.dart';

class UserAllergyModel {
  final int? id;
  UserModel? user;
  final AllergenModel allergen;
  final DateTime? creationDate;
  final int importanceLevel;

  UserAllergyModel({
    this.id,
    this.user,
    required this.allergen,
    this.creationDate,
    required this.importanceLevel
  });

  // Factory constructor
  factory UserAllergyModel.fromJson(Map<String, dynamic> json) {
    return UserAllergyModel(
      id: json['id'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      allergen: AllergenModel.fromJson(json['allergen']),
      creationDate: DateTime.parse(json['creation_date']),
      importanceLevel: json["importance_level"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "allergen_id": allergen.id,
      "importance_level": importanceLevel
    };
  }

  @override
  String toString() {
    return "${user?.firstName} ${user?.lastName} - ${allergen.name} - $importanceLevel";
  }
}

List<UserAllergyModel> userAllergiesFromJson(String str) {
  final jsonData = json.decode(str);
  return List<UserAllergyModel>.from(jsonData.map((x) => UserAllergyModel.fromJson(x)));
}
