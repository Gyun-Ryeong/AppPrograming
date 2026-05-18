// 홈 화면 — 앱 시작 시 첫 화면, 시나리오 생성 버튼 제공

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../router/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 환영 메시지
              const Text(
                '안녕하세요!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '오늘도 영어 회화를 연습해 보세요!',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 40),

              // 새 대화 시작 카드
              _MenuCard(
                icon: Icons.add_circle_outline,
                title: '새 대화 시작',
                description: '연습할 상황을 입력하면 AI가 시나리오를 생성합니다',
                onTap: () => context.push(AppRoutes.scenarioInput),
              ),
              const SizedBox(height: 16),

              // 대화 기록 카드
              _MenuCard(
                icon: Icons.history,
                title: AppStrings.history,
                description: '지난 대화 기록과 피드백을 확인합니다',
                onTap: () => context.push(AppRoutes.history),
              ),
              const SizedBox(height: 16),

              // 약점 분석 카드 (유료)
              _MenuCard(
                icon: Icons.analytics_outlined,
                title: AppStrings.analysis,
                description: AppStrings.premiumDescription,
                isPremium: true,
                onTap: () => context.push(AppRoutes.analysis),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 홈 화면 메뉴 카드 — 단일 책임 원칙으로 분리
class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isPremium;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    this.isPremium = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary, size: 32),
        title: Row(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            if (isPremium) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'PRO',
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(
          description,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
