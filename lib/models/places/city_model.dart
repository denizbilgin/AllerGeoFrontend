import 'dart:convert';
import 'package:allergeo/models/places/abstract/place_model.dart';

typedef CityModel = PlaceModel;

List<CityModel> citiesFromJson(String str) {
  final jsonData = json.decode(str);
  return List<CityModel>.from(jsonData.map((x) => CityModel.fromJson(x)));
}

