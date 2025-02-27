class PlaceModel {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final double northeastLatitude;
  final double northeastLongitude;
  final double southwestLatitude;
  final double southwestLongitude;

  PlaceModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.northeastLatitude,
    required this.northeastLongitude,
    required this.southwestLatitude,
    required this.southwestLongitude
  });

  // Factory constructor
  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      northeastLatitude: json['northeast_latitude'],
      northeastLongitude: json['northeast_longitude'],
      southwestLatitude: json['southwest_latitude'],
      southwestLongitude: json['southwest_longitude'],
    );
  }

  @override
  String toString() {
    return name;
  }
}