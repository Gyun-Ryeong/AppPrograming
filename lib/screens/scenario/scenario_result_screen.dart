// 시나리오 결과 화면 — AI가 생성한 시나리오 확인 후 대화 시작

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../models/scenario.dart';
import '../../router/app_router.dart';

class ScenarioResultScreen extends StatelessWidget {
  // 이전 화면(ScenarioInputScreen)에서 GoRouter extra로 전달받은 시나리오
  final Scenario scenario;

  const ScenarioResultScreen({super.key, required this.scenario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('시나리오 확인'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 시나리오 배경 카드
              _ScenarioCard(
                title: '상황 배경',
                content: scenario.background,
                icon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 16),

              // 역할 정보
              Row(
                children: [
                  Expanded(
                    child: _ScenarioCard(
                      title: '내 역할',
                      content: scenario.userRole,
                      icon: Icons.person_outline,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ScenarioCard(
                      title: 'AI 역할',
                      content: scenario.aiRole,
                      icon: Icons.smart_toy_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 대화 목표
              _ScenarioCard(
                title: '대화 목표',
                content: scenario.goal,
                icon: Icons.flag_outlined,
              ),
              const Spacer(),

              // 하단 버튼
              Row(
                children: [
                  // 다시 생성 버튼
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.refresh),
                      label: const Text(AppStrings.regenerate),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 대화 시작 버튼
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => context.push(
                        AppRoutes.conversation,
                        extra: scenario,
                      ),
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: const Text(AppStrings.startConversation),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 시나리오 정보 표시 카드 — 단일 책임 원칙
class _ScenarioCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const _ScenarioCard({
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 18),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
