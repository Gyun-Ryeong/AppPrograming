# 용어 사전 (Glossary)

> MEF 프로젝트에서 사용하는 핵심 용어를 정리한다.
> 키워드: wiki, 암묵지, 용어 사전, 지식 관리, 프로젝트 용어

---

## A

### ADR (Architecture Decision Record)
프로젝트의 중요한 기술 결정을 기록하는 문서 형식.
"왜 이 기술을 선택했는가"의 이유와 대안 비교를 담는다.
MEF: `.planning/decisions/ADR-NNNN-{제목}.md` 형식, ADR-0001 ~ ADR-0005 작성 완료.

### Agent (AI Agent)
특정 역할을 담당하는 AI 기능 단위.
MEF의 4개 Agent: ScenarioAgent, ConversationAgent, FeedbackAgent, AnalysisAgent.
각 Agent는 `lib/services/` 에서만 Gemini API를 호출하며, 화면에서 직접 호출하지 않는다.

### AnalysisAgent
누적 대화 세션을 분석해 약점 패턴을 발굴하는 Agent. [유료 기능]
세션 0개일 때는 API 호출 없이 기본 메시지를 즉시 반환한다.
→ `lib/services/analysis_service.dart`, maxOutputTokens 4096

### AsyncNotifier
Riverpod의 비동기 상태 관리 클래스.
Gemini API 호출처럼 Future를 다루는 Provider에 사용.
`AsyncValue<T>` (loading / data / error) 3상태를 자동으로 관리한다.

### AsyncValue
Riverpod이 제공하는 비동기 상태 래퍼. 3가지 상태로 구성:
- `AsyncValue.loading()` — 요청 진행 중 (버튼 비활성화, 스피너 표시)
- `AsyncValue.data(value)` — 성공 (결과 렌더링)
- `AsyncValue.error(e, stack)` — 실패 (에러 메시지 표시)

화면에서 `AsyncValue.when(data:, loading:, error:)` 패턴으로 분기 처리.

---

## C

### ConversationAgent
시나리오 맥락을 유지하며 실시간 영어 대화를 진행하는 Agent.
`system_instruction`으로 시나리오 정보를 전달하고, `contents` 배열로 대화 히스토리 유지.
Gemini에서 AI 역할은 `role: 'model'` (OpenAI의 `'assistant'`와 다름).
→ `lib/services/conversation_service.dart`, maxOutputTokens 512

### CORS (Cross-Origin Resource Sharing)
브라우저의 동일 출처 정책으로 인해 다른 도메인 API를 직접 호출할 수 없는 제약.
MEF에서는 Chrome 웹 빌드에서 Gemini API 직접 호출이 CORS로 차단된다.
해결: `flutter run -d windows` (데스크톱 빌드는 브라우저 CORS 정책 미적용).

---

## F

### FeedbackAgent
대화 종료 후 문법 오류, 표현 개선 제안, 자연스러움 점수(0~100)를 제공하는 Agent.
출력: `Feedback` 모델 (grammar_errors, expression_suggestions, naturalness_score, overall_comment)
→ `lib/services/feedback_service.dart`, maxOutputTokens 2048

### Freemium
기본 기능은 무료, 고급 기능은 유료로 제공하는 수익 모델.
MEF: 시나리오 생성·대화·피드백은 무료, 약점 분석(AnalysisAgent)은 유료.

---

## G

### GeminiApiHelper
Gemini API 공통 호출을 담당하는 헬퍼 클래스. 2026-06-13 추가.
429 Rate Limit 응답 시 1.5초 대기 후 자동 1회 재시도 로직 내장.
4개 서비스 파일이 모두 이 헬퍼를 통해 API를 호출한다.
→ `lib/services/gemini_api_helper.dart`

### go_router
Flutter 공식 권장 라우팅 패키지 (버전 14).
선언적 라우팅, Deep Link, 리디렉션 Guard를 지원.
MEF: 미로그인 상태에서 홈 직접 접근 시 로그인 화면으로 자동 리디렉션.
→ `lib/router/app_router.dart`

