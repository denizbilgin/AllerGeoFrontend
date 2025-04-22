import 'package:allergeo/config/constants.dart';
import 'package:allergeo/models/predictors/ai_allergy_attack_prediction_model.dart';
import 'package:allergeo/models/users/travel_model.dart';
import 'package:allergeo/services/users/user_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TravelService {
  final String usersUrl = AppConstants.usersUrl;
  UserService userService = UserService();

  Future<List<TravelModel>> fetchUserTravels(int userId) async {
    try {
      String token = await userService.getUserAccessToken();
      final response = await http.get(
        Uri.parse("$usersUrl$userId/travels"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        return travelsFromJson(data);
      } else if(response.statusCode == 404){
        throw jsonDecode(response.body).values.first;
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }

  Future<TravelModel> fetchUserTravelById(int userId, int travelId) async {
    try {
      String token = await userService.getUserAccessToken();
      final response = await http.get(
        Uri.parse("$usersUrl$userId/travels/$travelId"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonData = json.decode(data);
        return TravelModel.fromJson(jsonData);
      } else if(response.statusCode == 404){
        throw jsonDecode(response.body).values.first;
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }

  Future<TravelModel> createUserTravel(TravelModel travel) async {
    try {
      String token = await userService.getUserAccessToken();
      final url = "$usersUrl${travel.user.id}/travels";
      
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(travel.toJson()),
      );

      if (response.statusCode == 201) {
        String data = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(data);
        return TravelModel.fromJson(jsonData);
      } else if(response.statusCode == 400){
        throw jsonDecode(response.body).values.first;
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }

  Future<TravelModel> updateUserTravel(TravelModel travel) async {
    try {
      final url = "$usersUrl${travel.user.id}/travels/${travel.id}";
      String token = await userService.getUserAccessToken();
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(travel.toJson()),
      );

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(data);
        return TravelModel.fromJson(jsonData);
      } else if(response.statusCode == 400){
        throw jsonDecode(response.body).values.first;
      } else if(response.statusCode == 404){
        throw jsonDecode(response.body).values.first;
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }

  Future<bool> deleteUserTravel(int userId, int travelId) async {
    try {
      // First, delete waypoints of the travel
      List<AIAllergyAttackPredictionModel> waypoints = await fetchUserTravelWaypointsById(userId, travelId);
      for (AIAllergyAttackPredictionModel waypoint in waypoints) {
        await deleteUserTravelWaypoint(userId, travelId, waypoint.id!);
      }

      final url = "$usersUrl$userId/travels/$travelId";
      String token = await userService.getUserAccessToken();
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 204) {
        return true;
      } else if(response.statusCode == 404){
        throw jsonDecode(response.body).values.first;
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }

  // Waypoint Functions
  Future<List<AIAllergyAttackPredictionModel>> fetchUserTravelWaypointsById(int userId, int travelId) async {
    try {
      String token = await userService.getUserAccessToken();
      final response = await http.get(
        Uri.parse("$usersUrl$userId/travels/$travelId/waypoints"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        return aiAllergyAttackPredictionsFromJson(data);
      } else if(response.statusCode == 404){
        throw jsonDecode(response.body).values.first;
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }

  Future<List<AIAllergyAttackPredictionModel>> createUserTravelWaypoints(List<AIAllergyAttackPredictionModel> waypoints, int travelId) async {
    try {
      final url = "$usersUrl${waypoints[0].user.id}/travels/$travelId/waypoints";
      String token = await userService.getUserAccessToken();
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(toJsonMultiple(waypoints)),
      );

      if (response.statusCode == 201) {
        String data = utf8.decode(response.bodyBytes);
        return aiAllergyAttackPredictionsFromJson(data);
      } else if(response.statusCode == 400){
        throw jsonDecode(response.body).values.first;
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }

  Future<AIAllergyAttackPredictionModel> fetchUserTravelWaypointByWaypointId(int userId, int travelId, int waypointId) async {
    try {
      final response = await http.get(Uri.parse("$usersUrl$userId/travels/$travelId/waypoints/$waypointId"));

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonData = json.decode(data);
        return AIAllergyAttackPredictionModel.fromJson(jsonData);
      } else if(response.statusCode == 404){
        throw jsonDecode(response.body).values.first;
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }

  Future<AIAllergyAttackPredictionModel> updateUserTravelWaypoint(AIAllergyAttackPredictionModel waypoint) async {
    try {
      String token = await userService.getUserAccessToken();
      final url = "$usersUrl${waypoint.user.id}/travels/${waypoint.travel!.id}/waypoints/${waypoint.id}";
      
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(waypoint.toJson()),
      );

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(data);
        return AIAllergyAttackPredictionModel.fromJson(jsonData);
      } else if(response.statusCode == 400){
        throw jsonDecode(response.body).values.first;
      } else if(response.statusCode == 404){
        throw jsonDecode(response.body).values.first;
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }

  Future<bool> deleteUserTravelWaypoint(int userId, int travelId, int waypointId) async {
    try {
      List<AIAllergyAttackPredictionModel> waypoints = await fetchUserTravelWaypointsById(userId, travelId);
      AIAllergyAttackPredictionModel? waypointIndexToBeDeleted = waypoints.firstWhere((w) => w.id == waypointId, orElse: () => throw "Silinecek waypoint bulunamadı");
      waypoints.sort((a, b) => a.date.compareTo(b.date));
      TravelModel travel = await fetchUserTravelById(userId, travelId);

      if (waypoints.length > 1) {
        bool isFirst = waypoints.first.id == waypointId;
        bool isLast = waypoints.last.id == waypointId;

        if (isFirst || isLast) {
          waypoints.removeWhere((w) => w.id == waypointId);

          if (isFirst) {
            travel.startDate = waypoints.first.date;
          }
          if (isLast) {
            travel.returnDate = waypoints.last.date;
          }

          await updateUserTravel(travel);
        }
      } else {
        travel.startDate = waypointIndexToBeDeleted.date;
        travel.returnDate = null;
        await updateUserTravel(travel);
      }

      final url = "$usersUrl$userId/travels/$travelId/waypoints/$waypointId";
      String token = await userService.getUserAccessToken();
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 204) {
        return true;
      } else if(response.statusCode == 404){
        throw jsonDecode(response.body).values.first;
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }
}