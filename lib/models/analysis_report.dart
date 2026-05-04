// 약점 분석 리포트 모델 — AnalysisAgent 결과를 담는다 (유료 기능)

class WeaknessPattern {
  final String category;    // 예: "시제 오류", "관사 누락"
  final double frequency;   // 전체 오류 대비 비율 (0.0–1.0)
  final List<String> examples;

  const WeaknessPattern({
    required this.category,
    required this.frequency,
    required this.examples,
  });

  factory WeaknessPattern.fromJson(Map<String, dynamic> json) => WeaknessPattern(
    category: json['category'] as String,
    frequency: (json['frequency'] as num).toDouble(),
    examples: List<String>.from(json['examples'] as List),
  );
}

class AnalysisReport {
  final int totalSessions;
  final List<WeaknessPattern> weaknessPatterns;
  final String improvementTrend; // 'improving' | 'stable' | 'declining'
  final String recommendedScenario;

  const AnalysisReport({
    required this.totalSessions,
    required this.weaknessPatterns,
    required this.improvementTrend,
    required this.recommendedScenario,
  });

  factory AnalysisReport.fromJson(Map<String, dynamic> json) => AnalysisReport(
    totalSessions: json['total_sessions'] as int,
    weaknessPatterns: (json['weakness_patterns'] as List)
        .map((e) => WeaknessPattern.fromJson(e as Map<String, dynamic>))
        .toList(),
    improvementTrend: json['improvement_trend'] as String,
    recommendedScenario: json['recommended_scenario'] as String,
  );
}
