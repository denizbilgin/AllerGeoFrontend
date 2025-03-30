import 'package:allergeo/config/colors.dart';
import 'package:allergeo/models/places/city_model.dart';
import 'package:allergeo/services/places/city_service.dart';
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
  final CityService cityService = CityService();

  LatLng _currentCenter = LatLng(41.00527, 28.97696);
  List<LatLng> _waypoints = [];
  List<LatLng> _routePoints = [];

  void _searchLocation() async {
    try {
      List<Location> locations = await locationFromAddress(_searchController.text);
      if (locations.isNotEmpty) {
        final newLocation = locations.first;
        setState(() {
          _currentCenter = LatLng(newLocation.latitude, newLocation.longitude);
          _mapController.move(_currentCenter, 12);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Konum bulunamadı: $e')),
      );
    }
  }

  void _addWaypoint(LatLng point) {
    setState(() {
      _waypoints.add(point);
      print(_waypoints);
    });
    if (_waypoints.length > 1) {
      _getRoute();
    }
  }

  Future<void> _getRoute() async {
    if (_waypoints.length < 2) return;

    final waypointsString = _waypoints.map((wp) => "${wp.longitude},${wp.latitude}").join(";");
    final url = "https://router.project-osrm.org/route/v1/driving/$waypointsString?overview=full&geometries=geojson";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> coordinates = data['routes'][0]['geometry']['coordinates'];
      setState(() {
        _routePoints = coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double mapHeight = screenWidth;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seyahat Planlayıcı', style: TextStyle(color: Colors.white),),
        backgroundColor: AppColors.ALLERGEO_GREEN,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Konum ara...',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: _searchLocation,
                      ),
                    ),
                    onSubmitted: (value) => _searchLocation(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: screenWidth,
            height: mapHeight,
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
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                  markers: _waypoints.map((point) => Marker(
                    width: 40.0,
                    height: 40.0,
                    point: point,
                    builder: (ctx) => const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}