// ScenarioAgent: 사용자 상황 입력 → 대화 시나리오 생성
// TODO: Supabase Edge Function 연동 후 구현

import '../models/scenario.dart';

class ScenarioService {
  // TODO: Supabase Edge Function URL로 교체
  static const String _functionUrl = 'https://<project>.supabase.co/functions/v1/scenario';

  /// 사용자가 입력한 상황으로 AI 시나리오를 생성한다
  Future<Scenario> generateScenario({
    required String situation,
    required String difficulty, // 'beginner' | 'intermediate' | 'advanced'
    required String category,   // 'daily' | 'business' | 'travel' | 'academic'
  }) async {
    // TODO: POST _functionUrl 호출 구현
    throw UnimplementedError('아직 구현되지 않은 기능입니다.');
  }
}
