// 홈 화면 — 로그인 후 첫 화면, 시나리오 생성 진입점
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mef/constants/app_colors.dart';
import 'package:mef/constants/app_strings.dart';
import 'package:mef/router/app_router.dart';
import 'package:mef/widgets/primary_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          // 대화 기록 버튼
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: AppStrings.history,
            onPressed: () => context.go(AppRoutes.history),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            // 앱 소개 텍스트
            Text(
              AppStrings.appFullName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '연습하고 싶은 상황을 입력하면\nAI가 맞춤 시나리오를 만들어드려요.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
            ),
            const SizedBox(height: 48),
            // 시나리오 생성 버튼
            PrimaryButton(
              label: AppStrings.generateScenario,
              onPressed: () => context.go(AppRoutes.scenarioInput),
            ),
            const SizedBox(height: 16),
            // 대화 기록 버튼
            OutlinedButton(
              onPressed: () => context.go(AppRoutes.history),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                side: const BorderSide(color: AppColors.primary),
              ),
              child: const Text(
                AppStrings.history,
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
