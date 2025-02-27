import 'dart:convert';

import 'package:allergeo/models/places/city_model.dart';
import 'package:allergeo/models/places/abstract/place_model.dart';

class DistrictModel extends PlaceModel {
  final CityModel city;

  DistrictModel({
    required this.city,
    required super.id,
    required super.name,
    required super.latitude,
    required super.longitude,
    required super.northeastLatitude,
    required super.northeastLongitude,
    required super.southwestLatitude,
    required super.southwestLongitude,
  });

  // Factory constructor
  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      northeastLatitude: json['northeast_latitude'],
      northeastLongitude: json['northeast_longitude'],
      southwestLatitude: json['southwest_latitude'],
      southwestLongitude: json['southwest_longitude'],
      city: CityModel.fromJson(json['city']),
    );
  }
}

List<DistrictModel> districtsFromJson(String str) {
  final jsonData = json.decode(str);
  return List<DistrictModel>.from(jsonData.map((x) => DistrictModel.fromJson(x)));
}