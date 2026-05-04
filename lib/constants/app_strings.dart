// 앱 UI 문자열 상수 — 하드코딩 금지, 여기서만 정의한다

class AppStrings {
  AppStrings._();

  // 앱 공통
  static const String appName = 'MEF';
  static const String appFullName = 'My English Friend';

  // 인증
  static const String login = '로그인';
  static const String signUp = '회원가입';
  static const String email = '이메일';
  static const String password = '비밀번호';
  static const String logout = '로그아웃';

  // 시나리오
  static const String scenarioInputHint = '연습하고 싶은 상황을 입력하세요\n예: 카페에서 음료 주문하기';
  static const String generateScenario = '시나리오 생성';
  static const String startConversation = '대화 시작';
  static const String regenerate = '다시 생성';

  // 대화
  static const String endConversation = '대화 종료';
  static const String messagePlaceholder = '메시지를 입력하세요...';
  static const String send = '전송';

  // 피드백
  static const String feedbackTitle = '대화 피드백';
  static const String grammarErrors = '문법 오류';
  static const String expressionSuggestions = '표현 개선';
  static const String naturalnessScore = '자연스러움 점수';
  static const String practiceAgain = '다시 연습하기';
  static const String goHome = '홈으로';

  // 기록
  static const String history = '대화 기록';

  // 분석 (유료)
  static const String analysis = '약점 분석';
  static const String premiumFeature = '유료 기능';
  static const String premiumDescription = '누적 대화 데이터를 분석해 내 영어 약점을 알려드립니다.';
}
