// 대화 기록 상태 관리 — 세션별 대화 내역을 메모리에 보관

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/conversation_session.dart';

class HistoryNotifier extends Notifier<List<ConversationSession>> {
  @override
  List<ConversationSession> build() => [];

  /// 대화 종료 시 세션 추가 (최신 순으로 정렬)
  void addSession(ConversationSession session) {
    state = [session, ...state];
  }

  /// 전체 기록 삭제
  void clearHistory() => state = [];
}

final historyProvider =
    NotifierProvider<HistoryNotifier, List<ConversationSession>>(
        HistoryNotifier.new);
