import 'dart:convert';
import 'package:allergeo/models/places/district_model.dart';
import 'package:allergeo/models/predictors/ai_model_model.dart';
import 'package:allergeo/models/users/travel_model.dart';
import 'package:allergeo/models/users/user_model.dart';

class AIAllergyAttackPredictionModel {
  final int id;
  final UserModel user;
  final DateTime date;
  final DistrictModel district;
  final double? aiPrediction;
  final bool? hadAllergyAttack;
  final AIModelModel? model;
  final TravelModel? travel;

  AIAllergyAttackPredictionModel({
    required this.id,
    required this.user,
    required this.date,
    required this.district,
    required this.aiPrediction,
    required this.hadAllergyAttack,
    required this.model,
    required this.travel
  });

  // Factory constructor
  factory AIAllergyAttackPredictionModel.fromJson(Map<String, dynamic> json) {
    return AIAllergyAttackPredictionModel(
      id: json['id'],
      user: UserModel.fromJson(json['user']),
      date: DateTime.parse(json['date']),
      district: DistrictModel.fromJson(json['district']),
      aiPrediction: json['ai_prediction'],
      hadAllergyAttack: json['had_allergy_attack'],
      model: AIModelModel.fromJson(json['model']),
      travel: TravelModel.fromJson(json["travel"])
    );
  }

  @override
  String toString() {
    return "${user.firstName} ${user.lastName} - ${district.name}/${district.city.name} - $date";
  }
}

List<AIAllergyAttackPredictionModel> aiAllergyAttackPredictionsFromJson(String str) {
  final jsonData = json.decode(str);
  return List<AIAllergyAttackPredictionModel>.from(jsonData.map((x) => AIAllergyAttackPredictionModel.fromJson(x)));
}
