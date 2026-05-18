// 약점 분석 화면 — AnalysisAgent 결과 표시 (14주차 구현 예정)

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.analysis),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics_outlined, size: 64, color: AppColors.primary),
            SizedBox(height: 16),
            Text(
              AppStrings.premiumFeature,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                AppStrings.premiumDescription,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            // TODO: 14주차에 AnalysisAgent 연동 및 차트 구현
          ],
        ),
      ),
    );
  }
}
