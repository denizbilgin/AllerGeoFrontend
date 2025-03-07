import 'dart:convert';
import 'package:allergeo/models/users/membership_type_model.dart';
import 'package:allergeo/models/users/user_model.dart';

class MembershipModel {
  final int id;
  final UserModel user;
  final MembershipTypeModel membershipType;
  final DateTime startDate;
  final DateTime endDate;

  MembershipModel({
    required this.id,
    required this.user,
    required this.membershipType,
    required this.startDate,
    required this.endDate
  });

  // Factory constructor
  factory MembershipModel.fromJson(Map<String, dynamic> json) {
    return MembershipModel(
      id: json['id'],
      user: UserModel.fromJson(json['user']),
      membershipType: MembershipTypeModel.fromJson(json['membership_type']),
      startDate: DateTime.parse(json['start_date']).toLocal(),
      endDate: DateTime.parse(json['end_date']).toLocal()
    );
  }

  @override
  String toString() {
    return "${user.firstName} ${user.lastName} - ${membershipType.name}";
  }
}

List<MembershipModel> membershipsFromJson(String str) {
  final jsonData = json.decode(str);
  return List<MembershipModel>.from(jsonData.map((x) => MembershipModel.fromJson(x)));
}
