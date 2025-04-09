import 'package:allergeo/models/predictors/ai_allergy_attack_prediction_model.dart';
import 'package:allergeo/models/users/travel_model.dart';
import 'package:allergeo/screens/login_screen.dart';
import 'package:allergeo/services/users/travel_service.dart';
import 'package:allergeo/services/users/user_service.dart';
import 'package:allergeo/widgets/waypoints_list_item.dart';
import 'package:flutter/material.dart';

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

    // OverlayEntry'i ekleyip sonra bir süre sonra kaldırıyoruz
    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
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
                              widget.waypoints.last.district.name,
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
          SizedBox(height: 24),
          Text(
            "Seyahat Bilgilerim",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Column(
            children: [
              SizedBox(
                height: 300,
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
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
