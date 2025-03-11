import 'package:allergeo/config/constants.dart';
import 'package:allergeo/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.ALLERGEO_GREEN.shade200,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                Strings.CREATE_TRAVEL,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/images/luggages.svg',
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: 10,
                    color: AppColors.ALLERGEO_GREEN.shade400,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