---

## L

### Layered Architecture (레이어드 아키텍처)
코드를 역할별 계층으로 분리하는 설계 패턴.
MEF의 4계층 의존 방향:
```
screens/ → providers/ → services/ → Gemini API
  (UI)       (상태)       (통신)
```
역방향 참조 금지: 예를 들어 service에서 BuildContext 사용 불가.

---

## M

### maxOutputTokens
Gemini API 요청에서 AI가 생성하는 최대 토큰 수를 제한하는 설정.
너무 낮으면 JSON 응답이 중간에 잘려 `FormatException` 발생.
너무 높으면 불필요한 응답 지연 및 API 비용 낭비.
MEF: Agent별로 512 / 1024 / 2048 / 4096으로 차별화 적용.

### Mock 인증
실제 서버 없이 메모리(Dart Map)에서 인증 상태를 관리하는 방식.
MEF 테스트 계정: `test@mef.com` / `test1234`
앱 종료 시 계정 데이터 초기화 — 과제 범위 내 허용된 제약.
→ `lib/providers/auth_provider.dart`

### MoSCoW
요구사항 우선순위 분류 기법.
Must / Should / Could / Won't 4단계로 기능을 분류해 개발 우선순위를 결정.
→ `.planning/01-requirements.md`

### MVVM (Model-View-ViewModel)
UI(View)와 비즈니스 로직(ViewModel)을 분리하는 아키텍처 패턴.
MEF: Screen(View) → Provider(ViewModel) → Service(Model) 구조로 구현.

---

## N

### Notifier
Riverpod의 동기 상태 관리 클래스.
Future 없이 단순 상태를 다룰 때 사용. 예: 인증 상태(로그인/로그아웃), UI 토글.

---

## R

### responseMimeType
Gemini API `generationConfig`에 지정하는 응답 형식 강제 필드.
`'application/json'`으로 설정하면 AI가 순수 JSON만 반환 (마크다운 코드블록 제거).
Gemini 2.5 Flash는 thinking 모드 지원 모델이라 이 설정 없이는 JSON 외 텍스트를 추가함.
MEF에서 JSON 파싱 실패율을 0%로 낮춘 핵심 설정.

### Riverpod
Flutter 상태 관리 라이브러리 (버전 2.6.1).
Provider 패키지의 단점(BuildContext 의존)을 해결하고 컴파일 타임 안전성을 제공.
→ ADR-0002

---

## S

### ScenarioAgent
사용자 자유 텍스트 입력을 구조화된 시나리오 JSON으로 변환하는 Agent.
출력: `Scenario` 모델 (id, background, user_role, ai_role, goal)
→ `lib/services/scenario_service.dart`, maxOutputTokens 1024

### Single Source of Truth (단일 진실 공급원)
정보를 한 곳에서만 관리해 버전 충돌을 방지하는 원칙.
MEF: `AGENTS.md`가 agent/skills/rules/commands의 단일 진실 공급원.
팀원이 새 세션 시작 시 AGENTS.md 하나만 읽으면 전체 맥락 파악 가능.

### system_instruction
Gemini API에서 모델의 역할과 행동 지침을 정의하는 별도 필드.
`contents` 배열(대화 히스토리)과 분리해 관리하므로 대화가 길어져도 시나리오 맥락 보존.
→ ConversationAgent에서 시나리오 배경·역할·목표 전달에 사용.

---

## W

### Wiki (프로젝트 위키)
코드와 ADR에 담기지 않는 판단·시행착오·암묵지를 축적하는 내부 문서 공간.
MEF: `.planning/wiki/` 폴더에서 관리 (00-index.md, 01~05 각 주제별 파일).
ADR과의 차이: ADR은 확정된 결론, Wiki는 결정 과정과 실패 경험까지 포함.

### WBS (Work Breakdown Structure)
프로젝트를 구체적인 작업 단위로 분해한 계획 문서.
MEF: Phase 1(기획)~Phase 5(배포), 총 45개 작업 항목.
→ `docs/wbs.md`
