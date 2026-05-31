// ScenarioAgent: 사용자 상황 입력 → OpenRouter API 호출 → 시나리오 생성

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/api_config.dart';
import '../models/scenario.dart';

class ScenarioService {
  /// 사용자가 입력한 상황으로 AI 시나리오를 생성한다.
  Future<Scenario> generateScenario({
    required String situation,
    required String difficulty,
    required String category,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConfig.apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConfig.apiKey}',
        'HTTP-Referer': 'https://mef-app.com',
        'X-Title': 'MEF - My English Friend',
      },
      body: jsonEncode({
        'model': ApiConfig.model,
        'max_tokens': 1024,
        'messages': [
          {
            'role': 'user',
            'content': _buildPrompt(situation, difficulty, category),
          }
        ],
      }),
    );

    if (response.statusCode == 429) {
      throw Exception('서버가 혼잡합니다. 잠시 후 다시 시도해주세요.');
    }
    if (response.statusCode != 200) {
      throw Exception('시나리오 생성 실패: ${response.statusCode}');
    }

    // OpenRouter 응답 형식: choices[0].message.content
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final text = (body['choices'] as List).first['message']['content'] as String;

    // 마크다운 코드블록 제거
    final jsonText = text
        .replaceAll(RegExp(r'```json\s*'), '')
        .replaceAll(RegExp(r'```\s*'), '')
        .trim();

    final scenarioJson = jsonDecode(jsonText) as Map<String, dynamic>;
    return Scenario.fromJson(scenarioJson);
  }

  String _buildPrompt(String situation, String difficulty, String category) {
    return '''
You are a scenario generator for English conversation practice.
Based on the user's input, respond ONLY with a JSON object in this exact format:
{
  "id": "unique_id_001",
  "background": "Scene description in English",
  "user_role": "User's role in English",
  "ai_role": "AI partner's role in English",
  "goal": "Conversation goal in English"
}

Situation: $situation
Difficulty: $difficulty
Category: $category

Respond with JSON only. No explanation, no markdown.
''';
  }
}
