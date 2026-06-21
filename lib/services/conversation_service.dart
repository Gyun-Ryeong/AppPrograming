// ConversationAgent: 시나리오 맥락을 유지하며 Gemini API로 실시간 대화 진행

import 'dart:convert';

import '../models/message.dart';
import '../models/scenario.dart';
import 'gemini_api_helper.dart';

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

    // 네이티브 Gemini API — 429(요청 과다) 시 헬퍼가 한 번 자동 재시도한다
    final response = await GeminiApiHelper.post({
      'system_instruction': {
        'parts': [
          {'text': _buildSystemPrompt(scenario)}
        ],
      },
      'contents': contents,
      'generationConfig': {'maxOutputTokens': 512},
    });

    if (response.statusCode == 429) {
      throw Exception('서버가 혼잡합니다. 잠시 후 다시 시도해주세요.');
    }
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
