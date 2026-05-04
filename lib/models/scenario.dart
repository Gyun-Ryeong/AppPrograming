// 시나리오 데이터 모델 — ScenarioAgent가 생성한 결과를 담는다

class Scenario {
  final String id;
  final String background; // 배경 설명
  final String userRole;   // 사용자 역할
  final String aiRole;     // AI 파트너 역할
  final String goal;       // 대화 목표

  const Scenario({
    required this.id,
    required this.background,
    required this.userRole,
    required this.aiRole,
    required this.goal,
  });

  factory Scenario.fromJson(Map<String, dynamic> json) {
    return Scenario(
      id: json['id'] as String,
      background: json['background'] as String,
      userRole: json['user_role'] as String,
      aiRole: json['ai_role'] as String,
      goal: json['goal'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'background': background,
    'user_role': userRole,
    'ai_role': aiRole,
    'goal': goal,
  };
}
