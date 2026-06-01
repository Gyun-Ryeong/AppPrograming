// 약점 분석 상태 관리 — AnalysisAgent 호출 결과를 AsyncValue로 관리

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/analysis_report.dart';
import '../models/conversation_session.dart';
import '../services/analysis_service.dart';

// AnalysisService 인스턴스 Provider
final analysisServiceProvider =
    Provider<AnalysisService>((ref) => AnalysisService());

// 분석 상태 — null: 미실행, Loading: 분석 중, Data: 완료, Error: 실패
class AnalysisNotifier extends AsyncNotifier<AnalysisReport?> {
  @override
  Future<AnalysisReport?> build() async => null;

  /// 누적 대화 세션으로 약점 분석 요청
  Future<void> analyze(List<ConversationSession> sessions) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(analysisServiceProvider)
          .getAnalysisReport(sessions: sessions),
    );
  }

  void reset() => state = const AsyncData(null);
}

final analysisProvider =
    AsyncNotifierProvider<AnalysisNotifier, AnalysisReport?>(
        AnalysisNotifier.new);
