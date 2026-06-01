# 팀원 A Claude CLI 브리핑

> 작성일: 2026-06-01
> 이 파일을 읽고 현재 프로젝트 상태를 파악할 것

---

## 긴급 — 지금 당장 해야 할 것

### api_config.dart 직접 생성 필요

이 파일은 `.gitignore`에 포함되어 git에 없음. 직접 만들어야 함.

파일 위치: `lib/constants/api_config.dart`

```dart
// ⚠️ 이 파일은 .gitignore에 포함됨 — 절대 git에 커밋하지 말 것

class ApiConfig {
  ApiConfig._();

  // Google AI Studio API 키 (aistudio.google.com에서 발급)
  static const String apiKey = '여기에_본인_API_키_입력';

  // Gemini 모델
  static const String model = 'gemini-2.5-flash';

  // Google AI Studio OpenAI 호환 엔드포인트
  static const String apiUrl = 'https://generativelanguage.googleapis.com/v1beta/openai/chat/completions';
}
```

---

## 현재 아키텍처 (최신)

| 항목 | 내용 |
|------|------|
| AI API | Google AI Studio (Gemini) — OpenAI 호환 엔드포인트 |
| 상태 관리 | Riverpod 메모리 (DB 없음) |
| 인증 | Mock 인증 (test@mef.com / test1234) |
| 라우팅 | go_router |

> ⚠️ Supabase 완전 제거됨. OpenRouter도 rate limit으로 Google AI Studio로 전환.

---

## 현재 구현 완료된 화면

| 화면 | 파일 | 담당 | 상태 |
|------|------|------|------|
| 홈 | `lib/screens/home/home_screen.dart` | A | ✅ |
| 로그인 | `lib/screens/auth/login_screen.dart` | A | ✅ |
| 회원가입 | `lib/screens/auth/signup_screen.dart` | A | ✅ |
| 시나리오 입력 | `lib/screens/scenario/scenario_input_screen.dart` | A | ✅ |
| 시나리오 결과 | `lib/screens/scenario/scenario_result_screen.dart` | A | ✅ |
| 채팅 | `lib/screens/conversation/conversation_screen.dart` | B | ✅ |
| 피드백 | `lib/screens/feedback/feedback_screen.dart` | A | ✅ |
| 대화 기록 | `lib/screens/history/history_screen.dart` | A | ✅ |
| 분석 | `lib/screens/analysis/analysis_screen.dart` | A | ✅ |

---

## 데모 흐름 (발표용)

```
홈 → 시나리오 입력 → 시나리오 결과 → 채팅 → 피드백 → 대화 기록
```

---

## 앱 실행 방법

```bash
git pull origin main

# api_config.dart 직접 생성 (위 내용 참고)

flutter pub get
flutter run -d chrome
```

---

## 현재 문제점

| 문제 | 원인 | 상태 |
|------|------|------|
| API 간헐적 429 | Gemini 무료 모델 rate limit | ⚠️ 시간대 따라 됨 |
| Flutter 웹 CORS | 외부 API 직접 호출 | ⚠️ 크롬에서도 됨 (429만 문제) |

---

## 발표 관련

- **발표일**: 오늘 (12주차 중간 발표)
- **형식**: 1인 7분 × 2명, Q&A 5분
- **대본**: `C:\AppPrograming\project\script.md` 참고
- **ADR 말하기 스크립트**: `mef/.planning/decisions/ADR-SPEECH.md` 참고
- **데모 백업**: API 안 될 경우 화면 설명으로 대체

---

## git 푸시 전 필수 확인

아래 파일이 `git status`에 나오면 절대 커밋하지 말 것:
- `lib/constants/api_config.dart` (API 키 포함)
- `lib/constants/supabase_config.dart`
