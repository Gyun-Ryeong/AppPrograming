# 12주차 중간 발표 브리핑

> 팀원 A에게 전달하는 현재까지 개발 현황 요약

---

## 현재 구현 완료된 전체 흐름

```
홈 화면 → 시나리오 입력 → 시나리오 결과 → 채팅 화면 → (피드백 플레이스홀더)
```

중간 발표에서 위 흐름을 데모로 보여줄 수 있음.

---

## 팀원 A 완료 항목

| 화면/기능 | 파일 | 상태 |
|----------|------|------|
| 홈 화면 | `lib/screens/home/home_screen.dart` | ✅ |
| 로그인 화면 | `lib/screens/auth/login_screen.dart` | ✅ |
| 회원가입 화면 | `lib/screens/auth/signup_screen.dart` | ✅ |
| 시나리오 입력 화면 | `lib/screens/scenario/scenario_input_screen.dart` | ✅ |
| 시나리오 결과 화면 | `lib/screens/scenario/scenario_result_screen.dart` | ✅ |
| 분석 화면 | `lib/screens/analysis/analysis_screen.dart` | ✅ |
| ScenarioAgent 서비스 | `lib/services/scenario_service.dart` | ✅ |
| 시나리오 Provider | `lib/providers/scenario_provider.dart` | ✅ |

---

## 팀원 B 완료 항목

| 화면/기능 | 파일 | 상태 |
|----------|------|------|
| 채팅 화면 | `lib/screens/conversation/conversation_screen.dart` | ✅ |
| ConversationAgent 서비스 | `lib/services/conversation_service.dart` | ✅ |
| 대화 상태 Provider | `lib/providers/conversation_provider.dart` | ✅ |
| 인증 Provider | `lib/providers/auth_provider.dart` | ✅ |
| 공통 위젯 3개 | `lib/widgets/` | ✅ |
| go_router 설정 | `lib/router/app_router.dart` | ✅ |

---

## 미구현 항목 (13주차 예정)

| 항목 | 파일 | 담당 |
|------|------|------|
| 피드백 화면 | `lib/screens/feedback/feedback_screen.dart` | 팀원 B |
| FeedbackAgent 서비스 | `lib/services/feedback_service.dart` | 팀원 B |
| 대화 기록 목록 | `lib/screens/history/history_list_screen.dart` | 팀원 B |
| 대화 기록 상세 | `lib/screens/history/history_detail_screen.dart` | 팀원 B |

---

## 현재 아키텍처 요약

| 항목 | 내용 |
|------|------|
| 프레임워크 | Flutter 3.35.3 / Dart 3.9.2 |
| 상태 관리 | Riverpod |
| 라우팅 | go_router |
| AI API | OpenRouter (meta-llama/llama-3.3-70b-instruct:free) |
| DB | 없음 — Riverpod 메모리만 사용 |
| 인증 | Mock (test@mef.com / test1234) |

---

## API 설정 방법 (팀원 각자 해야 할 것)

`lib/constants/api_config.dart` 파일은 `.gitignore`에 포함되어 **git에 올라가지 않음**.
각자 직접 생성해야 함:

```dart
class ApiConfig {
  ApiConfig._();
  static const String apiKey = '본인_OPENROUTER_API_KEY';
  static const String model = 'meta-llama/llama-3.3-70b-instruct:free';
  static const String apiUrl = 'https://openrouter.ai/api/v1/chat/completions';
}
```

---

## 발표 실행 방법

> ⚠️ Flutter 웹(크롬)은 CORS 문제로 API 호출 불가.
> **반드시 Windows 앱으로 실행할 것.**

```bash
git pull origin main
# api_config.dart 직접 생성 후
flutter run -d windows
```

---

## 발표 데모 시나리오

1. 앱 실행 → 홈 화면
2. "새 대화 시작" 클릭
3. 상황 입력 (예: "카페에서 음료 주문하기") → 난이도/카테고리 선택
4. "시나리오 생성" 클릭 → 결과 확인
5. "대화 시작" 클릭 → 채팅 화면
6. AI와 영어로 대화 진행
7. "대화 종료" 클릭 → (피드백은 13주차 구현 예정)
