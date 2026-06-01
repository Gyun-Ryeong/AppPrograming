// 피드백 상태 관리 — FeedbackAgent 호출 결과를 AsyncValue로 관리

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/feedback.dart';
import '../models/message.dart';
import '../services/feedback_service.dart';

// FeedbackService 인스턴스 Provider
final feedbackServiceProvider =
    Provider<FeedbackService>((ref) => FeedbackService());

// 피드백 상태 — null: 미생성, Loading: 생성 중, Data: 완료, Error: 실패
class FeedbackNotifier extends AsyncNotifier<Feedback?> {
  @override
  Future<Feedback?> build() async => null;

  /// 대화 메시지 목록으로 피드백 생성 요청
  Future<void> generateFeedback(List<Message> messages) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(feedbackServiceProvider)
          .generateFeedback(messages: messages),
    );
  }

  /// 상태 초기화 (새 대화 시작 시)
  void reset() {
    state = const AsyncData(null);
  }
}

final feedbackProvider =
    AsyncNotifierProvider<FeedbackNotifier, Feedback?>(FeedbackNotifier.new);
