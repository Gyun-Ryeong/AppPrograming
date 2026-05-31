// 대화 상태 관리 — 메시지 목록 + 로딩 상태를 Riverpod으로 관리

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/message.dart';
import '../models/scenario.dart';
import '../services/conversation_service.dart';

// ConversationService 인스턴스 Provider
final conversationServiceProvider = Provider<ConversationService>((ref) {
  return ConversationService();
});

// 대화 메시지 목록 상태 관리
class ConversationNotifier extends Notifier<List<Message>> {
  @override
  List<Message> build() => [];

  /// 사용자 메시지 전송 + AI 응답 수신
  Future<void> sendMessage({
    required Scenario scenario,
    required String userMessage,
  }) async {
    // 사용자 메시지 즉시 추가
    final userMsg = Message(
      role: 'user',
      content: userMessage,
      createdAt: DateTime.now(),
    );
    state = [...state, userMsg];

    // Claude API 호출
    final aiText = await ref.read(conversationServiceProvider).sendMessage(
          scenario: scenario,
          history: state.sublist(0, state.length - 1), // 방금 추가한 것 제외
          userMessage: userMessage,
        );

    // AI 응답 추가
    final aiMsg = Message(
      role: 'assistant',
      content: aiText,
      createdAt: DateTime.now(),
    );
    state = [...state, aiMsg];
  }

  /// 대화 초기화 (새 세션 시작)
  void reset() => state = [];
}

final conversationProvider =
    NotifierProvider<ConversationNotifier, List<Message>>(
        ConversationNotifier.new);

// 로딩 상태 Provider (전송 중 여부)
final conversationLoadingProvider = StateProvider<bool>((ref) => false);
