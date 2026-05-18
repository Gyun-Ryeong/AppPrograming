// MEF 앱 진입점 — Supabase 초기화 후 Riverpod ProviderScope로 앱 실행

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'constants/app_colors.dart';
import 'constants/supabase_config.dart';
import 'router/app_router.dart';

Future<void> main() async {
  // Flutter 엔진 초기화 (비동기 작업 전 필수)
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase 초기화 — 인증 + DB + Edge Function 사용 준비
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  runApp(
    // ProviderScope: Riverpod의 모든 Provider를 담는 최상위 컨테이너
    const ProviderScope(
      child: MefApp(),
    ),
  );
}

// 앱 루트 위젯 — ConsumerWidget으로 Riverpod 사용
class MefApp extends ConsumerWidget {
  const MefApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'MEF - My English Friend',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      // go_router 설정 연결
      routerConfig: appRouter(ref),
    );
  }
}
