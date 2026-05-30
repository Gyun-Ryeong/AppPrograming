# 팀원 B 작업 지시서

> 이 파일은 팀원 B의 Claude Code CLI가 읽는 작업 범위 문서다.
> 작업 시작 전 반드시 `AGENTS.md`도 함께 읽을 것.
> **작업 시작 전 `git pull origin main` 필수**

---

## 현재 프로젝트 상태 (2026-05-24 기준)

### 아키텍처 변경 사항 (중요)

> ⚠️ 당초 계획에서 **Supabase가 제거**되었다.
> Claude API를 Flutter 앱에서 `http` 패키지로 **직접 호출**하는 방식으로 변경됨.

| 항목 | 변경 전 | 변경 후 |
|------|---------|---------|
| 백엔드 | Supabase | 없음 (클라이언트 직접 호출) |
| AI 호출 | Supabase Edge Function | `http` 패키지로 Claude API 직접 호출 |
| 인증 | Supabase Auth | 없음 (인증 제거) |
| API 설정 | `supabase_config.dart` | `lib/constants/api_config.dart` |

### 현재 완료된 것

```
lib/
├── main.dart                    ✅ Riverpod + 테마 + go_router 연결
├── constants/
│   ├── app_colors.dart          ✅ 색상 상수
│   ├── app_strings.dart         ✅ 문자열 상수
│   └── api_config.dart          ✅ Claude API 키/모델/URL 설정
├── router/
│   └── app_router.dart          ✅ GoRouter 구현 완료
├── models/
│   ├── scenario.dart            ✅ 완성
│   ├── message.dart             ✅ 완성
│   └── feedback.dart            ✅ 완성
├── providers/
│   ├── auth_provider.dart       ✅ 완성 (인증 제거됨)
│   └── scenario_provider.dart   ✅ 완성
├── services/
│   └── scenario_service.dart    ✅ Claude API 직접 호출 구현 완료
├── screens/
│   ├── home/home_screen.dart    ✅ 완성
│   ├── scenario/                ✅ 입력/결과 화면 완성
│   └── analysis/                ✅ 분석 화면 완성
└── widgets/
    ├── chat_bubble.dart         ✅ 완성
    ├── primary_button.dart      ✅ 완성
    └── loading_overlay.dart     ✅ 완성
```

### 팀원 B가 구현해야 할 것 (미완성)

```
lib/
├── screens/
│   ├── conversation/
│   │   └── conversation_screen.dart   ❌ 플레이스홀더만 있음
│   ├── feedback/
│   │   └── feedback_screen.dart       ❌ 플레이스홀더만 있음
│   └── history/
│       ├── history_list_screen.dart   ❌ 없음
│       └── history_detail_screen.dart ❌ 없음
└── services/
    ├── conversation_service.dart      ❌ TODO 상태
    └── feedback_service.dart          ❌ TODO 상태
```

---

## Claude API 호출 패턴 (반드시 이 방식으로 구현)

`scenario_service.dart`가 이미 구현된 패턴을 그대로 따를 것.

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_config.dart';

// Claude API 호출 기본 구조
final response = await http.post(
  Uri.parse(ApiConfig.claudeApiUrl),
  headers: {
    'Content-Type': 'application/json',
    'x-api-key': ApiConfig.claudeApiKey,
    'anthropic-version': ApiConfig.anthropicVersion,
  },
  body: jsonEncode({
    'model': ApiConfig.claudeModel,
    'max_tokens': 1024,
    'messages': [...],
  }),
);
```

**API 키 설정:** `lib/constants/api_config.dart`의 `claudeApiKey`에 실제 키 입력
(console.anthropic.com에서 발급)

---

## app_router.dart 연동 방법

`conversation`과 `history` 경로가 이미 플레이스홀더로 잡혀있다.
화면 구현 후 `app_router.dart`에서 import 추가하고 플레이스홀더를 실제 화면으로 교체.

```dart
// 현재 (플레이스홀더)
GoRoute(
  path: AppRoutes.conversation,
  builder: (context, state) => const _PlaceholderScreen(title: '대화'),
),

