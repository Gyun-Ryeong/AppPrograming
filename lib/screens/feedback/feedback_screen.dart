// 피드백 화면 — FeedbackAgent 결과 표시 (문법 오류, 표현 개선, 자연스러움 점수)

// material.dart의 Feedback 클래스와 충돌 방지
import 'package:flutter/material.dart' hide Feedback;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../models/feedback.dart';
import '../../models/message.dart';
import '../../models/scenario.dart';
import '../../providers/feedback_provider.dart';
import '../../router/app_router.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  final List<Message> messages;
  final Scenario scenario;

  const FeedbackScreen({
    super.key,
    required this.messages,
    required this.scenario,
  });

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  @override
  void initState() {
    super.initState();
    // 화면 진입 즉시 피드백 생성 요청
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(feedbackProvider.notifier)
          .generateFeedback(widget.messages);
    });
  }

  @override
  Widget build(BuildContext context) {
    final feedbackAsync = ref.watch(feedbackProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.feedbackTitle),
        automaticallyImplyLeading: false,
      ),
      body: feedbackAsync.when(
        loading: () => const _LoadingView(),
        error: (e, _) => _ErrorView(
          message: e.toString(),
          onRetry: () => ref
              .read(feedbackProvider.notifier)
              .generateFeedback(widget.messages),
        ),
        data: (feedback) {
          if (feedback == null) return const _LoadingView();
          return _FeedbackContent(
            feedback: feedback,
            scenario: widget.scenario,
          );
        },
      ),
    );
  }
}

// 피드백 생성 중 로딩 화면
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'AI가 대화를 분석하고 있습니다...',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

// 에러 화면
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      ),
    );
  }
}

// 피드백 본문 — 점수 카드 + 문법 오류 + 표현 제안 + 전체 코멘트
class _FeedbackContent extends ConsumerWidget {
  final Feedback feedback;
  final Scenario scenario;

  const _FeedbackContent({
    required this.feedback,
    required this.scenario,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 자연스러움 점수 카드
          _ScoreCard(score: feedback.naturalnessScore),
          const SizedBox(height: 16),

          // 전체 코멘트
          _SectionCard(
            icon: Icons.chat_bubble_outline,
            title: '종합 평가',
            child: Text(
              feedback.overallComment,
              style: const TextStyle(height: 1.5),
            ),
          ),
          const SizedBox(height: 16),

          // 문법 오류
          if (feedback.grammarErrors.isNotEmpty) ...[
            _SectionCard(
              icon: Icons.edit_note,
              title: AppStrings.grammarErrors,
              child: Column(
                children: feedback.grammarErrors
                    .map((e) => _GrammarErrorTile(error: e))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // 표현 개선 제안
          if (feedback.expressionSuggestions.isNotEmpty)
            _SectionCard(
              icon: Icons.lightbulb_outline,
              title: AppStrings.expressionSuggestions,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: feedback.expressionSuggestions
                    .map(
                      (s) => Chip(
                        label: Text(s, style: const TextStyle(fontSize: 13)),
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      ),
                    )
                    .toList(),
              ),
            ),

          const SizedBox(height: 32),

          // 하단 버튼
          ElevatedButton.icon(
            onPressed: () {
              ref.read(feedbackProvider.notifier).reset();
              context.go(AppRoutes.home);
            },
            icon: const Icon(Icons.home),
            label: const Text(AppStrings.goHome),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              ref.read(feedbackProvider.notifier).reset();
              context.go(AppRoutes.scenarioInput);
            },
            icon: const Icon(Icons.refresh),
            label: const Text(AppStrings.practiceAgain),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }
}

// 자연스러움 점수 카드
class _ScoreCard extends StatelessWidget {
  final int score;

  const _ScoreCard({required this.score});

  Color get _scoreColor {
    if (score >= 80) return Colors.green;
    if (score >= 60) return AppColors.primary;
    if (score >= 40) return Colors.orange;
    return AppColors.error;
  }

  String get _scoreLabel {
    if (score >= 80) return '훌륭해요!';
    if (score >= 60) return '잘 했어요!';
    if (score >= 40) return '계속 연습해요';
    return '더 노력해봐요';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // 원형 점수 표시
            SizedBox(
              width: 80,
              height: 80,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey.shade200,
                    color: _scoreColor,
                  ),
                  Text(
                    '$score',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _scoreColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppStrings.naturalnessScore,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _scoreLabel,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _scoreColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 섹션 카드 — 아이콘 + 제목 + 내용
class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

// 문법 오류 한 항목
class _GrammarErrorTile extends StatelessWidget {
  final GrammarError error;

  const _GrammarErrorTile({required this.error});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 틀린 문장 (취소선)
          Text(
            error.original,
            style: const TextStyle(
              decoration: TextDecoration.lineThrough,
              color: AppColors.error,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 2),
          // 수정된 문장
          Text(
            '→ ${error.corrected}',
            style: const TextStyle(
              color: Colors.green,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          // 설명
          Text(
            error.explanation,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const Divider(height: 16),
        ],
      ),
    );
  }
}
