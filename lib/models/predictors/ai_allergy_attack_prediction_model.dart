import 'dart:convert';
import 'package:allergeo/models/places/district_model.dart';
import 'package:allergeo/models/predictors/ai_model_model.dart';
import 'package:allergeo/models/users/travel_model.dart';
import 'package:allergeo/models/users/user_model.dart';
import 'package:latlong2/latlong.dart';

class AIAllergyAttackPredictionModel {
  final int? id;
  UserModel user;
  DateTime date;
  DistrictModel district;
  double? aiPrediction;
  bool? hadAllergyAttack;
  final AIModelModel? model;
  TravelModel? travel;
  final LatLng? selectedLocation;

  AIAllergyAttackPredictionModel({
    this.id,
    required this.user,
    required this.date,
    required this.district,
    this.aiPrediction,
    this.hadAllergyAttack,
    this.model,
    this.travel,
    this.selectedLocation
  });

  // Factory constructor
  factory AIAllergyAttackPredictionModel.fromJson(Map<String, dynamic> json) {
    return AIAllergyAttackPredictionModel(
      id: json['id'],
      user: UserModel.fromJson(json['user']),
      date: DateTime.parse(json['date']).toLocal(),
      district: DistrictModel.fromJson(json['district']),
      aiPrediction: (json['ai_prediction'] as num?)?.toDouble(),
      hadAllergyAttack: json['had_allergy_attack'],
      model: json['model'] != null ? AIModelModel.fromJson(json['model']) : null,
      travel: json['travel'] != null ? TravelModel.fromJson(json["travel"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": user.id,
      "date": date.toIso8601String(),
      "district_id": district.id,
      "had_allergy_attack": hadAllergyAttack,
      "travel_id": travel?.id,
    };
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

List<Map<String, dynamic>> toJsonMultiple(List<AIAllergyAttackPredictionModel> multipleWaypoints) {
    return multipleWaypoints.map((prediction) => prediction.toJson()).toList();
}
