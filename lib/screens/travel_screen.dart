import 'package:allergeo/config/colors.dart';
import 'package:allergeo/models/places/district_model.dart';
import 'package:allergeo/models/predictors/ai_allergy_attack_prediction_model.dart';
import 'package:allergeo/models/users/travel_model.dart';
import 'package:allergeo/services/places/district_service.dart';
import 'package:allergeo/services/users/travel_service.dart';
import 'package:allergeo/services/users/user_service.dart';
import 'package:allergeo/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TravelScreen extends StatefulWidget {
  const TravelScreen({Key? key}) : super(key: key);

  @override
  _TravelScreenState createState() => _TravelScreenState();
}

class _TravelScreenState extends State<TravelScreen> {
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();
  final DistrictService districtService = DistrictService();
  final UserService userService = UserService();
  TravelService travelService = TravelService();

  LatLng _currentCenter = LatLng(41.00527, 28.97696);
  List<AIAllergyAttackPredictionModel> _waypoints = [];
  List<LatLng> _routePoints = [];

  void _searchLocation() async {
    try {
      List<Location> locations = await locationFromAddress(
        _searchController.text,
      );
      if (locations.isNotEmpty) {
        final newLocation = locations.first;
        setState(() {
          _currentCenter = LatLng(newLocation.latitude, newLocation.longitude);
          _mapController.move(_currentCenter, 11);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Konum bulunamadı: $e')));
    }
  }

  void _addWaypoint(LatLng point) async {
    try {
      DistrictModel district = await districtService.fetchDistrictByCoordinates(
        point.latitude,
        point.longitude,
      );

      DateTime? selectedDate;
      await Future.delayed(Duration.zero, () async {
        selectedDate = await _selectDate(context);
      });
      if (selectedDate == null) return;

      var token = await userService.getUserAccessToken();
      var userId = await userService.getUserIdFromToken(token);
      var user = await userService.fetchUserById(userId);

      AIAllergyAttackPredictionModel waypoint = AIAllergyAttackPredictionModel(
        user: user,
        date: selectedDate!,
        district: district,
        selectedLocation: point,
      );
      setState(() {
        _waypoints.add(waypoint);
      });

      if (_waypoints.length > 1) {
        _getRoute();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lütfen Türkiye'de Bir Yer Seçin. Hata: $e")),
      );
      return;
    }
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.ALLERGEO_GREEN,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  Future<void> _getRoute() async {
    if (_waypoints.length < 2) return;

    final waypointsString = _waypoints
        .map(
          (wp) =>
              "${wp.selectedLocation!.longitude},${wp.selectedLocation!.latitude}",
        )
        .join(";");
    final url =
        "https://router.project-osrm.org/route/v1/driving/$waypointsString?overview=full&geometries=geojson";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> coordinates =
          data['routes'][0]['geometry']['coordinates'];
      setState(() {
        _routePoints =
            coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
      });
    }
  }

  void _createTravel() async {
    try {
      var token = await userService.getUserAccessToken();
      var userId = await userService.getUserIdFromToken(token);
      var user = await userService.fetchUserById(userId);

      if (_waypoints.length == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lütfen en az bir durak noktası ekleyin.")),
        );
        return;
      }

      TravelModel travel = TravelModel(
        user: user,
        startDate: _waypoints[0].date,
        returnDate: _waypoints.length > 1 ? _waypoints.last.date : _waypoints.first.date,
      );

      TravelModel travelReturned = await travelService.createUserTravel(travel);
      for (AIAllergyAttackPredictionModel waypoint in _waypoints) {
        waypoint.travel = travel;
      }
      await travelService.createUserTravelWaypoints(_waypoints, travelReturned.id!);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Seyahat Oluşturuldu")));
      return;
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Bir hata oluştu: $e")));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 0.95;
    double mapHeight = screenWidth;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Strings.CREATE_TRAVEL,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.ALLERGEO_GREEN,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Text(
              Strings.CREATE_TRAVEL_INFO,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      label: const Text('Konum Ara'),
                      prefixIcon: const Icon(Icons.search),
                      labelStyle: const TextStyle(color: Colors.black),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.ALLERGEO_GREEN,
                          width: 2,
                        ),
                      ),
                    ),
                    onFieldSubmitted: (value) => _searchLocation(),
                    cursorColor: AppColors.ALLERGEO_GREEN,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: screenWidth,
            height: mapHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: _currentCenter,
                  zoom: 13.0,
                  onTap: (tapPosition, point) async {
                    _addWaypoint(point);
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _routePoints,
                        strokeWidth: 4.0,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers:
                        _waypoints.map((waypoint) {
                          return Marker(
                            width: 40.0,
                            height: 40.0,
                            point: waypoint.selectedLocation!,
                            builder:
                                (ctx) => const Icon(
                                  Icons.location_pin,
                                  color: Colors.red,
                                  size: 40.0,
                                ),
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                itemCount: _waypoints.length,
                itemBuilder: (context, index) {
                  AIAllergyAttackPredictionModel waypoint = _waypoints[index];
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 15,
                    ),
                    leading: Icon(
                      Icons.location_on,
                      color: AppColors.ALLERGEO_GREEN,
                      size: 30,
                    ),
                    title: Text(
                      "${index + 1}. Durak: ${waypoint.district.name.capitalize()}/${waypoint.district.city.name.capitalize()}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Tarih: ${waypoint.date.day}/${waypoint.date.month}/${waypoint.date.year}",
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.ALLERGEO_GREEN.shade100,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: AppColors.ALLERGEO_GREEN,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        'AI Tahmini',
                        style: TextStyle(
                          color: AppColors.ALLERGEO_GREEN,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  _createTravel();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.ALLERGEO_GREEN,
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  Strings.CREATE_TRAVEL,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
