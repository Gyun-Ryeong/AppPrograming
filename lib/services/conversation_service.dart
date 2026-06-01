// ConversationAgent: 시나리오 맥락을 유지하며 Gemini API로 실시간 대화 진행

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
    // 대화 히스토리를 Gemini 형식으로 변환 (role: user/model)
    final contents = [
      ...history.map((m) => {
            'role': m.isUser ? 'user' : 'model',
            'parts': [
              {'text': m.content}
            ],
          }),
      {
        'role': 'user',
        'parts': [
          {'text': userMessage}
        ],
      },
    ];

    // 네이티브 Gemini API — 시스템 인스트럭션 + 대화 히스토리 전달
    final response = await http.post(
      Uri.parse(ApiConfig.apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'system_instruction': {
          'parts': [
            {'text': _buildSystemPrompt(scenario)}
          ],
        },
        'contents': contents,
        'generationConfig': {'maxOutputTokens': 512},
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('대화 응답 실패: ${response.statusCode}');
    }

    // 네이티브 Gemini 응답 형식: candidates[0].content.parts[0].text
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return (body['candidates'] as List).first['content']['parts'][0]['text'] as String;
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