// 구현 후 교체
GoRoute(
  path: AppRoutes.conversation,
  builder: (context, state) {
    final scenario = state.extra as Scenario;
    return ConversationScreen(scenario: scenario);
  },
),
```

---

## 12주차 작업 — 채팅 화면 + ConversationAgent

### conversation_service.dart 구현

`lib/services/conversation_service.dart`:

- 대화 히스토리(List<Message>)를 messages 배열로 변환해서 Claude에 전달
- 시스템 프롬프트에 시나리오 정보 포함

```
시스템 프롬프트:
You are an English conversation practice partner.
[Background]: {scenario.background}
[Your role]: {scenario.aiRole}
[User's role]: {scenario.userRole}
[Goal]: {scenario.goal}

Rules:
- Respond in English only
- Stay within the scenario context
- Match the user's English level
```

### conversation_screen.dart 화면 구조

```
┌─────────────────────────┐
│  시나리오 요약 (상단 카드) │
├─────────────────────────┤
│                         │
│   ListView.builder      │
│   (ChatBubble 위젯 반복) │
│   ↑ 역방향 스크롤        │
│                         │
├─────────────────────────┤
│ [TextField] [전송 버튼]  │
│ [대화 종료 버튼]          │
└─────────────────────────┘
```

- `ChatBubble` 위젯은 `lib/widgets/chat_bubble.dart`에 이미 구현됨
- `LoadingOverlay` 위젯은 `lib/widgets/loading_overlay.dart`에 이미 구현됨
- 대화 상태는 Riverpod `StateNotifierProvider`로 관리

---

## 13주차 작업 — 피드백 + 대화 기록

### feedback_service.dart 구현

대화 종료 시 전체 대화 내용을 FeedbackAgent에 전달:

```
프롬프트:
다음 영어 대화를 분석하고 아래 JSON 형식으로만 응답하세요:
{
  "naturalness_score": 85,
  "grammar_errors": [
    {"original": "I am go to school", "corrected": "I go to school", "explanation": "현재진행형 오용"}
  ],
  "expression_suggestions": [
    {"original": "very good", "suggestion": "excellent / outstanding", "reason": "더 자연스러운 표현"}
  ]
}
```

### feedback_screen.dart 화면 구조

```
┌─────────────────────────┐
│  자연스러움 점수: 85/100  │
├─────────────────────────┤
│  문법 오류 (Card 반복)   │
│  ❌ "I am go to school" │
│  ✅ "I go to school"    │
│  설명: 현재진행형 오용    │
├─────────────────────────┤
│  표현 개선 제안 (목록)   │
├─────────────────────────┤
│ [다시 연습] [홈으로]     │
└─────────────────────────┘
```

### 대화 기록 화면

데이터를 DB 없이 관리하는 방법 — 세션 데이터를 메모리(Riverpod)에 보관:
- `history_list_screen.dart`: 세션 목록 ListView
- `history_detail_screen.dart`: 과거 대화 + 피드백 상세

---

## 커밋 규칙

```bash
feat: 채팅 화면 UI 구현
feat: ConversationAgent 서비스 연동
feat: 피드백 결과 화면 구현
feat: 대화 기록 화면 구현
```

---

## WBS 작성 규칙

- 파일: `.planning/02-wbs-b.md` (팀원 B 담당 항목만)
- 시점: 매 주차 작업이 끝날 때 정리
- 합본: 발표 전 팀원 A의 `02-wbs-a.md`와 합쳐서 `02-wbs.md`로 통합

---

## Claude에게 요청할 때 유용한 프롬프트

```
AGENTS.md와 .github/agents/task-b.md를 읽었어.
지금 [채팅 화면 / ConversationAgent 서비스 / 피드백 화면 / 대화 기록] 구현을 도와줘.
코딩 규칙: 한국어 주석 필수, services/ 레이어 분리 원칙 지켜줘.
Claude API는 scenario_service.dart의 패턴을 그대로 따라줘.
```
