// 대화 기록 상세 화면 — 과거 대화 내용 다시 보기

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/conversation_session.dart';
import '../../widgets/chat_bubble.dart';

class HistoryDetailScreen extends StatelessWidget {
  final ConversationSession session;

  const HistoryDetailScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('대화 상세'),
      ),
      body: Column(
        children: [
          // 시나리오 요약 카드
          _ScenarioSummaryCard(session: session),

          // 대화 메시지 목록
          Expanded(
            child: session.messages.isEmpty
                ? const Center(
                    child: Text(
                      '대화 내용이 없습니다.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: session.messages.length,
                    itemBuilder: (context, index) {
                      final message = session.messages[index];
                      return ChatBubble(
                        message: message.content,
                        isUser: message.isUser,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// 시나리오 요약 카드
class _ScenarioSummaryCard extends StatelessWidget {
  final ConversationSession session;

  const _ScenarioSummaryCard({required this.session});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: AppColors.primary.withValues(alpha: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            session.scenario.goal,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            session.scenario.background,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${session.userMessageCount}개 메시지',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
