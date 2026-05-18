// ScenarioAgent: 사용자 상황 입력 → Claude API 직접 호출 → 시나리오 생성

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/api_config.dart';
import '../models/scenario.dart';

class ScenarioService {
  /// 사용자가 입력한 상황으로 AI 시나리오를 생성한다.
  ///
  /// [situation] — 사용자가 입력한 상황 (예: "카페에서 음료 주문")
  /// [difficulty] — 'beginner' | 'intermediate' | 'advanced'
  /// [category] — 'daily' | 'business' | 'travel' | 'academic'
  Future<Scenario> generateScenario({
    required String situation,
    required String difficulty,
    required String category,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConfig.claudeApiUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': ApiConfig.claudeApiKey,
        'anthropic-version': ApiConfig.anthropicVersion,
      },
      body: jsonEncode({
        'model': ApiConfig.claudeModel,
        'max_tokens': 1024,
        'messages': [
          {
            'role': 'user',
            'content': _buildPrompt(situation, difficulty, category),
          }
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('시나리오 생성 실패: ${response.statusCode}');
    }

    // Claude 응답에서 텍스트 추출 후 JSON 파싱
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final text = (body['content'] as List).first['text'] as String;

    // 마크다운 코드블록(```json ... ```) 제거
    final jsonText = text
        .replaceAll(RegExp(r'```json\s*'), '')
        .replaceAll(RegExp(r'```\s*'), '')
        .trim();

    final scenarioJson = jsonDecode(jsonText) as Map<String, dynamic>;
    return Scenario.fromJson(scenarioJson);
  }

  // ScenarioAgent 시스템 프롬프트
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
