// ScenarioAgent: 사용자 상황 입력 → Supabase Edge Function 호출 → 시나리오 생성

import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/scenario.dart';

class ScenarioService {
  // Supabase Edge Function 이름 (supabase/functions/scenario/index.ts 로 배포)
  static const String _functionName = 'scenario';

  /// 사용자가 입력한 상황으로 AI 시나리오를 생성한다.
  ///
  /// [situation] — 사용자가 입력한 상황 (예: "카페에서 음료 주문")
  /// [difficulty] — 'beginner' | 'intermediate' | 'advanced'
  /// [category] — 'daily' | 'business' | 'travel' | 'academic'
  Future<Scenario> generateScenario({
    required String situation,
    required String difficulty,
    required String category,
  }) async {
    // Supabase Edge Function 호출 — API 키는 서버에서만 관리
    final response = await Supabase.instance.client.functions.invoke(
      _functionName,
      body: {
        'situation': situation,
        'difficulty': difficulty,
        'category': category,
      },
    );

    // Edge Function 응답 데이터를 Scenario 모델로 변환
    final data = response.data as Map<String, dynamic>;
    return Scenario.fromJson(data);
  }
}
