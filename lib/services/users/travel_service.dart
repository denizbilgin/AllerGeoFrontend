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
      final response = await http.get(Uri.parse("$usersUrl$userId/travels"));

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        print(data);
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
      final response = await http.get(Uri.parse("$usersUrl$userId/travels/$travelId"));

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
      
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          // "Authorization": "Bearer $token"
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
      
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          // "Authorization": "Bearer $token"
        }
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
      final response = await http.get(Uri.parse("$usersUrl$userId/travels/$travelId/waypoints"));

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
      final url = "$usersUrl${waypoint.user.id}/travels/${waypoint.travel!.id}/waypoints/${waypoint.id}";
      
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          // "Authorization": "Bearer $token"
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
      final url = "$usersUrl$userId/travels/$travelId/waypoints/$waypointId";
      
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          // "Authorization": "Bearer $token"
        }
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