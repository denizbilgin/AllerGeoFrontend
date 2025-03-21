import 'dart:convert';
import 'package:allergeo/models/places/district_model.dart';

class UserModel {
  final int id;
  final DateTime dateJoined;
  DistrictModel residenceDistrict;
  DateTime dateOfBirth;
  String phoneNumber;
  final String username;
  String firstName;
  String lastName;
  String email;
  String password;
  final DateTime? lastLogin;
  final bool isMale;
  final bool isSuperUser;
  final bool isStaff;
  bool isActive;
  List<int> groups;
  List<String> userPermissions;
  int age;

  UserModel({
    required this.id,
    required this.dateJoined,
    required this.residenceDistrict,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.lastLogin,
    required this.isSuperUser,
    required this.isStaff,
    required this.isActive,
    required this.groups,
    required this.userPermissions,
    required this.isMale,
    required this.age
  });

  // Factory constructor
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      residenceDistrict: DistrictModel.fromJson(json['residence_district']),
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      password: json['password'],
      lastLogin: json['last_login'] != null ? DateTime.parse(json['last_login']).toLocal() : null,
      isSuperUser: json['is_superuser'] as bool,
      isStaff: json['is_staff'] as bool,
      isActive: json['is_active'] as bool,
      dateJoined: DateTime.parse(json['date_joined']).toLocal(),
      dateOfBirth: DateTime.parse(json['date_of_birth']).toLocal(),
      groups: List<int>.from(json['groups'] ?? []),
      userPermissions: List<String>.from(json['user_permissions'] ?? []),
      isMale: json['is_male'] as bool,
      age: json['age'] as int
    );
  }
  /*
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'residence_district_id': residenceDistrict.id,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'password': password,
      'last_login': lastLogin.toIso8601String(),
      'is_superuser': isSuperUser,
      'is_staff': isStaff,
      'is_active': isActive,
      'photo': photo,
      'date_joined': dateJoined.toIso8601String(),
      'date_of_birth': dateOfBirth.toIso8601String().split('T')[0],
      'groups': groups,
      'user_permissions': userPermissions,
    };
  }
  */

  @override
  String toString() {
    return "$firstName $lastName - $lastLogin";
  }
}

List<UserModel> usersFromJson(String str) {
  final jsonData = json.decode(str);
  return List<UserModel>.from(jsonData.map((x) => UserModel.fromJson(x)));
}
