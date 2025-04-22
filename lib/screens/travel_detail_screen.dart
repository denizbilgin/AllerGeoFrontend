import 'dart:convert';

import 'package:allergeo/config/colors.dart';
import 'package:allergeo/models/places/district_model.dart';
import 'package:allergeo/models/predictors/ai_allergy_attack_prediction_model.dart';
import 'package:allergeo/models/users/travel_model.dart';
import 'package:allergeo/screens/login_screen.dart';
import 'package:allergeo/services/places/district_service.dart';
import 'package:allergeo/services/users/travel_service.dart';
import 'package:allergeo/services/users/user_service.dart';
import 'package:allergeo/widgets/add_travel_waypoint_widget.dart';
import 'package:allergeo/widgets/travel_route_map_widget.dart';
import 'package:allergeo/widgets/waypoints_list_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class UserTravelDetailScreen extends StatefulWidget {
  final TravelModel travel;
  final List<AIAllergyAttackPredictionModel> waypoints;
  final Function(TravelModel) onUpdate;

  const UserTravelDetailScreen({
    required this.travel,
    required this.onUpdate,
    required this.waypoints,
  });

  @override
  _UserTravelDetailScreen createState() => _UserTravelDetailScreen();
}

class _UserTravelDetailScreen extends State<UserTravelDetailScreen> {
  List<LatLng> _routePoints = [];

  @override
  void initState() {
    super.initState();
    _getRouteFromWaypoints();
  }

  Future<void> _getRouteFromWaypoints() async {
    if (widget.waypoints.length < 2) {
      _routePoints = [];
      return;
    };

    final waypointsString = widget.waypoints
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

  void _handleUpdate(AIAllergyAttackPredictionModel updatedWaypoint) {
    setState(() {
      int index = widget.waypoints.indexWhere(
        (a) => a.id == updatedWaypoint.id,
      );
      if (index != -1) {
        widget.waypoints[index] = updatedWaypoint;
      }
    });
  }

  Future<int> _getUserId() async {
    try {
      UserService userService = UserService();
      String token = await userService.getUserAccessToken();
      if (token == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        return 0;
      }
      final userId = await userService.getUserIdFromToken(token);
      return userId;
    } catch (e) {
      print('User ID alınırken hata: $e');
      return 0;
    }
  }

  void _deleteWaypoint(AIAllergyAttackPredictionModel waypointToDelete) async {
    try {
      int userId = await _getUserId();
      TravelService travelService = TravelService();
      bool isDeleted = await travelService.deleteUserTravelWaypoint(
        userId,
        widget.travel.id!,
        waypointToDelete.id!,
      );

      if (isDeleted) {
        setState(() {
          widget.waypoints.removeWhere(
            (allergy) => allergy.id == waypointToDelete.id,
          );
        });
        _showSnackBar(context, "Durak başarıyla silindi");
        _getRouteFromWaypoints();
      }
    } catch (e) {
      _showSnackBar(context, "Durak silinemedi: $e");
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(message, style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  void _addWaypoint(TravelModel travel) async {
    try {
      final result = await showDialog<(DateTime, (String, int))>(
        context: context,
        builder:
            (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: AddTravelWaypointScreen(
                travelId: travel.id!,
                initialDate: widget.waypoints.last.date,
                onSave: (selectedDate, selectedDistrictId) async {
                  TravelService travelService = TravelService();
                  DistrictService districtService = DistrictService();
                  UserService userService = UserService();

                  DistrictModel district = await districtService
                      .fetchDistrictById(selectedDistrictId);

                  AIAllergyAttackPredictionModel waypoint =
                      AIAllergyAttackPredictionModel(
                        user: await userService.fetchUserById(
                          await _getUserId(),
                        ),
                        date: selectedDate,
                        district: district,
                        selectedLocation: LatLng(
                          district.latitude,
                          district.longitude,
                        ),
                      );

                  List<AIAllergyAttackPredictionModel> addedWaypoint = await travelService.createUserTravelWaypoints([
                    waypoint,
                  ], widget.travel.id!);
                  waypoint = addedWaypoint.first;

                  _showSnackBar(context, "Durak başarıyla eklendi");

                  setState(() {
                    widget.waypoints.add(waypoint);
                    _getRouteFromWaypoints();
                  });
                  Navigator.pop(context);
                },
              ),
            ),
      );
    } catch (e) {
      _showSnackBar(context, "Durak eklenemedi: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/car_travel.jpg',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.place, size: 20, color: Colors.blue),
                      const SizedBox(width: 8),
                      if (widget.waypoints.length >= 2)
                        Row(
                          children: [
                            Text(
                              widget.waypoints.first.district.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.waypoints.last.district.name.contains('(')
                                  ? widget.waypoints.last.district.name.split(
                                    '(',
                                  )[0]
                                  : widget.waypoints.last.district.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        )
                      else if (widget.waypoints.length == 1)
                        Text(
                          widget.waypoints.first.district.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        )
                      else
                        const Text("Şehir bilgisi yok"),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.map_rounded, color: Colors.teal),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.waypoints.length} durak noktasından oluşan rota',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    ' Oluşturulma tarihi: ${widget.travel.creationDate!.day}/${widget.travel.creationDate!.month}/${widget.travel.creationDate!.year}',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: TravelRouteMapWidget(
              routePoints: _routePoints,
              waypointLocations:
                  widget.waypoints.map((wp) => wp.selectedLocation!).toList(),
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Seyahat Bilgilerim",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Column(
            children: [
              SizedBox(
                height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.waypoints.length,
                  itemBuilder: (context, index) {
                    return WaypointsListItem(
                      waypoint: widget.waypoints[index],
                      index: index,
                      onUpdate: (updatedWaypoint) {
                        setState(() {
                          widget.waypoints.removeAt(index);
                        });
                      },
                      onDelete: (deletedWaypoint) {
                        _deleteWaypoint(deletedWaypoint);
                      },
                      travelId: widget.travel.id!,
                    );
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 14, left: 14, right: 14),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _addWaypoint(widget.travel),
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor: AppColors.ALLERGEO_GREEN,
                ),
                child: const Text(
                  "Durak Ekle",
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
