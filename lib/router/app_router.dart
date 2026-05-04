// go_router 기반 앱 라우팅 설정
// TODO: go_router 패키지 추가 후 구현 (pubspec.yaml에 go_router 추가 필요)

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

// TODO: GoRouter 인스턴스 설정
// final appRouter = GoRouter(
//   initialLocation: AppRoutes.home,
//   redirect: (context, state) {
//     // 인증 상태에 따른 리디렉션 처리
//   },
//   routes: [...],
// );
