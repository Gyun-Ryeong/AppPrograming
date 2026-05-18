// 앱 전체 라우팅 설정 — go_router 사용
// 인증 상태에 따라 로그인/홈 화면으로 자동 리디렉션

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/scenario/scenario_input_screen.dart';
import '../screens/scenario/scenario_result_screen.dart';
import '../screens/analysis/analysis_screen.dart';
import '../models/scenario.dart';

// 화면 경로 상수 — 문자열 하드코딩 금지
class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String home = '/';
  static const String scenarioInput = '/scenario/input';
  static const String scenarioResult = '/scenario/result';
  static const String conversation = '/conversation';
  static const String feedback = '/feedback';
  static const String history = '/history';
  static const String analysis = '/analysis';
}

// GoRouter 인스턴스 생성 — ref를 받아 authUserProvider 감시
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    // 인증 상태 변화 감지: 로그인/로그아웃 시 자동으로 redirect 재실행
    refreshListenable: GoRouterRefreshStream(
      ref.read(supabaseProvider).auth.onAuthStateChange,
    ),
    redirect: (context, state) {
      // 현재 로그인 여부 확인
      final user = Supabase.instance.client.auth.currentUser;
      final isLoggedIn = user != null;
      final isAuthRoute = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.signUp;

      // 비로그인 상태에서 인증 페이지 외 접근 → 로그인 화면으로
      if (!isLoggedIn && !isAuthRoute) return AppRoutes.login;
      // 로그인 상태에서 인증 페이지 접근 → 홈으로
      if (isLoggedIn && isAuthRoute) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.scenarioInput,
        builder: (context, state) => const ScenarioInputScreen(),
      ),
      GoRoute(
        path: AppRoutes.scenarioResult,
        builder: (context, state) {
          // 이전 화면에서 Scenario 객체를 extra로 전달받음
          final scenario = state.extra as Scenario;
          return ScenarioResultScreen(scenario: scenario);
        },
      ),
      GoRoute(
        path: AppRoutes.analysis,
        builder: (context, state) => const AnalysisScreen(),
      ),
      // TODO: conversation, feedback, history 화면은 팀원 B가 구현
      GoRoute(
        path: AppRoutes.history,
        builder: (context, state) => const _PlaceholderScreen(title: '대화 기록'),
      ),
      GoRoute(
        path: AppRoutes.conversation,
        builder: (context, state) => const _PlaceholderScreen(title: '대화'),
      ),
    ],
  );
}

// 팀원 B 담당 화면 임시 플레이스홀더
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title 화면 — 팀원 B 구현 예정')),
    );
  }
}

// GoRouter가 Stream 변화를 감지하도록 연결하는 헬퍼 클래스
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    (_subscription as dynamic).cancel();
    super.dispose();
  }
}
