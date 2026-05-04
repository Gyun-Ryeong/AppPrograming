// 피드백 모델 — FeedbackAgent가 생성한 결과를 담는다

class GrammarError {
  final String original;    // 사용자가 말한 문장
  final String corrected;   // 수정된 문장
  final String explanation; // 설명

  const GrammarError({
    required this.original,
    required this.corrected,
    required this.explanation,
  });

  factory GrammarError.fromJson(Map<String, dynamic> json) => GrammarError(
    original: json['original'] as String,
    corrected: json['corrected'] as String,
    explanation: json['explanation'] as String,
  );
}

class Feedback {
  final List<GrammarError> grammarErrors;
  final List<String> expressionSuggestions; // 더 자연스러운 표현 제안
  final int naturalnessScore;               // 0–100점
  final String overallComment;

  const Feedback({
    required this.grammarErrors,
    required this.expressionSuggestions,
    required this.naturalnessScore,
    required this.overallComment,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) => Feedback(
    grammarErrors: (json['grammar_errors'] as List)
        .map((e) => GrammarError.fromJson(e as Map<String, dynamic>))
        .toList(),
    expressionSuggestions: List<String>.from(json['expression_suggestions'] as List),
    naturalnessScore: json['naturalness_score'] as int,
    overallComment: json['overall_comment'] as String,
  );
}
