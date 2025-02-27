import 'dart:convert';

class AIModelModel {
  final int id;
  final String name;
  final String? filePath;
  final String? description;
  final DateTime creationDate;
  final DateTime lastUpdateDate;
  final int version;

  AIModelModel({
    required this.id,
    required this.name,
    required this.filePath,
    required this.description,
    required this.creationDate,
    required this.lastUpdateDate,
    required this.version,
  });

  // Factory constructor
  factory AIModelModel.fromJson(Map<String, dynamic> json) {
    return AIModelModel(
      id: json['id'],
      name: json['name'],
      filePath: json['file_path'],
      description: json['description'],
      creationDate: DateTime.parse(json['creation_date']),
      lastUpdateDate: DateTime.parse(json['last_update_date']),
      version: json['version'],
    );
  }

  @override
  String toString() {
    return name;
  }
}

List<AIModelModel> aiModelsFromJson(String str) {
  final jsonData = json.decode(str);
  return List<AIModelModel>.from(jsonData.map((x) => AIModelModel.fromJson(x)));
}
