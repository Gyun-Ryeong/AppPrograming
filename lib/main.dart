// MEF 앱 진입점 — Riverpod ProviderScope로 앱 실행

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'constants/app_colors.dart';
import 'router/app_router.dart';

void main() {
  runApp(
    // ProviderScope: Riverpod의 모든 Provider를 담는 최상위 컨테이너
    const ProviderScope(
      child: MefApp(),
    ),
  );
}

// 앱 루트 위젯
class MefApp extends StatelessWidget {
  const MefApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MEF - My English Friend',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      routerConfig: appRouter(),
    );
  }

  // 앱 전역 테마 설정
  ThemeData _buildTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      useMaterial3: true,
    );
  }
}
