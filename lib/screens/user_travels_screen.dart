import 'package:allergeo/config/colors.dart';
import 'package:allergeo/models/users/travel_model.dart';
import 'package:allergeo/screens/login_screen.dart';
import 'package:allergeo/services/users/travel_service.dart';
import 'package:allergeo/services/users/user_service.dart';
import 'package:allergeo/utils/strings.dart';
import 'package:allergeo/widgets/user_travels_list_item.dart';
import 'package:flutter/material.dart';

class UserTravelsScreen extends StatefulWidget {
  const UserTravelsScreen({super.key});

  @override
  _UserTravelsScreenState createState() => _UserTravelsScreenState();
}

class _UserTravelsScreenState extends State<UserTravelsScreen> {
  static final UserService userService = UserService();
  static final TravelService travelService = TravelService();
  List<TravelModel>? travels;

  @override
  void initState() {
    super.initState();
    _fetchUserTravels();
  }

  Future<int> _getUserId() async {
    try {
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

  Future<void> _fetchUserTravels() async {
    try {
      int userId = await _getUserId();
      var fethedUserTravels = await travelService.fetchUserTravels(userId);

      final now = DateTime.now();
      List<TravelModel> ongoingTravels = [];
      List<TravelModel> upcomingTravels = [];
      List<TravelModel> pastTravels = [];

      for (var travel in fethedUserTravels) {
        if (travel.startDate.isBefore(now) &&
            (travel.returnDate == null || travel.returnDate!.isAfter(now))) {
          ongoingTravels.add(travel);
        } else if (travel.startDate.isAfter(now)) {
          upcomingTravels.add(travel);
        } else if (travel.returnDate != null &&
            travel.returnDate!.isBefore(now)) {
          pastTravels.add(travel);
        }
      }

      List<TravelModel> sortedTravels =
          []
            ..addAll(ongoingTravels)
            ..addAll(upcomingTravels)
            ..addAll(pastTravels);
      setState(() {
        travels = sortedTravels;
      });
    } catch (e) {
      print('Kullanıcı bilgileri alınırken hata: $e');
    }
  }

  void _deleteTravel(TravelModel travelToDelete) async {
    try {
      int userId = await _getUserId();
      bool isDeleted = await travelService.deleteUserTravel(
        userId,
        travelToDelete.id!,
      );

      if (isDeleted) {
        setState(() {
          travels?.removeWhere((allergy) => allergy.id == travelToDelete.id);
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Seyahat başarıyla silindi")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Seyahat silinemedi: $e")));
    }
  }

  void _handleUpdate(TravelModel updatedTravel) {
    setState(() {
      int index = travels!.indexWhere((a) => a.id == updatedTravel.id);
      if (index != -1) {
        travels![index] = updatedTravel;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Strings.USER_TRAVELS,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.ALLERGEO_GREEN,
      ),
      body:
          travels == null
              ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.ALLERGEO_GREEN,
                ),
              )
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: List.generate(travels!.length, (index) {
                      return Column(
                        children: [
                          UserTravelsListItem(
                            travel: travels![index],
                            onUpdate: _handleUpdate,
                            onDelete: (deletedTravel) {
                              _deleteTravel(deletedTravel);
                            },
                          ),
                          const SizedBox(height: 8),
                        ],
                      );
                    }),
                  ),
                ),
              ),
    );
  }
}
