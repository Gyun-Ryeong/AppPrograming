// ConversationAgent: 시나리오 맥락을 유지하며 실시간 대화 진행
// TODO: Supabase Edge Function 연동 후 구현

import '../models/message.dart';
import '../models/scenario.dart';

class ConversationService {
  static const String _functionUrl = 'https://<project>.supabase.co/functions/v1/conversation';

  /// 대화 히스토리와 새 메시지를 전송하고 AI 응답을 받는다
  Future<String> sendMessage({
    required Scenario scenario,
    required List<Message> history, // 이전 대화 히스토리
    required String userMessage,
  }) async {
    // TODO: POST _functionUrl 호출 구현
    throw UnimplementedError('아직 구현되지 않은 기능입니다.');
  }
}
