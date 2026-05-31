// ConversationAgent: 시나리오 맥락을 유지하며 OpenRouter API로 실시간 대화 진행

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/api_config.dart';
import '../models/message.dart';
import '../models/scenario.dart';

class ConversationService {
  /// 시나리오 맥락 + 대화 히스토리를 포함해 메시지를 전송하고 응답을 받는다.
  Future<String> sendMessage({
    required Scenario scenario,
    required List<Message> history,
    required String userMessage,
  }) async {
    // 시스템 프롬프트 + 대화 히스토리 + 새 메시지 조합
    final messages = [
      {'role': 'system', 'content': _buildSystemPrompt(scenario)},
      ...history.map((m) => {'role': m.role, 'content': m.content}),
      {'role': 'user', 'content': userMessage},
    ];

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
        'max_tokens': 512,
        'messages': messages,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('대화 응답 실패: ${response.statusCode}');
    }

    // OpenRouter 응답 형식: choices[0].message.content
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return (body['choices'] as List).first['message']['content'] as String;
  }

  /// 시나리오 정보를 시스템 프롬프트로 변환
  String _buildSystemPrompt(Scenario scenario) {
    return '''
You are an English conversation practice partner.

[Background]: ${scenario.background}
[Your role]: ${scenario.aiRole}
[User's role]: ${scenario.userRole}
[Goal]: ${scenario.goal}

Rules:
- Respond in English only
- Stay within the scenario context
- Keep responses concise (2-4 sentences)
- Be encouraging and natural
''';
  }
}
