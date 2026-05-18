# CLAUDE.md

## 프로젝트 개요
- 앱 이름: MEF — My English Friend
- 형태: 모바일 앱 (Flutter)
- 목적: AI 기반 영어 회화 트레이너
- 타겟: 학생, 직장인 (B2C)
- 수익 모델: Freemium + 기능별 일회성 결제
- 차별화: 사용자가 원하는 상황을 직접 입력하면
           AI가 시나리오 생성 후 실시간 대화 진행
           대화 후 문법/표현/자연스러움 종합 피드백

## AI Agent 구조
이 프로젝트의 AI 기능은 4개의 Agent로 구성된다.
1. ScenarioAgent — 사용자 상황 입력 → 대화 시나리오 생성
2. ConversationAgent — 실시간 대화 진행 (맥락 유지)
3. FeedbackAgent — 대화 종료 후 문법/표현/자연스러움 종합 피드백
4. AnalysisAgent — 약점 패턴 누적 분석 (유료 기능)

## 코드 생성 규칙
- 모든 코드에 한국어 주석 필수 (발표 설명 대비)
- 위젯(Widget)은 반드시 단일 책임 원칙으로 파일 분리
- AI 호출은 반드시 services/ 레이어에서만 수행
- 상수/설정값은 하드코딩 금지, constants/ 에 모음
- 복잡한 패턴보다 단순하고 명확한 구조 우선
- 파일명은 Dart 관례에 따라 snake_case 사용 (예: scenario_service.dart)
- 상태 관리는 Riverpod 사용

## 문서 생성 규칙
- 새 기능/기술 선택 시 ADR 자동 생성할 것
- 모든 의사결정에 "왜 이걸 선택했는가" 이유 명시
- 아키텍처 문서에 Mermaid 다이어그램 포함

## 디렉토리 구조 원칙
- .planning/ — AI Agent가 생성하는 계획 문서
- docs/      — 사람이 읽는 문서 (setup, deploy, testing)
- lib/       — Flutter 실제 코드 (Dart 표준 디렉토리)
- .github/agents/   — 서브에이전트 정의
- .github/prompts/  — 슬래시 명령 템플릿

## 수업 일정 (10~15주차)

| 주차 | 목표 | 핵심 산출물 |
|------|------|------------|
| 10주차 | 기획·일정 수립 | `.planning/*` 5개 문서 |
| 11주차 | 설계·환경 구축 | `docs/architecture.md`, Hello World 빌드 |
| 12주차 | 핵심 기능 1 + **중간 발표** | 동작하는 프로토타입 |
| 13주차 | 핵심 기능 2 + 테스트 | 주요 기능 완성 |
| 14주차 | 마감·배포·문서 | `docs/deploy.md`, `docs/testing.md` |
| 15주차 | **최종 발표** | 발표 자료 + `BONUS.md` |

---

## 과제 점수 체크리스트 (5점 만점)

| 점수 | 문서 | 상태 |
|------|------|------|
| +1 | `.planning/00-vision.md`, `01-requirements.md` | ✅ 완료 |
| +2 | `.planning/02-wbs.md`, `04-schedule.md` | ✅ 완료 |
| +3 | `docs/architecture.md` + ADR 최소 3개 | ⚠️ ADR-0001만 있음 (0002, 0003 필요) |
| +4 | `docs/setup.md`, `docs/deploy.md`, `docs/testing.md` | ❌ deploy.md / testing.md 없음 |
| +5 | `AGENTS.md` + `README.md` + `.github/agents/` | ✅ 완료 |

**가산점 (+6점 최대):**
- +1: AI Agent 활용 사례 시연 → `BONUS.md`에 기록
- +2: 본인만의 부트스트랩 파일 → `AUTHORING.{이름}.md` 작성 필요
- +1: LLM Wiki 10개 이상 항목 운영
- +2: 최신 AI Agent 리포트 10분 발표

**즉시 해야 할 것:**
1. `ADR-0002-state-management.md` (Riverpod 선택 이유)
2. `ADR-0003-backend-choice.md` (Supabase 선택 이유)
3. `docs/deploy.md` (배포 절차)
4. `docs/testing.md` (테스트 전략)
5. `BONUS.md` (가산점 신청 트래킹)

---

## 발표 Q&A 대비 체크리스트

발표에서 반드시 답할 수 있어야 하는 질문들:

- [ ] Flutter를 선택한 이유는? (대안 비교 포함) → ADR-0001
- [ ] Riverpod을 상태관리로 선택한 이유는? → ADR-0002
- [ ] Supabase를 백엔드로 선택한 이유는? → ADR-0003
- [ ] 새 화면을 추가하면 어느 폴더에 파일을 만드는가?
- [ ] AI API 키는 어디에 있고, 왜 클라이언트에 없는가?
- [ ] `git clone` 후 한 줄 명령으로 실행되는가?
- [ ] 빌드가 실패하면 어디부터 확인하는가?
- [ ] Must 기능 5개를 외워서 말할 수 있는가?
- [ ] 가장 큰 위험 1개와 대응 방법은?

---

## 아키텍처 레이어 원칙

이 프로젝트는 **Layered + MVVM** 패턴을 사용한다 (7주 프로젝트 적정 복잡도).

```
Presentation  →  Application  →  Domain  →  Data
screens/          providers/      models/    services/
widgets/                          (entities)  (API/DB)
```

- 화면(Screen)은 UI만 — 로직은 Provider/Service로 분리
- API 호출은 반드시 services/ — 화면에서 직접 호출 금지
- 새 화면 → `screens/`, 상태 → `providers/`, 규칙 → `models/`, 외부통신 → `services/`

---

## 핵심 원칙 (절대 잊지 말 것)

이 프로젝트는 바이브 코딩 수업 과제이다.
AI가 생성한 모든 코드와 문서는
반드시 본인이 처음부터 끝까지 읽고
이해하지 못한 부분은 다시 질문해서
본인의 언어로 설명할 수 있어야 한다.

"AI가 만들었어요"는 발표에서 답이 되지 않는다.
