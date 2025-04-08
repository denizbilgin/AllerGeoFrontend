import 'package:allergeo/models/users/travel_model.dart';
import 'package:flutter/material.dart';

class UserTravelDetailScreen extends StatefulWidget {
  final TravelModel travel;
  final Function(TravelModel) onUpdate;

  const UserTravelDetailScreen({
    required this.travel,
    required this.onUpdate,
  });

  @override
  _UserTravelDetailScreen createState() => _UserTravelDetailScreen();
}

class _UserTravelDetailScreen extends State<UserTravelDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
  
}