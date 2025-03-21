import 'package:allergeo/config/constants.dart';
import 'package:allergeo/main.dart';
import 'package:allergeo/models/users/user_model.dart';
import 'package:allergeo/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final String usersUrl = AppConstants.usersUrl;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<UserModel> fetchUserById(int userId) async {
    try {
      String token = await getUserAccessToken();
      final response = await http.get(
        Uri.parse("$usersUrl$userId"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonData = json.decode(data);
        return UserModel.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        await logout();
        throw "Token yenilenemedi. Lütfen tekrar giriş yapın.";
      } else if (response.statusCode == 404) {
        throw jsonDecode(response.body).values.first;
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }

  int getUserIdFromToken(String token) {
    try {
      final String secretKey = dotenv.env['SECRET_KEY'] ?? '';
      final jwt = JWT.verify(token, SecretKey(secretKey));
      final userId = jwt.payload['user_id'];
      return userId;
    } catch (e) {
      print('Token doğrulama hatası: $e');
      return 0;
    }
  }

  Future<String?> refreshAccessToken() async {
    try {
      String? refreshToken = await _storage.read(key: 'refreshToken');
      if (refreshToken == null) {
        await logout();
        return null;
      }

      final response = await http.post(
        Uri.parse("${usersUrl}refresh-token"),
        body: json.encode({'refresh': refreshToken}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final newAccessToken = responseBody['access'];
        await _storage.write(key: 'accessToken', value: newAccessToken);
        print('Access token yenilendi.');
        return newAccessToken;
      } else {
        await logout();
        return null;
      }
    } catch (e) {
      print("Access token yenileme hatası: $e");
      await logout();
      return null;
    }
  }

  Future<String> getUserAccessToken() async {
    try {
      String? token = await _storage.read(key: 'accessToken');
      if (token == null) {
        throw "Token bulunamadı.";
      }

      double tokenRemainingTime = getTokenRemainingTime(token);
      if (tokenRemainingTime < 2) {
        String? newToken = await refreshAccessToken();
        if (newToken != null) {
          return newToken;
        }
      }

      return token;
    } catch (e) {
      throw "Token alırken bir hata oluştu: $e";
    }
  }

  double getTokenRemainingTime(String token) {
    try {
      final String secretKey = dotenv.env['SECRET_KEY'] ?? '';
      final jwt = JWT.verify(token, SecretKey(secretKey));
      int exp = jwt.payload['exp'] * 1000;
      int now = DateTime.now().millisecondsSinceEpoch;
      print(now);
      int remainingSeconds = (exp - now) ~/ 1000;
      double remainingMinutes = remainingSeconds / 60;
      print(remainingMinutes);
      return remainingMinutes;
    } catch (e) {
      return -1;
    }
  }

  Future<void> logout() async {
    final storage = FlutterSecureStorage();
    String? refreshToken = await storage.read(key: 'refreshToken');

    if (refreshToken != null) {
      await http.post(
        Uri.parse("${usersUrl}logout"),
        body: json.encode({'refresh': refreshToken}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    await storage.delete(key: 'accessToken');
    await storage.delete(key: 'refreshToken');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    });
  }
}
