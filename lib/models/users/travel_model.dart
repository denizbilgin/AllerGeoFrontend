import 'dart:convert';

import 'package:allergeo/models/users/user_model.dart';

class TravelModel {
  final int id;
  final UserModel user;
  final DateTime creationDate;
  final DateTime startDate;
  final DateTime? returnDate;

  TravelModel({
    required this.id,
    required this.user,
    required this.creationDate,
    required this.startDate,
    required this.returnDate
  });

  // Factory constructor
  factory TravelModel.fromJson(Map<String, dynamic> json) {
    return TravelModel(
      id: json['id'],
      user: UserModel.fromJson(json['user']),
      creationDate: DateTime.parse(json['creation_date']),
      startDate: DateTime.parse(json['start_date']),
      returnDate: DateTime.parse(json['return_date']),
    );
  }

  @override
  String toString() {
    return "${user.firstName} ${user.lastName} - $startDate";
  }
}

List<TravelModel> travelsFromJson(String str) {
  final jsonData = json.decode(str);
  return List<TravelModel>.from(jsonData.map((x) => TravelModel.fromJson(x)));
}
