// FeedbackAgent: 대화 종료 후 Gemini API로 문법/표현/자연스러움 종합 피드백 생성

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/api_config.dart';
import '../models/feedback.dart';
import '../models/message.dart';

class FeedbackService {
  /// 전체 대화 내용을 분석해 피드백을 생성한다
  Future<Feedback> generateFeedback({required List<Message> messages}) async {
    // 사용자 메시지만 추출해 분석 대상으로 사용
    final userMessages = messages
        .where((m) => m.isUser)
        .map((m) => '- "${m.content}"')
        .join('\n');

    // 대화가 없는 경우 기본 피드백 반환
    if (userMessages.isEmpty) {
      return const Feedback(
        grammarErrors: [],
        expressionSuggestions: ['Try to write more sentences next time!'],
        naturalnessScore: 50,
        overallComment: '대화 내용이 없습니다. 다음에 더 많이 연습해보세요!',
      );
    }

    // 네이티브 Gemini API — API 키를 URL에 포함해 CORS 헤더 없이 호출
    final response = await http.post(
      Uri.parse(ApiConfig.apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'role': 'user',
            'parts': [
              {'text': _buildPrompt(userMessages)}
            ],
          }
        ],
        'generationConfig': {'maxOutputTokens': 2048},
      }),
    );

    if (response.statusCode == 429) {
      throw Exception('서버가 혼잡합니다. 잠시 후 다시 시도해주세요.');
    }
    if (response.statusCode != 200) {
      throw Exception('피드백 생성 실패: ${response.statusCode}');
    }

    // 네이티브 Gemini 응답 형식: candidates[0].content.parts[0].text
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final text =
        (body['candidates'] as List).first['content']['parts'][0]['text'] as String;

    // 마크다운 코드블록 제거 후 JSON 파싱
    final jsonText = text
        .replaceAll(RegExp(r'```json\s*'), '')
        .replaceAll(RegExp(r'```\s*'), '')
        .trim();

    try {
      final feedbackJson = jsonDecode(jsonText) as Map<String, dynamic>;
      return Feedback.fromJson(feedbackJson);
    } catch (e) {
      // JSON 파싱 실패 시 기본 피드백 반환
      return const Feedback(
        grammarErrors: [],
        expressionSuggestions: ['Great effort! Keep practicing.'],
        naturalnessScore: 70,
        overallComment: '피드백을 불러오는 중 오류가 발생했습니다. 다시 시도해주세요.',
      );
    }
  }

  // FeedbackAgent 프롬프트 — 사용자 문장 분석 지시
  String _buildPrompt(String userMessages) {
    return '''
You are an English language tutor analyzing a student's conversation practice.
Analyze the following student messages and respond ONLY with a JSON object:

{
  "grammar_errors": [
    {
      "original": "the exact sentence the student wrote",
      "corrected": "the corrected version",
      "explanation": "설명 (한국어로)"
    }
  ],
  "expression_suggestions": [
    "More natural alternative expression 1",
    "More natural alternative expression 2"
  ],
  "naturalness_score": 75,
  "overall_comment": "전반적인 평가 (한국어로, 2-3문장, 격려 포함)"
}

Student messages:
$userMessages

Rules:
- naturalness_score: 0-100 integer (be fair and encouraging)
- grammar_errors: only real errors, empty array [] if none
- expression_suggestions: 2-3 more natural English alternatives
- overall_comment: written in Korean, encouraging tone
- Respond with JSON only. No markdown, no explanation.
''';
  }
}
