// 약점 분석 화면 — AnalysisAgent 결과 표시 (누적 대화 기반 약점 패턴)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../models/analysis_report.dart';
import '../../providers/analysis_provider.dart';
import '../../providers/history_provider.dart';

class AnalysisScreen extends ConsumerWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisAsync = ref.watch(analysisProvider);
    final sessions = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.analysis),
      ),
      body: analysisAsync.when(
        // 미실행 상태 — 분석 시작 버튼
        data: (report) => report == null
            ? _IdleView(
                sessionCount: sessions.length,
                onAnalyze: () =>
                    ref.read(analysisProvider.notifier).analyze(sessions),
              )
            : _ReportView(report: report, onReset: () => ref.read(analysisProvider.notifier).reset()),
        loading: () => const _LoadingView(),
        error: (e, _) => _ErrorView(
          message: e.toString(),
          onRetry: () =>
              ref.read(analysisProvider.notifier).analyze(sessions),
        ),
      ),
    );
  }
}

// 분석 전 초기 화면
class _IdleView extends StatelessWidget {
  final int sessionCount;
  final VoidCallback onAnalyze;

  const _IdleView({required this.sessionCount, required this.onAnalyze});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.analytics_outlined,
                size: 72, color: AppColors.primary),
            const SizedBox(height: 24),
            const Text(
              '약점 분석',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            Text(
              sessionCount == 0
                  ? '아직 대화 기록이 없습니다.\n먼저 대화 연습을 해보세요!'
                  : '대화 $sessionCount회 기록을 AI가 분석해\n나의 영어 약점 패턴을 알려드립니다.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.textSecondary, height: 1.6),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: sessionCount == 0 ? null : onAnalyze,
              icon: const Icon(Icons.search),
              label: const Text('약점 분석 시작'),
            ),
          ],
        ),
      ),
    );
  }
}

// 분석 중 로딩 화면
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
          Text('AI가 대화 기록을 분석하고 있습니다...',
              style: TextStyle(color: AppColors.textSecondary)),
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
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      ),
    );
  }
}

// 분석 결과 화면
class _ReportView extends StatelessWidget {
  final AnalysisReport report;
  final VoidCallback onReset;

  const _ReportView({required this.report, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 요약 카드
          _SummaryCard(report: report),
          const SizedBox(height: 16),

          // 약점 패턴 목록
          if (report.weaknessPatterns.isNotEmpty) ...[
            const _SectionHeader(icon: Icons.warning_amber, title: '주요 약점 패턴'),
            const SizedBox(height: 8),
            ...report.weaknessPatterns
                .map((p) => _WeaknessCard(pattern: p)),
            const SizedBox(height: 16),
          ],

          // 추천 연습 상황
          _RecommendCard(scenario: report.recommendedScenario),
          const SizedBox(height: 24),

          // 다시 분석 버튼
          OutlinedButton.icon(
            onPressed: onReset,
            icon: const Icon(Icons.refresh),
            label: const Text('다시 분석'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }
}

// 요약 카드 — 세션 수 + 개선 추세
class _SummaryCard extends StatelessWidget {
  final AnalysisReport report;

  const _SummaryCard({required this.report});

  IconData get _trendIcon {
    switch (report.improvementTrend) {
      case 'improving':
        return Icons.trending_up;
      case 'declining':
        return Icons.trending_down;
      default:
        return Icons.trending_flat;
    }
  }

  Color get _trendColor {
    switch (report.improvementTrend) {
      case 'improving':
        return Colors.green;
      case 'declining':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }

  String get _trendLabel {
    switch (report.improvementTrend) {
      case 'improving':
        return '실력 향상 중';
      case 'declining':
        return '더 연습이 필요해요';
      default:
        return '안정적인 수준';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // 총 세션 수
            Expanded(
              child: Column(
                children: [
                  Text(
                    '${report.totalSessions}',
                    style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary),
                  ),
                  const Text('총 대화 세션',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            Container(width: 1, height: 48, color: Colors.grey.shade200),
            // 개선 추세
            Expanded(
              child: Column(
                children: [
                  Icon(_trendIcon, size: 36, color: _trendColor),
                  Text(_trendLabel,
                      style: TextStyle(color: _trendColor, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 섹션 헤더
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15)),
      ],
    );
  }
}

// 약점 패턴 카드
class _WeaknessCard extends StatelessWidget {
  final WeaknessPattern pattern;

  const _WeaknessCard({required this.pattern});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 카테고리 + 빈도 바
            Row(
              children: [
                Expanded(
                  child: Text(pattern.category,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                Text(
                  '${(pattern.frequency * 100).round()}%',
                  style: const TextStyle(
                      color: AppColors.error, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 빈도 프로그레스 바
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pattern.frequency,
                backgroundColor: Colors.grey.shade200,
                color: AppColors.error,
                minHeight: 6,
              ),
            ),
            // 예시 문장
            if (pattern.examples.isNotEmpty) ...[
              const SizedBox(height: 10),
              ...pattern.examples.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '• $e',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// 추천 연습 카드
class _RecommendCard extends StatelessWidget {
  final String scenario;

  const _RecommendCard({required this.scenario});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primary.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.lightbulb_outline, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('추천 연습 상황',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(scenario,
                      style: const TextStyle(height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
