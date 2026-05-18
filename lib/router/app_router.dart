// 앱 전체 라우팅 설정 — go_router 사용

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/home/home_screen.dart';
import '../screens/scenario/scenario_input_screen.dart';
import '../screens/scenario/scenario_result_screen.dart';
import '../screens/analysis/analysis_screen.dart';
import '../models/scenario.dart';

// 화면 경로 상수 — 문자열 하드코딩 금지
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String scenarioInput = '/scenario/input';
  static const String scenarioResult = '/scenario/result';
  static const String conversation = '/conversation';
  static const String feedback = '/feedback';
  static const String history = '/history';
  static const String analysis = '/analysis';
}

// GoRouter 인스턴스 — 인증 없이 홈에서 바로 시작
GoRouter appRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
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
