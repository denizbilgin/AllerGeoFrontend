import 'package:allergeo/config/constants.dart';
import 'package:allergeo/models/predictors/ai_allergy_attack_prediction_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AIAllergyAttackPredictionService {
  final String aiAllergyAttackPredictionsUrl = "${AppConstants.predictorsUrl}ai-allergy-attack-predictions/";

  Future<List<AIAllergyAttackPredictionModel>> fetchAIAllergyAttackPredictions() async {
    try {
      final response = await http.get(Uri.parse(aiAllergyAttackPredictionsUrl.substring(0, aiAllergyAttackPredictionsUrl.length - 1)));

      if (response.statusCode == 200) {
        String data = utf8.decode(response.bodyBytes);
        return aiAllergyAttackPredictionsFromJson(data);
      } else {
        throw jsonDecode(response.body).values.first;
      }
    } catch (e) {
      throw "Bir hata oluştu: $e";
    }
  }

  // predictor servisleri sonra yapılacak
}