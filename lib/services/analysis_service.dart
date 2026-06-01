// AnalysisAgent: 누적 대화 세션을 분석해 약점 패턴 리포트 생성 (유료 기능)

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/api_config.dart';
import '../models/analysis_report.dart';
import '../models/conversation_session.dart';

class AnalysisService {
  /// 누적 대화 세션 목록을 분석해 약점 패턴 리포트를 반환한다
  Future<AnalysisReport> getAnalysisReport({
    required List<ConversationSession> sessions,
  }) async {
    // 분석할 세션이 없는 경우
    if (sessions.isEmpty) {
      return const AnalysisReport(
        totalSessions: 0,
        weaknessPatterns: [],
        improvementTrend: 'stable',
        recommendedScenario: '먼저 대화 연습을 시작해보세요!',
      );
    }

    // 모든 세션의 사용자 메시지 수집
    final allUserMessages = sessions
        .expand((s) => s.messages.where((m) => m.isUser))
        .map((m) => '- "${m.content}"')
        .join('\n');

    final response = await http.post(
      Uri.parse(ApiConfig.apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'role': 'user',
            'parts': [
              {'text': _buildPrompt(sessions.length, allUserMessages)},
            ],
          }
        ],
        'generationConfig': {'maxOutputTokens': 1024},
      }),
    );

    if (response.statusCode == 429) {
      throw Exception('서버가 혼잡합니다. 잠시 후 다시 시도해주세요.');
    }
    if (response.statusCode != 200) {
      throw Exception('분석 실패: ${response.statusCode}');
    }

    // 네이티브 Gemini 응답: candidates[0].content.parts[0].text
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final text = (body['candidates'] as List).first['content']['parts'][0]['text'] as String;

    final jsonText = text
        .replaceAll(RegExp(r'```json\s*'), '')
        .replaceAll(RegExp(r'```\s*'), '')
        .trim();

    final reportJson = jsonDecode(jsonText) as Map<String, dynamic>;
    return AnalysisReport.fromJson(reportJson);
  }

  // AnalysisAgent 프롬프트 — 누적 메시지에서 약점 패턴 추출
  String _buildPrompt(int sessionCount, String allMessages) {
    return '''
You are an English learning coach analyzing a student's accumulated conversation practice data.
Analyze the following messages from $sessionCount practice sessions and respond ONLY with a JSON object:

{
  "total_sessions": $sessionCount,
  "weakness_patterns": [
    {
      "category": "오류 유형 (한국어, 예: 시제 오류)",
      "frequency": 0.45,
      "examples": ["original sentence with error", "another example"]
    }
  ],
  "improvement_trend": "improving",
  "recommended_scenario": "추천 연습 상황 (한국어)"
}

All student messages:
$allMessages

Rules:
- weakness_patterns: 1-4 most common error types, frequency is 0.0-1.0 proportion
- improvement_trend: one of "improving", "stable", "declining"
- recommended_scenario: a specific scenario to practice the weakest area, written in Korean
- category: written in Korean (e.g. "시제 오류", "관사 누락", "전치사 오류")
- Respond with JSON only. No markdown, no explanation.
''';
  }
}
