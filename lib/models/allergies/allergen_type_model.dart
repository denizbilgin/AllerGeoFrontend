import 'dart:convert';

class AllergenTypeModel {
  final int id;
  final String name;

  AllergenTypeModel({
    required this.id,
    required this.name
  });

  // Factory constructor
  factory AllergenTypeModel.fromJson(Map<String, dynamic> json) {
    return AllergenTypeModel(
      id: json['id'],
      name: json["name"]
    );
  }

  @override
  String toString() {
    return name;
  }
}

List<AllergenTypeModel> allergenTypesFromJson(String str) {
  final jsonData = json.decode(str);
  return List<AllergenTypeModel>.from(jsonData.map((x) => AllergenTypeModel.fromJson(x)));
}
