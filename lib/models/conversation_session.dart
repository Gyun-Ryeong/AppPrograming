// 대화 세션 모델 — 히스토리에 저장되는 한 번의 대화 기록

import 'message.dart';
import 'scenario.dart';

class ConversationSession {
  final String id;
  final Scenario scenario;
  final List<Message> messages;
  final DateTime createdAt;

  ConversationSession({
    required this.id,
    required this.scenario,
    required this.messages,
    required this.createdAt,
  });

  // 사용자 메시지 수 (대화 분량 표시용)
  int get userMessageCount => messages.where((m) => m.isUser).length;
}
