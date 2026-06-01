// 앱 전체 라우팅 설정 — go_router 사용

import 'package:go_router/go_router.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/scenario/scenario_input_screen.dart';
import '../screens/scenario/scenario_result_screen.dart';
import '../screens/analysis/analysis_screen.dart';
import '../screens/conversation/conversation_screen.dart';
import '../screens/feedback/feedback_screen.dart';
import '../screens/history/history_screen.dart';
import '../models/scenario.dart';
import '../models/message.dart';

// 화면 경로 상수 — 문자열 하드코딩 금지
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String scenarioInput = '/scenario/input';
  static const String scenarioResult = '/scenario/result';
  static const String conversation = '/conversation';
  static const String feedback = '/feedback';
  static const String history = '/history';
  static const String analysis = '/analysis';
}

// GoRouter 인스턴스
GoRouter appRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        name: 'home',
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        name: 'scenarioInput',
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
        path: AppRoutes.conversation,
        builder: (context, state) {
          final scenario = state.extra as Scenario;
          return ConversationScreen(scenario: scenario);
        },
      ),
      GoRoute(
        path: AppRoutes.feedback,
        builder: (context, state) {
          // ConversationScreen에서 {'messages': List<Message>, 'scenario': Scenario} 전달
          final extra = state.extra as Map<String, dynamic>;
          final messages = extra['messages'] as List<Message>;
          final scenario = extra['scenario'] as Scenario;
          return FeedbackScreen(messages: messages, scenario: scenario);
        },
      ),
      GoRoute(
        path: AppRoutes.history,
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.analysis,
        builder: (context, state) => const AnalysisScreen(),
      ),
    ],
  );
}
