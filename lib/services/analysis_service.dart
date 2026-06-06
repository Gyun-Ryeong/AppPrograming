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
        'generationConfig': {
          'maxOutputTokens': 4096,
          'temperature': 0.3,
          'responseMimeType': 'application/json',
        },
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

    try {
      final reportJson = jsonDecode(jsonText) as Map<String, dynamic>;
      return AnalysisReport.fromJson(reportJson);
    } catch (e) {
      return AnalysisReport(
        totalSessions: sessions.length,
        weaknessPatterns: [],
        improvementTrend: 'stable',
        recommendedScenario: '분석 중 오류가 발생했습니다. 다시 시도해주세요.',
      );
    }
  }

  // AnalysisAgent 프롬프트 — 누적 메시지에서 약점 패턴 추출
  String _buildPrompt(int sessionCount, String allMessages) {
    return '''Analyze these English practice messages and return ONLY this JSON (no markdown):
{"total_sessions":$sessionCount,"weakness_patterns":[{"category":"시제 오류","frequency":0.4,"examples":["I am go to school"]}],"improvement_trend":"stable","recommended_scenario":"카페에서 주문하기"}

Student messages:
$allMessages

Return ONLY valid JSON matching the structure above. weakness_patterns max 3 items. All text values in Korean except examples.''';
  }
}
