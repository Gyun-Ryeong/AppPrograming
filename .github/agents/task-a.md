# 팀원 A 작업 지시서

> 이 파일은 팀원 A의 Claude Code CLI가 읽는 작업 범위 문서다.
> 작업 시작 전 반드시 `AGENTS.md`도 함께 읽을 것.

---

## 담당 범위

| 주차 | 작업 | 핵심 파일 |
|------|------|-----------|
| 1주차 | Supabase 프로젝트 설정 + 로그인/회원가입 화면 | `lib/screens/auth/` |
| 1주차 | Supabase Auth 연동 (이메일/비밀번호) | `lib/providers/auth_provider.dart` |
| 2주차 | 상황 입력 화면 UI | `lib/screens/scenario/` |
| 2주차 | ScenarioAgent 프롬프트 설계 + 서비스 구현 | `lib/services/scenario_service.dart` |
| 2주차 | 시나리오 결과 확인 화면 | `lib/screens/scenario/` |
| 6주차 | AnalysisAgent 구현 + 약점 분석 화면 | `lib/screens/analysis/`, `lib/services/analysis_service.dart` |

---

## 현재 상태

### 이미 만들어진 파일 (뼈대만 있음, 구현 필요)

```
lib/
├── screens/auth/           ← 비어 있음, 화면 위젯 새로 작성
├── screens/scenario/       ← 비어 있음, 화면 위젯 새로 작성
├── screens/analysis/       ← 비어 있음, 화면 위젯 새로 작성
├── services/scenario_service.dart   ← TODO만 있음, 구현 필요
├── services/analysis_service.dart   ← TODO만 있음, 구현 필요
├── providers/auth_provider.dart     ← TODO만 있음, 구현 필요
└── models/
    ├── scenario.dart        ← 완성됨, 수정 불필요
    └── analysis_report.dart ← 완성됨, 수정 불필요
```

### 아직 만들어지지 않은 것 (새로 작성 필요)

- `lib/screens/auth/login_screen.dart`
- `lib/screens/auth/signup_screen.dart`
- `lib/screens/scenario/scenario_input_screen.dart`
- `lib/screens/scenario/scenario_result_screen.dart`
- `lib/screens/analysis/analysis_screen.dart`

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

### Step 2 — Supabase 프로젝트 설정

1. [supabase.com](https://supabase.com) 에서 새 프로젝트 생성
2. `Project URL`과 `anon key` 복사
3. `lib/main.dart`에 Supabase 초기화 코드 추가:

```dart
// main.dart 초기화 예시
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',      // 환경변수로 관리할 것
  anonKey: 'YOUR_SUPABASE_ANON_KEY',
);
```

> ⚠️ URL과 키는 절대 git에 커밋하지 않는다. `.env` 파일 또는 별도 config 파일로 관리.

### Step 3 — 로그인 화면 구현

`lib/screens/auth/login_screen.dart` 생성:
- 이메일 입력 TextField
- 비밀번호 입력 TextField
- 로그인 버튼 → `supabase.auth.signInWithPassword()` 호출
- 회원가입 화면으로 이동 링크

### Step 4 — 회원가입 화면 구현

`lib/screens/auth/signup_screen.dart` 생성:
- 이메일 / 비밀번호 입력
- 회원가입 버튼 → `supabase.auth.signUp()` 호출

### Step 5 — auth_provider.dart 구현

```dart
// Riverpod으로 인증 상태 관리
// supabase.auth.onAuthStateChange 스트림 감시
// 로그인/로그아웃 상태에 따라 라우터 리디렉션
```

---

## 2주차 우선순위 작업

### ScenarioAgent 프롬프트 설계 방향

Supabase Edge Function에 전달할 시스템 프롬프트 초안:

```
당신은 영어 회화 연습을 위한 시나리오 생성 AI입니다.
사용자가 입력한 상황을 바탕으로 아래 JSON 형식으로 시나리오를 생성하세요:
{
  "background": "상황 배경 설명 (영어)",
  "user_role": "사용자 역할 (영어)",
  "ai_role": "AI 파트너 역할 (영어)",
  "goal": "대화 목표 (영어)"
}
난이도: [beginner/intermediate/advanced]
카테고리: [daily/business/travel/academic]
```

### 상황 입력 화면 UI 구성

- `TextField` — 상황 자유 입력
- `SegmentedButton` 또는 `ChoiceChip` — 난이도 선택
- `Wrap + ChoiceChip` — 카테고리 선택
- "시나리오 생성" 버튼 → `scenario_service.dart` 호출
- 로딩 중 `CircularProgressIndicator` 표시

---

## 팀원 B와 연동 지점

팀원 B가 만드는 것과 아래 인터페이스가 맞아야 한다:

| 연동 포인트 | 내가 제공하는 것 | 팀원 B가 사용하는 것 |
|------------|----------------|---------------------|
| 인증 상태 | `AuthProvider` (Riverpod) | 모든 화면에서 `ref.watch(authProvider)` |
| 시나리오 데이터 | `Scenario` 모델 (`lib/models/scenario.dart`) | `ConversationScreen`에 전달 |
| 라우팅 | `AppRoutes` 상수 (`lib/router/app_router.dart`) | 팀원 B와 함께 정의 |

---

## 커밋 규칙

```bash
# 커밋 메시지 형식
feat: 로그인 화면 구현
feat: ScenarioAgent 서비스 연동
fix: Supabase Auth 토큰 갱신 오류 수정
```

브랜치 전략:
```bash
git checkout -b feat/auth        # 인증 작업
git checkout -b feat/scenario    # 시나리오 작업
```

---

## Claude에게 요청할 때 유용한 프롬프트

```
AGENTS.md와 .github/agents/task-a.md를 읽었어.
지금 [로그인 화면 / ScenarioAgent 서비스 / auth_provider] 구현을 도와줘.
코딩 규칙: 한국어 주석 필수, services/ 레이어 분리 원칙 지켜줘.
```
