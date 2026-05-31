# WBS — 팀원 A 작업 현황

> 최종 업데이트: 2026-05-31

---

## 전체 진행률

```
11주차  ████████████████████  100%  완료
12주차  ████████████████████  100%  완료
14주차  ░░░░░░░░░░░░░░░░░░░░    0%  미시작
```

---

## 11주차 — 완료 ✅

### 문서

- [x] `ADR-0002-state-management.md` — Riverpod 선택 이유
- [x] `ADR-0003-backend-choice.md` — 백엔드 선택 이유

### 인증

- [x] `lib/screens/auth/login_screen.dart` — 이메일/비밀번호 입력, 유효성 검사, 로그인 버튼
- [x] `lib/screens/auth/signup_screen.dart` — 회원가입 폼, 중복 이메일 처리
- [x] `lib/providers/auth_provider.dart` — Riverpod AsyncNotifier, signIn/signUp/signOut 구현

### 비고 (Supabase → 로컬 더미 변경)

> task-a.md 원안은 Supabase Auth 연동이었으나,  
> 팀 결정으로 Supabase를 제거하고 **메모리 기반 더미 인증**으로 대체했다.  
> 인터페이스(authNotifierProvider, AsyncValue)는 동일하게 유지되어 팀원 B 코드와 연동 가능하다.

| 항목 | 원안 | 변경 후 |
|------|------|---------|
| 인증 백엔드 | Supabase Auth | 로컬 메모리 Map |
| API 호출 위치 | Supabase Edge Function | Claude API 직접 호출 |
| 데이터 영속성 | Supabase PostgreSQL | 없음 (앱 종료 시 초기화) |

---

## 12주차 — 완료 ✅

### 시나리오

- [x] `lib/screens/scenario/scenario_input_screen.dart` — 상황 입력 TextField, 난이도 ChoiceChip, 카테고리 ChoiceChip, 생성 버튼
- [x] `lib/screens/scenario/scenario_result_screen.dart` — 배경/역할/목표 카드 UI, 재생성 버튼, 대화 시작 버튼
- [x] `lib/services/scenario_service.dart` — ScenarioAgent: Claude Haiku API 직접 호출, JSON 파싱
- [x] `lib/providers/scenario_provider.dart` — Riverpod AsyncNotifier, 시나리오 생성 상태 관리
- [x] `lib/models/scenario.dart` — Scenario 데이터 모델 (완성, 수정 불필요)

### ScenarioAgent 프롬프트 구조

```
입력: 상황(한국어) + 난이도 + 카테고리
출력: { id, background, user_role, ai_role, goal } JSON
모델: claude-haiku-4-5-20251001
```

---

## 팀원 B 연동 포인트 — 정상 ✅

| 팀원 B가 필요한 것 | 내가 제공하는 것 | 상태 |
|-------------------|----------------|------|
| 인증 상태 감시 | `authNotifierProvider` (AsyncValue\<User?\>) | ✅ |
| 시나리오 데이터 | `Scenario` 모델 (`lib/models/scenario.dart`) | ✅ |
| 화면 경로 상수 | `AppRoutes.*` (`lib/router/app_router.dart`) | ✅ |

---

## 14주차 — 미시작 ❌

- [ ] `docs/deploy.md` — 배포 절차 문서 (과제 +4점 조건)
- [ ] `lib/services/analysis_service.dart` — AnalysisAgent 구현 (현재 UnimplementedError)
- [ ] `lib/screens/analysis/analysis_screen.dart` — 약점 분석 화면 (현재 빈 플레이스홀더)

> 14주차 작업은 팀원 B의 FeedbackAgent가 완성된 후,  
> 피드백 누적 데이터를 기반으로 분석하는 방식으로 연동 예정.

---

## 현재 동작하는 플로우

```
앱 시작
  └─ 홈 화면
       └─ 상황 입력 화면 (/scenario/input)
            └─ ScenarioAgent 호출 (Claude Haiku)
                 └─ 시나리오 결과 화면 (/scenario/result)
                      └─ [대화 시작] → 팀원 B 구현 대기 중
```

---

## 현재 동작하지 않는 플로우

```
대화 화면 (/conversation)    → 팀원 B 구현 중
피드백 화면 (/feedback)      → 팀원 B 구현 중
대화 기록 (/history)         → 팀원 B 구현 중
약점 분석 (/analysis)        → 14주차 예정
```
