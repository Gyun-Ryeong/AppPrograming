# 팀원 B 작업 지시서

> 이 파일은 팀원 B의 Claude Code CLI가 읽는 작업 범위 문서다.
> 작업 시작 전 반드시 `AGENTS.md`도 함께 읽을 것.

---

## 담당 범위

| 주차 | 작업 | 핵심 파일 |
|------|------|-----------|
| 1주차 | DB 스키마 설계 (Supabase) | Supabase 콘솔 |
| 1주차 | go_router 네비게이션 설정 | `lib/router/app_router.dart` |
| 1주차 | 공통 위젯 + 앱 테마 설정 | `lib/widgets/`, `lib/main.dart` |
| 3주차 | 채팅 화면 UI | `lib/screens/conversation/` |
| 3주차 | ConversationAgent 프롬프트 설계 + 서비스 구현 | `lib/services/conversation_service.dart` |
| 4주차 | FeedbackAgent 구현 + 피드백 결과 화면 | `lib/screens/feedback/`, `lib/services/feedback_service.dart` |
| 4주차 | 대화 기록 목록 + 상세 화면 | `lib/screens/history/` |

---

## 현재 상태

### 이미 만들어진 파일 (뼈대만 있음, 구현 필요)

```
lib/
├── screens/conversation/   ← 비어 있음, 화면 위젯 새로 작성
├── screens/feedback/       ← 비어 있음, 화면 위젯 새로 작성
├── screens/history/        ← 비어 있음, 화면 위젯 새로 작성
├── screens/home/           ← 비어 있음, 홈 화면 새로 작성
├── services/conversation_service.dart ← TODO만 있음, 구현 필요
├── services/feedback_service.dart     ← TODO만 있음, 구현 필요
├── router/app_router.dart  ← 경로 상수만 있음, GoRouter 인스턴스 구현 필요
├── widgets/                ← 비어 있음, 공통 위젯 새로 작성
└── models/
    ├── message.dart         ← 완성됨, 수정 불필요
    └── feedback.dart        ← 완성됨, 수정 불필요
```

### 아직 만들어지지 않은 것 (새로 작성 필요)

- `lib/screens/home/home_screen.dart`
- `lib/screens/conversation/conversation_screen.dart`
- `lib/screens/feedback/feedback_screen.dart`
- `lib/screens/history/history_list_screen.dart`
- `lib/screens/history/history_detail_screen.dart`
- `lib/widgets/chat_bubble.dart` (말풍선 위젯)
- `lib/widgets/primary_button.dart` (공통 버튼)
- `lib/widgets/loading_overlay.dart` (로딩 오버레이)

---

## 1주차 우선순위 작업

### Step 1 — pubspec.yaml에 패키지 추가

```yaml
dependencies:
  supabase_flutter: ^2.0.0
  flutter_riverpod: ^2.0.0
  go_router: ^14.0.0
```

```bash
flutter pub get
```

### Step 2 — Supabase DB 스키마 설계

Supabase 콘솔 SQL 에디터에서 아래 테이블 생성:

```sql
-- 대화 세션
create table sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id),
  situation_input text not null,
  scenario jsonb,
  status text default 'active',
  started_at timestamptz default now(),
  ended_at timestamptz
);

-- 대화 메시지
create table messages (
  id uuid primary key default gen_random_uuid(),
  session_id uuid references sessions(id),
  role text not null,      -- 'user' 또는 'assistant'
  content text not null,
  created_at timestamptz default now()
);

-- 피드백
create table feedbacks (
  id uuid primary key default gen_random_uuid(),
  session_id uuid references sessions(id),
  grammar_errors jsonb,
  expression_suggestions jsonb,
  naturalness_score int,
  created_at timestamptz default now()
);
```

### Step 3 — go_router 설정

`lib/router/app_router.dart` 구현:

```dart
// GoRouter 인스턴스 생성
// 인증 상태에 따른 redirect 처리
// 각 화면으로 가는 routes 정의
final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  redirect: (context, state) {
    // authProvider 상태 확인
    // 미로그인 → /login 리디렉션
  },
  routes: [
    GoRoute(path: AppRoutes.login, ...),
    GoRoute(path: AppRoutes.home, ...),
    GoRoute(path: AppRoutes.conversation, ...),
    // ...
  ],
);
```

### Step 4 — 공통 위젯 작성

**말풍선 위젯** (`lib/widgets/chat_bubble.dart`):
- `isUser` 값으로 좌/우 정렬
- 사용자: `AppColors.bubbleUser` (파란색, 오른쪽)
- AI: `AppColors.bubbleAI` (회색, 왼쪽)

**공통 버튼** (`lib/widgets/primary_button.dart`):
- `AppColors.primary` 색상
- 로딩 중 `CircularProgressIndicator` 표시

### Step 5 — 앱 테마 설정

`lib/main.dart`에 `ThemeData` 적용:
- Primary color: `AppColors.primary`
- 폰트, 버튼 스타일 등 전역 설정

---

## 3주차 우선순위 작업

### 채팅 화면 UI 구성

`lib/screens/conversation/conversation_screen.dart`:

```
화면 구조:
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

### ConversationAgent 프롬프트 설계 방향

```
시스템 프롬프트:
당신은 영어 회화 연습 파트너입니다.
[시나리오 배경]: {scenario.background}
[당신의 역할]: {scenario.aiRole}
[사용자 역할]: {scenario.userRole}
[대화 목표]: {scenario.goal}

규칙:
- 영어로만 대화한다
- 시나리오 맥락을 벗어나지 않는다
- 사용자 영어 수준에 맞게 응답한다
```

---

## 4주차 우선순위 작업

### 피드백 화면 UI 구성

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

- `ListView.builder`로 세션 목록 표시
- 각 항목: 날짜 + 시나리오 요약 + 점수
- 탭하면 상세 화면(과거 대화 + 피드백) 이동

---

## 팀원 A와 연동 지점

팀원 A가 만드는 것을 아래처럼 사용한다:

| 연동 포인트 | 팀원 A가 제공 | 내가 사용하는 방식 |
|------------|-------------|-------------------|
| 인증 상태 | `AuthProvider` (Riverpod) | `ref.watch(authProvider)` |
| 시나리오 데이터 | `Scenario` 모델 | `ConversationScreen(scenario: scenario)` |
| 라우팅 상수 | `AppRoutes` | `context.go(AppRoutes.conversation)` |

**팀원 A 작업 완료 전에 내가 먼저 해야 할 것:**
- go_router, 테마, 공통 위젯 설정 (팀원 A 화면 구현에도 필요)
- DB 스키마 생성 (팀원 A Supabase Auth 설정 시 함께 필요)

---

## 커밋 규칙

```bash
# 커밋 메시지 형식
feat: go_router 네비게이션 설정
feat: 채팅 화면 UI 구현
feat: ConversationAgent 서비스 연동
feat: 피드백 결과 화면 구현
```

브랜치 전략:
```bash
git checkout -b feat/navigation     # 라우터 작업
git checkout -b feat/conversation   # 대화 화면 작업
git checkout -b feat/feedback       # 피드백 작업
```

---

## Claude에게 요청할 때 유용한 프롬프트

```
AGENTS.md와 .github/agents/task-b.md를 읽었어.
지금 [채팅 화면 / ConversationAgent 서비스 / 피드백 화면 / go_router] 구현을 도와줘.
코딩 규칙: 한국어 주석 필수, services/ 레이어 분리 원칙 지켜줘.
```
