import 'package:allergeo/config/colors.dart';
import 'package:allergeo/models/allergies/user_allergy_model.dart';
import 'package:allergeo/screens/update_user_allergy_screen.dart';
import 'package:flutter/material.dart';

class UserAllergiesListItem extends StatelessWidget {
  final UserAllergyModel userAllergy;
  final Function(UserAllergyModel) onUpdate;
  final Function(UserAllergyModel) onDelete;

  const UserAllergiesListItem({
    required this.userAllergy,
    required this.onUpdate,
    required this.onDelete,
    super.key,
  });

  Color _getBackgroundColor() {
    switch (userAllergy.importanceLevel) {
      case 1:
        return AppColors.ALLERGEO_GREEN.shade200;
      case 2:
        return Colors.blue[200]!;
      case 3:
        return Colors.amber[200]!;
      case 4:
        return Colors.orange[200]!;
      default:
        return Colors.red[200]!;
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
          (context) => UpdateUserAllergyScreen(
            userAllergy: userAllergy,
            onUpdate: onUpdate,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showEditModal(context),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        color: _getBackgroundColor(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userAllergy.allergen.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                      children: [
                        TextSpan(
                          text: 'Eklenme tarihi: ',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                        TextSpan(
                          text: userAllergy.creationDate
                              ?.toLocal()
                              .toString()
                              .split(' ')[0],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        userAllergy.importanceLevel.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                right: -12,
                top: -12,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => onDelete(userAllergy),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}