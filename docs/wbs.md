# WBS — 작업 분해 구조 (Work Breakdown Structure)

> MEF 프로젝트의 작업 분해 구조. Phase별 작업 항목, 담당자, 마일스톤, 완료 상태를 기록한다.
> 키워드: WBS, 작업 분해, 일정, 마일스톤, 담당자, Phase

---

## 전체 진행률 (2026-06-13 기준)

```
기획  ████████████████████  100% ✅
설계  ████████████████████  100% ✅
구현  ████████████████████  100% ✅
품질  ████████████████████  100% ✅
배포  ████████████████████  100% ✅
```

---

## Phase 1 — 기획 (10주차)

**마일스톤**: 프로젝트 방향과 요구사항 확정

| 작업 ID | 작업 항목 | 담당자 | 산출물 | 완료 |
|---------|-----------|--------|--------|------|
| P1-01 | 앱 비전·미션 정의 | 이동희 | `vision.md` | ✅ |
| P1-02 | 기능 요구사항 MoSCoW 분류 | 이동희 | `requirements.md` | ✅ |
| P1-03 | WBS 수립 (작업 분해 구조) | 김령균 | `wbs.md` | ✅ |
| P1-04 | 7주 개발 일정 수립 | 김령균 | `schedule.md` | ✅ |

---

## Phase 2 — 설계 (11주차)

**마일스톤**: 아키텍처 확정 + Hello World 빌드 성공

| 작업 ID | 작업 항목 | 담당자 | 산출물 | 완료 |
|---------|-----------|--------|--------|------|
| D1-01 | Flutter 개발 환경 설정 | 김령균 | `docs/setup.md` | ✅ |
| D1-02 | 아키텍처 설계 (레이어드 MVVM) | 이동희 | `docs/architecture.md` | ✅ |
| D1-03 | ADR-0001 플랫폼 선택 근거 (Flutter) | 이동희 | `ADR-0001.md` | ✅ |
| D1-04 | ADR-0002 상태 관리 선택 (Riverpod) | 이동희 | `ADR-0002.md` | ✅ |
| D1-05 | ADR-0003 백엔드 제거 결정 | 이동희 | `ADR-0003.md` | ✅ |
| D1-06 | ADR-0004 인증 방식 결정 (Mock) | 김령균 | `ADR-0004.md` | ✅ |
| D1-07 | ADR-0005 AI API 제공자 결정 (Gemini) | 김령균 | `ADR-0005.md` | ✅ |
| D1-08 | 디렉토리 구조 확정 + pubspec.yaml | 김령균 | `pubspec.yaml` | ✅ |

---

## Phase 3 — 구현 (12~13주차)

**마일스톤**: 4개 Agent 전체 동작 + 전체 사용자 흐름 완성

### 공통 인프라 (김령균)

| 작업 ID | 작업 항목 | 산출물 | 완료 |
|---------|-----------|--------|------|
| I1-01 | main.dart ProviderScope + 테마 | `lib/main.dart` | ✅ |
| I1-02 | go_router 라우팅 설정 | `lib/router/app_router.dart` | ✅ |
| I1-03 | 공통 위젯 3개 | `widgets/chat_bubble.dart` 외 2개 | ✅ |
| I1-04 | 색상·문자열 상수 정의 | `constants/app_colors.dart` 외 | ✅ |

### 인증 (이동희)

| 작업 ID | 작업 항목 | 산출물 | 완료 |
|---------|-----------|--------|------|
| A1-01 | 로그인 화면 | `screens/auth/login_screen.dart` | ✅ |
| A1-02 | 회원가입 화면 | `screens/auth/signup_screen.dart` | ✅ |
| A1-03 | Mock 인증 Provider | `providers/auth_provider.dart` | ✅ |

### ScenarioAgent (이동희)

| 작업 ID | 작업 항목 | 산출물 | 완료 |
|---------|-----------|--------|------|
| S1-01 | ScenarioAgent 프롬프트 설계 | `services/scenario_service.dart` | ✅ |
| S1-02 | 상황 입력 화면 | `screens/scenario/scenario_input_screen.dart` | ✅ |
| S1-03 | 시나리오 결과 화면 | `screens/scenario/scenario_result_screen.dart` | ✅ |
| S1-04 | 시나리오 Provider | `providers/scenario_provider.dart` | ✅ |

