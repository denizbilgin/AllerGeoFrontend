import 'dart:convert';
import 'package:allergeo/models/places/place_model.dart';

typedef CityModel = PlaceModel;

List<CityModel> citiesFromJson(String str) {
  final jsonData = json.decode(str);
  return List<CityModel>.from(jsonData.map((x) => PlaceModel.fromJson(x)));
}

