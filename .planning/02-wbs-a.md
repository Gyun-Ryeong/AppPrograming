# WBS — 팀원 A 작업 현황

> 최종 업데이트: 2026-06-03

---

## 전체 진행률

```
11주차  ████████████████████  100%  완료
12주차  ████████████████████  100%  완료
14주차  ████████████████████  100%  완료
```

---

## 11주차 — 완료 ✅

- [x] `.planning/decisions/ADR-0002-state-management.md` — Riverpod 선택 이유
- [x] `.planning/decisions/ADR-0003-backend-choice.md` — 백엔드 선택 이유
- [x] `lib/screens/auth/login_screen.dart` — 이메일/비밀번호 입력, 유효성 검사
- [x] `lib/screens/auth/signup_screen.dart` — 회원가입 폼, 중복 이메일 처리
- [x] `lib/providers/auth_provider.dart` — Riverpod Notifier, 메모리 더미 인증

**변경 사항**: Supabase → 로컬 더미 인증으로 대체 (ADR-0004 참고)

---

## 12주차 — 완료 ✅

- [x] `lib/screens/scenario/scenario_input_screen.dart` — 상황 입력, 난이도/카테고리 선택
- [x] `lib/screens/scenario/scenario_result_screen.dart` — 배경/역할/목표 카드, 대화 시작 버튼
- [x] `lib/services/scenario_service.dart` — ScenarioAgent, Gemini API 호출 + JSON 파싱
- [x] `lib/providers/scenario_provider.dart` — 시나리오 생성 상태 관리
- [x] `lib/models/scenario.dart` — Scenario 데이터 모델

---

## 14주차 — 완료 ✅

- [x] `docs/deploy.md` — 배포 절차 문서 (GitHub Pages, APK, 웹 빌드)
- [x] `lib/services/analysis_service.dart` — AnalysisAgent, Gemini API 호출
- [x] `lib/screens/analysis/analysis_screen.dart` — 약점 패턴 카드, 개선 추세, 추천 상황
- [x] `lib/providers/analysis_provider.dart` — 분석 상태 AsyncNotifier
- [x] `lib/models/analysis_report.dart` — AnalysisReport, WeaknessPattern 모델

**비고**: analysis 관련 파일은 팀원 B가 구현 후 병합, 팀원 A 검토 완료

---

## 팀원 B 연동 포인트 — 정상 ✅

| 항목 | 파일 | 상태 |
|------|------|------|
| 인증 상태 | `authNotifierProvider` | ✅ |
| 시나리오 모델 | `lib/models/scenario.dart` | ✅ |
| 화면 경로 상수 | `AppRoutes.*` | ✅ |
| 대화 기록 | `historyProvider` (팀원 B) | ✅ |

---

## 전체 동작 플로우 — 완성 ✅

```
로그인 (/login)
  └─ 홈 화면 (/)
       ├─ 상황 입력 (/scenario/input)
       │    └─ ScenarioAgent → Gemini API
       │         └─ 시나리오 결과 (/scenario/result)
       │              └─ 대화 화면 (/conversation)  [팀원 B]
       │                   └─ 피드백 (/feedback)    [팀원 B]
       ├─ 대화 기록 (/history)                      [팀원 B]
       └─ 약점 분석 (/analysis)
            └─ AnalysisAgent → Gemini API
```