### ConversationAgent (김령균)

| 작업 ID | 작업 항목 | 산출물 | 완료 |
|---------|-----------|--------|------|
| C1-01 | ConversationAgent 프롬프트 설계 | `services/conversation_service.dart` | ✅ |
| C1-02 | 채팅 화면 (역방향 스크롤 ListView) | `screens/conversation/conversation_screen.dart` | ✅ |
| C1-03 | 대화 히스토리 Provider | `providers/conversation_provider.dart` | ✅ |

### FeedbackAgent (김령균)

| 작업 ID | 작업 항목 | 산출물 | 완료 |
|---------|-----------|--------|------|
| F1-01 | FeedbackAgent 프롬프트 설계 | `services/feedback_service.dart` | ✅ |
| F1-02 | 피드백 결과 화면 | `screens/feedback/feedback_screen.dart` | ✅ |
| F1-03 | 피드백 Provider | `providers/feedback_provider.dart` | ✅ |

### 대화 기록 (김령균)

| 작업 ID | 작업 항목 | 산출물 | 완료 |
|---------|-----------|--------|------|
| H1-01 | 기록 목록 화면 | `screens/history/history_screen.dart` | ✅ |
| H1-02 | 기록 상세 화면 | `screens/history/history_detail_screen.dart` | ✅ |
| H1-03 | 기록 Provider | `providers/history_provider.dart` | ✅ |

### AnalysisAgent 유료 기능 (이동희)

| 작업 ID | 작업 항목 | 산출물 | 완료 |
|---------|-----------|--------|------|
| AN1-01 | AnalysisAgent 프롬프트 설계 | `services/analysis_service.dart` | ✅ |
| AN1-02 | 약점 분석 화면 | `screens/analysis/analysis_screen.dart` | ✅ |
| AN1-03 | 분석 Provider | `providers/analysis_provider.dart` | ✅ |

---

## Phase 4 — 품질 (13~14주차)

**마일스톤**: flutter analyze 0 errors + 테스트 문서화

| 작업 ID | 작업 항목 | 담당자 | 산출물 | 완료 |
|---------|-----------|--------|--------|------|
| Q1-01 | 단위 테스트 (모델 JSON 파싱) | 김령균 | `test/models/` | ✅ |
| Q1-02 | 통합 테스트 (전체 흐름) | 김령균 | 수동 체크리스트 | ✅ |
| Q1-03 | flutter analyze 0 errors 달성 | 김령균 | CI 확인 | ✅ |
| Q1-04 | 성능 최적화 (토큰 예산 조정) | 이동희 | `services/*.dart` 수정 | ✅ |
| Q1-05 | 성능 최적화 문서화 | 이동희 | `docs/performance.md` | ✅ |
| Q1-06 | 테스트 전략 문서화 | 김령균 | `docs/testing.md` | ✅ |

---

## Phase 5 — 배포 (14~15주차)

**마일스톤**: GitHub Pages 발표 자료 배포 + 최종 발표

| 작업 ID | 작업 항목 | 담당자 | 산출물 | 완료 |
|---------|-----------|--------|--------|------|
| DEP1-01 | 발표 슬라이드 제작 (16→20슬라이드) | 이동희 | `index.html` | ✅ |
| DEP1-02 | GitHub Pages 배포 | 이동희 | GitHub Pages URL | ✅ |
| DEP1-03 | 데모 영상 촬영 및 업로드 | 이동희 | `MEFdemo.mp4` | ✅ |
| DEP1-04 | 배포 문서 작성 | 이동희 | `docs/deploy.md` | ✅ |
| DEP1-05 | 최종 발표 | 이동희·김령균 | 발표 | ⬜ |

---

## 전체 작업 요약

| Phase | 작업 수 | 완료 | 완료율 |
|-------|---------|------|--------|
| 기획 | 4 | 4 | 100% |
| 설계 | 8 | 8 | 100% |
| 구현 | 22 | 22 | 100% |
| 품질 | 6 | 6 | 100% |
| 배포 | 5 | 4 | 80% |
| **합계** | **45** | **44** | **97.8%** |
