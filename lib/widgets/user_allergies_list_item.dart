import 'package:allergeo/config/colors.dart';
import 'package:allergeo/models/allergies/user_allergy_model.dart';
import 'package:allergeo/screens/allergy_detail_screen.dart';
import 'package:allergeo/services/users/user_allergy_service.dart';
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
          (context) => UserAllergyDetailScreen(
            userAllergy: userAllergy,
            onUpdate: onUpdate,
          ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, var userAllergy) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          titlePadding: EdgeInsets.zero,
          title: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              padding: EdgeInsets.all(16),
              color: AppColors.ALLERGEO_GREEN,
              child: Text(
                'Alerjiyi Sil',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          content: Text('Bu alerjiyi silmek istediğinize emin misiniz?'),
          actionsPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('İptal', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onDelete(userAllergy);
              },
              child: Text('Evet', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UserAllergyService service = UserAllergyService();
    return GestureDetector(
      onTap: () => _showEditModal(context),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        color: _getBackgroundColor(),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      service.getAllergenImage(userAllergy),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
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
                                text: '${userAllergy.creationDate!.day}/${userAllergy.creationDate!.month}/${userAllergy.creationDate!.year}',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () => _showDeleteConfirmation(context, userAllergy),
              ),
            ),
            Positioned(
              bottom: 18,
              right: 18,
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
      ),
    );
  }
}