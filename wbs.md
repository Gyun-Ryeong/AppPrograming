# WBS — MEF 전체 작업 현황

> 팀원 A(이동희) + 팀원 B(김령균) 작업 통합
> 최종 업데이트: 2026-06-13

---

## 전체 진행률

```
11주차  ████████████████████  100%  완료 ✅
12주차  ████████████████████  100%  완료 ✅
13주차  ████████████████████  100%  완료 ✅
14주차  ████████████░░░░░░░░   60%  진행 중 🔄
15주차  ░░░░░░░░░░░░░░░░░░░░    0%  미시작
```

---

## 11주차 — 완료 ✅

### 팀원 A (이동희)
- [x] ADR-0002 Riverpod 선택 이유 작성
- [x] ADR-0003 백엔드 선택 이유 작성
- [x] `login_screen.dart` — 이메일/비밀번호 입력, 유효성 검사
- [x] `signup_screen.dart` — 회원가입 폼, 중복 이메일 처리
- [x] `auth_provider.dart` — Riverpod AsyncNotifier, signIn/signUp/signOut

### 팀원 B (김령균)
- [x] pubspec.yaml 패키지 추가 (flutter_riverpod, go_router, http)
- [x] `main.dart` — Riverpod ProviderScope + AppColors 전역 테마
- [x] `chat_bubble.dart` — 좌/우 말풍선 위젯
- [x] `primary_button.dart` — 로딩 스피너 공통 버튼
- [x] `loading_overlay.dart` — AI 응답 대기 오버레이
- [x] `app_router.dart` — GoRouter 인스턴스 + 경로 상수
- [x] `home_screen.dart` — 홈 화면 UI
- [x] ADR-0004 인증 방식, ADR-0005 AI API 제공자 작성

### 아키텍처 변경 (팀 결정)
- Supabase 제거 → Google Gemini 2.5 Flash 직접 호출
- 인증: Supabase Auth → 메모리 Mock (test@mef.com / test1234)
- DB: PostgreSQL → Riverpod 메모리 (앱 종료 시 초기화)

---

## 12주차 — 완료 ✅

### 팀원 A (이동희)
- [x] `scenario_input_screen.dart` — 상황 입력, 난이도/카테고리 선택
- [x] `scenario_result_screen.dart` — 시나리오 결과 카드, 대화 시작 버튼
- [x] `scenario_service.dart` — ScenarioAgent: Gemini API 호출, JSON 파싱
- [x] `scenario_provider.dart` — 시나리오 생성 상태 관리
- [x] `feedback_screen.dart` — 자연스러움 점수, 문법 오류 카드
- [x] `feedback_service.dart` — FeedbackAgent: Gemini API 호출
- [x] `feedback_provider.dart` — 피드백 상태 관리
- [x] `history_screen.dart` / `history_detail_screen.dart` — 대화 기록
- [x] `analysis_screen.dart` / `analysis_service.dart` — AnalysisAgent (유료)

### 팀원 B (김령균)
- [x] `conversation_screen.dart` — 채팅 화면 (말풍선 ListView, 역방향 스크롤)
- [x] `conversation_service.dart` — ConversationAgent: Gemini API 호출
- [x] `conversation_provider.dart` — 대화 히스토리 상태 관리
- [x] `history_detail_screen.dart` — 과거 대화 상세 보기
- [x] JSON 파싱 오류 수정 (`responseMimeType: 'application/json'` 추가)

---

## 13주차 — 완료 ✅

- [x] AGENTS.md 통합 재작성 (agent / skills / rules / commands)
- [x] ADR-0005 Gemini API로 내용 갱신
- [x] `.planning/wiki/` 신설 (시행착오 로그, Gemini 가이드, Flutter 패턴)
- [x] 발표 자료 `index.html` 16슬라이드 완성 (GitHub Pages)
- [x] 데모 영상 `MEFdemo.mp4` 추가
- [x] `flutter analyze` 오류 0개 확인

---

## 14주차 — 진행 중 🔄

- [x] `vision.md`, `requirements.md`, `wbs.md`, `schedule.md` 루트 생성
- [ ] `BONUS.md` 가산점 증빙 최종 정리
- [ ] 전체 흐름 통합 테스트 (로그인→시나리오→채팅→피드백→기록→분석)
- [ ] 발표 리허설

---

## 현재 동작하는 전체 흐름

```
로그인 → 홈 → 시나리오 입력 → 시나리오 결과
  → 채팅 → 대화 종료 → 피드백
  → 홈 or 다시 연습
  → 대화 기록 목록 → 상세 보기
  → 약점 분석 [유료]
```

---

> 상세 WBS: `.planning/02-wbs.md`
