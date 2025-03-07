import 'dart:convert';

import 'package:allergeo/models/users/user_model.dart';

class TravelModel {
  final int? id;
  final UserModel user;
  final DateTime? creationDate;
  DateTime startDate;
  DateTime? returnDate;

  TravelModel({
    this.id,
    required this.user,
    this.creationDate,
    required this.startDate,
    required this.returnDate
  });

  // Factory constructor
  factory TravelModel.fromJson(Map<String, dynamic> json) {
    return TravelModel(
      id: json['id'],
      user: UserModel.fromJson(json['user']),
      creationDate: DateTime.parse(json['creation_date']).toLocal(),
      startDate: DateTime.parse(json['start_date']).toLocal(),
      returnDate: DateTime.parse(json['return_date']).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": user.id,
      "start_date": startDate.toIso8601String(),
      "return_date": returnDate?.toIso8601String()
    };
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
