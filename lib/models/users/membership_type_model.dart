import 'dart:convert';

class MembershipTypeModel {
  final int id;
  final String name;
  final int price;

  MembershipTypeModel({
    required this.id,
    required this.name,
    required this.price
  });

  // Factory constructor
  factory MembershipTypeModel.fromJson(Map<String, dynamic> json) {
    return MembershipTypeModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
    );
  }

  @override
  String toString() {
    return name;
  }
}

List<MembershipTypeModel> membershipTypesFromJson(String str) {
  final jsonData = json.decode(str);
  return List<MembershipTypeModel>.from(jsonData.map((x) => MembershipTypeModel.fromJson(x)));
}
