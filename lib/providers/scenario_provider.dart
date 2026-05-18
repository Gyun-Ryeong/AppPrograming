// 시나리오 생성 상태 관리 — ScenarioService 호출 결과를 Riverpod으로 관리

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/scenario.dart';
import '../services/scenario_service.dart';

// ScenarioService 인스턴스를 Provider로 노출
final scenarioServiceProvider = Provider<ScenarioService>((ref) {
  return ScenarioService();
});

// 시나리오 생성 액션 + 상태 관리
class ScenarioGenerateNotifier extends Notifier<AsyncValue<Scenario?>> {
  @override
  AsyncValue<Scenario?> build() => const AsyncValue.data(null);

  // 시나리오 생성 요청 → ScenarioService 호출
  Future<Scenario?> generate({
    required String situation,
    required String difficulty,
    required String category,
  }) async {
    state = const AsyncValue.loading();

    final result = await AsyncValue.guard(() async {
      return ref.read(scenarioServiceProvider).generateScenario(
            situation: situation,
            difficulty: difficulty,
            category: category,
          );
    });

    state = result;
    return result.valueOrNull;
  }
}

final scenarioGenerateProvider =
    NotifierProvider<ScenarioGenerateNotifier, AsyncValue<Scenario?>>(
        ScenarioGenerateNotifier.new);
