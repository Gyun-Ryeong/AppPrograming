// FeedbackAgent: 대화 종료 후 문법/표현/자연스러움 종합 피드백 생성
// TODO: Supabase Edge Function 연동 후 구현

import '../models/feedback.dart';
import '../models/message.dart';

class FeedbackService {
  static const String _functionUrl = 'https://<project>.supabase.co/functions/v1/feedback';

  /// 전체 대화 내용을 분석해 피드백을 생성한다
  Future<Feedback> generateFeedback({
    required List<Message> messages,
  }) async {
    // TODO: POST _functionUrl 호출 구현
    throw UnimplementedError('아직 구현되지 않은 기능입니다.');
  }
}
