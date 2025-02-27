import 'dart:convert';

class CommonRegionModel {
  final int id;
  final String name;
  final String? description;

  CommonRegionModel({
    required this.id,
    required this.name,
    required this.description
  });

  // Factory constructor
  factory CommonRegionModel.fromJson(Map<String, dynamic> json) {
    return CommonRegionModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  @override
  String toString() {
    return name;
  }
}

List<CommonRegionModel> commonRegionsFromJson(String str) {
  final jsonData = json.decode(str);
  return List<CommonRegionModel>.from(jsonData.map((x) => CommonRegionModel.fromJson(x)));
}
