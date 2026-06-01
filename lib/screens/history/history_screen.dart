// 대화 기록 화면 — 과거 대화 세션 목록 표시

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../models/conversation_session.dart';
import '../../providers/history_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.history),
        actions: [
          if (sessions.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: '기록 삭제',
              onPressed: () => _confirmClear(context, ref),
            ),
        ],
      ),
      body: sessions.isEmpty
          ? const _EmptyView()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: sessions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) =>
                  _SessionCard(session: sessions[index]),
            ),
    );
  }

  // 기록 전체 삭제 확인 다이얼로그
  void _confirmClear(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('기록 삭제'),
        content: const Text('모든 대화 기록을 삭제할까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              ref.read(historyProvider.notifier).clearHistory();
              Navigator.pop(ctx);
            },
            child: const Text('삭제', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

// 대화 기록이 없을 때
class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: AppColors.textSecondary),
          SizedBox(height: 16),
          Text(
            '아직 대화 기록이 없습니다',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '새 대화를 시작해보세요!',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// 대화 세션 카드
class _SessionCard extends StatelessWidget {
  final ConversationSession session;

  const _SessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 시나리오 목표
            Text(
              session.scenario.goal,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            // 배경 설명
            Text(
              session.scenario.background,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            // 메타 정보 (날짜, 메시지 수)
            Row(
              children: [
                const Icon(Icons.access_time,
                    size: 13, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  _formatDate(session.createdAt),
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.chat_bubble_outline,
                    size: 13, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  '${session.userMessageCount}개 메시지',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // DateTime → "6월 1일 오후 2:30" 형식
  String _formatDate(DateTime dt) {
    final hour = dt.hour;
    final amPm = hour < 12 ? '오전' : '오후';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    return '${dt.month}월 ${dt.day}일 $amPm $displayHour:$minute';
  }
}
