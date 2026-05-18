// go_router 기반 앱 라우팅 설정
import 'package:go_router/go_router.dart';
import 'package:mef/screens/home/home_screen.dart';

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
  static const String historyDetail = '/history/:id';
  static const String analysis = '/analysis';
}

/// 앱 전체 라우터 인스턴스
/// 팀원 A의 AuthProvider 연동 후 redirect에 인증 상태 확인 추가 예정
final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  // TODO: 팀원 A의 authProvider 완성 후 아래 redirect 활성화
  // redirect: (context, state) {
  //   final isLoggedIn = ref.read(authProvider).isLoggedIn;
  //   final isLoginPage = state.matchedLocation == AppRoutes.login;
  //   if (!isLoggedIn && !isLoginPage) return AppRoutes.login;
  //   if (isLoggedIn && isLoginPage) return AppRoutes.home;
  //   return null;
  // },
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    // TODO: 팀원 A 작업 완료 후 아래 경로 추가
    // GoRoute(path: AppRoutes.login, builder: ...),
    // GoRoute(path: AppRoutes.signUp, builder: ...),
    // GoRoute(path: AppRoutes.scenarioInput, builder: ...),
    // GoRoute(path: AppRoutes.scenarioResult, builder: ...),
    // GoRoute(path: AppRoutes.conversation, builder: ...),
    // GoRoute(path: AppRoutes.feedback, builder: ...),
    // GoRoute(path: AppRoutes.history, builder: ...),
    // GoRoute(path: AppRoutes.analysis, builder: ...),
  ],
);
