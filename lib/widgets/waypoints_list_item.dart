import 'package:allergeo/config/colors.dart';
import 'package:allergeo/models/predictors/ai_allergy_attack_prediction_model.dart';
import 'package:allergeo/screens/travel_waypoint_detail_screen.dart';
import 'package:flutter/material.dart';

class WaypointsListItem extends StatefulWidget {
  final AIAllergyAttackPredictionModel waypoint;
  final int index;
  final Function(AIAllergyAttackPredictionModel) onUpdate;
  final Function(AIAllergyAttackPredictionModel) onDelete;
  final int travelId;

  const WaypointsListItem({
    required this.waypoint,
    required this.index,
    required this.onUpdate,
    required this.onDelete,
    required this.travelId
  });

  @override
  State<WaypointsListItem> createState() => _WaypointsListItemState();
}

class _WaypointsListItemState extends State<WaypointsListItem> {
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
                'Durağı Sil',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          content: const Text('Bu durağı silmek istediğinize emin misiniz?'),
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
                widget.onDelete(widget.waypoint);
              },
              child: const Text('Evet', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              insetPadding: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: TravelWaypointDetailScreen(
                    waypoint: widget.waypoint,
                    onUpdate: widget.onUpdate,
                    travelId: widget.travelId,
                  ),
                ),
              ),
            );
          },
        );
      },

      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.ALLERGEO_GREEN.shade100,
                  border: Border.all(color: AppColors.ALLERGEO_GREEN, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${widget.index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.waypoint.district.name,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.waypoint.date.day}/${widget.waypoint.date.month}/${widget.waypoint.date.year}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => _showDeleteConfirmation(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
