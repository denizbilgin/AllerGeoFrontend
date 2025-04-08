import 'package:allergeo/config/colors.dart';
import 'package:allergeo/models/predictors/ai_allergy_attack_prediction_model.dart';
import 'package:allergeo/models/users/travel_model.dart';
import 'package:allergeo/screens/user_travel_detail_screen.dart';
import 'package:allergeo/services/users/travel_service.dart';
import 'package:allergeo/services/users/user_service.dart';
import 'package:flutter/material.dart';

class UserTravelsListItem extends StatefulWidget {
  final TravelModel travel;
  final Function(TravelModel) onUpdate;
  final Function(TravelModel) onDelete;

  const UserTravelsListItem({
    super.key,
    required this.travel,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<UserTravelsListItem> createState() => _UserTravelsListItemState();
}

class _UserTravelsListItemState extends State<UserTravelsListItem> {
  List<AIAllergyAttackPredictionModel>? waypoints;

  @override
  void initState() {
    super.initState();
    _fetchWaypoints();
  }

  Future<int> _getUserId() async {
    try {
      UserService userService = UserService();
      String token = await userService.getUserAccessToken();
      final userId = userService.getUserIdFromToken(token);
      return userId;
    } catch (e) {
      print('User ID alınırken hata: $e');
      return 0;
    }
  }

  Future<void> _fetchWaypoints() async {
    try {
      int userId = await _getUserId();
      TravelService travelService = TravelService();
      final userTravelWaypoints = await travelService
          .fetchUserTravelWaypointsById(userId, widget.travel.id!);
      setState(() {
        waypoints = userTravelWaypoints;
      });
    } catch (e) {
      debugPrint("Durak verisi alınamadı: $e");
    }
  }

  void _showEditModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => UserTravelDetailScreen(
            travel: widget.travel,
            onUpdate: widget.onUpdate,
          ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          titlePadding: EdgeInsets.zero,
          title: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.ALLERGEO_GREEN,
              child: const Text(
                'Seyahati Sil',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          content: const Text('Bu seyahati silmek istediğinize emin misiniz?'),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onDelete(widget.travel);
              },
              child: const Text('Evet', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Text _headerText() {
    final now = DateTime.now();

    if (widget.travel.returnDate != null &&
        widget.travel.returnDate!.isBefore(now)) {
      return Text(
        ' Geçmiş',
        style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold, fontSize: 16),
      );
    }

    if (widget.travel.startDate.isBefore(now) &&
        (widget.travel.returnDate == null ||
            widget.travel.returnDate!.isAfter(now))) {
      return Text(
        ' Devam Ediyor',
        style: TextStyle(color: AppColors.ALLERGEO_GREEN.shade300, fontWeight: FontWeight.bold, fontSize: 16),
      );
    }
    return Text(
      ' Yaklaşan',
      style: TextStyle(color: const Color.fromARGB(255, 231, 187, 40), fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showEditModal(context),
      child: Card(
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _headerText(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.place, size: 20, color: Colors.blue),
                      const SizedBox(width: 8),
                      if (waypoints != null && waypoints!.length >= 2)
                        Row(
                          children: [
                            Text(
                              waypoints!.first.district.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              waypoints!.last.district.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      else if (waypoints != null && waypoints!.length == 1)
                        Text(
                          waypoints!.first.district.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      else
                        const Text("Şehir bilgisi yok"),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.directions_car_filled,
                        color: AppColors.ALLERGEO_GREEN,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Başlangıç: ${widget.travel.startDate.day}/${widget.travel.startDate.month}/${widget.travel.startDate.year}",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (widget.travel.returnDate != null)
                    Row(
                      children: [
                        const Icon(Icons.home, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          "Dönüş: ${widget.travel.returnDate!.day}/${widget.travel.returnDate!.month}/${widget.travel.returnDate!.year}",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.map_rounded, color: Colors.teal),
                      const SizedBox(width: 8),
                      Text(
                        '${waypoints?.length} durak noktasından oluşan rota',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 2,
              right: 2,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () => _showDeleteConfirmation(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
