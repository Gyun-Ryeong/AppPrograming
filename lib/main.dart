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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      routerConfig: appRouter(),
    );
  }
}
