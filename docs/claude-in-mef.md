# Claude × MEF — AI 기술 활용 보고서

> 이 문서는 MEF(My English Friend) 중간 발표를 위해 작성된 자료다.  
> Claude가 무엇인지, 이 프로젝트에서 어떻게 활용되고 있는지, 앞으로 어떻게 발전시킬지를 설명한다.

---

## 1. Claude란 무엇인가

### 1.1 개요

**Claude**는 미국 AI 회사 **Anthropic**이 개발한 대형 언어 모델(LLM)이다.  
GPT 시리즈(OpenAI)와 함께 현재 세계에서 가장 널리 쓰이는 AI 모델 중 하나다.

| 항목 | 내용 |
|------|------|
| 개발사 | Anthropic (2021년 설립, 前 OpenAI 연구원 창업) |
| 최신 버전 | Claude 4 시리즈 (Opus 4, Sonnet 4, Haiku 4) |
| 핵심 철학 | **Constitutional AI** — 안전하고 유익하며 솔직한 AI |
| 강점 | 긴 문서 처리, 코드 생성, 자연스러운 대화, 한국어 지원 |

### 1.2 모델 티어 구조

Anthropic은 용도에 따라 세 가지 티어를 제공한다:

```
Opus   — 가장 강력, 복잡한 추론·분석 (비용 높음)
Sonnet — 성능과 속도의 균형 (범용)
Haiku  — 가장 빠르고 저렴 (실시간 응답에 최적)
```

> **MEF 선택**: `claude-haiku-4-5` — 사용자가 입력할 때마다 즉각 응답이 필요하므로 가장 빠른 Haiku를 사용한다.

### 1.3 Claude API 작동 방식

Claude는 HTTP POST 방식으로 호출한다. 요청 구조는 다음과 같다:

```
[Flutter 앱] → POST https://api.anthropic.com/v1/messages
              Headers: x-api-key, anthropic-version
              Body:    { model, max_tokens, messages: [{ role, content }] }
              
              ← { content: [{ text: "AI 응답 텍스트" }] }
```

역할(role)은 두 가지다:
- `user` — 사용자가 보내는 메시지
- `assistant` — Claude가 이전에 답한 메시지 (대화 맥락 유지에 사용)

---

## 2. Claude Code — 이 앱을 만든 도구

### 2.1 Claude Code란

**Claude Code**는 Anthropic이 제공하는 **터미널 기반 AI 코딩 어시스턴트**다.  
VSCode 같은 편집기 플러그인이 아닌, 독립적으로 실행되는 CLI(Command Line Interface) 도구다.

```bash
# 설치 및 실행
npm install -g @anthropic-ai/claude-code
claude
```

### 2.2 MEF 개발에서 Claude Code를 사용한 방식

이 프로젝트의 코드와 문서는 Claude Code와 함께 **바이브 코딩(Vibe Coding)** 방식으로 작성됐다.

| 작업 | Claude Code 역할 |
|------|-----------------|
| 프로젝트 구조 설계 | `lib/` 디렉토리 구조 제안 및 파일 생성 |
| 화면 위젯 작성 | `login_screen.dart`, `scenario_input_screen.dart` 등 UI 코드 생성 |
| 서비스 구현 | `scenario_service.dart` — Claude API 호출 로직 작성 |
| ADR 문서 작성 | 기술 선택 근거 문서(ADR-0001, 0002, 0003) 작성 |
| 충돌 해결 | 팀원 A/B 작업 병합 시 Git 충돌 해결 |
| 이 문서 작성 | 발표 자료 생성 |

### 2.3 바이브 코딩이란

> *"AI와 함께 대화하듯 코드를 짜는 개발 방식"*

기존 방식: 개발자가 직접 모든 코드를 타이핑  
바이브 코딩: 개발자가 **의도와 요구사항을 말하면** AI가 코드를 생성, 개발자는 검토·수정

```
개발자: "로그인 화면 만들어줘. 이메일/비밀번호 입력, 유효성 검사 포함"
Claude Code: login_screen.dart 전체 코드 생성
개발자: 코드 읽고 이해 → 필요하면 수정 → 다음 작업 요청
```

**핵심**: AI가 생성해도 **개발자가 코드를 이해하고 설명할 수 있어야** 한다.

---

## 3. MEF 앱에서 Claude를 활용하는 방법

### 3.1 4개 Agent 구조

MEF는 하나의 Claude 호출이 아니라, 4개의 **역할이 다른 AI Agent**로 구성된다.

```
사용자 입력
    ↓
[ScenarioAgent]   — 상황 → 시나리오 생성          ← 팀원 A 담당 ✅
    ↓
[ConversationAgent] — 시나리오 기반 실시간 대화      ← 팀원 B 담당
    ↓
[FeedbackAgent]   — 대화 종료 후 문법/표현 피드백   ← 팀원 B 담당
    ↓
[AnalysisAgent]   — 누적 약점 패턴 분석 (유료)     ← 팀원 A 담당 (예정)
```

### 3.2 ScenarioAgent (구현 완료)

**역할**: 사용자가 입력한 한국어 상황 → 영어 대화 시나리오 JSON 생성

**파일**: `lib/services/scenario_service.dart`

**프롬프트 설계**:

```
You are a scenario generator for English conversation practice.
Based on the user's input, respond ONLY with a JSON object:
{
  "id": "unique_id",
  "background": "Scene description in English",
  "user_role": "User's role in English",
  "ai_role": "AI partner's role in English",
  "goal": "Conversation goal in English"
}

Situation: [사용자 입력]
Difficulty: beginner | intermediate | advanced
Category: daily | business | travel | academic
```

**실제 호출 흐름**:

```
사용자: "카페에서 음료 주문하기" + 난이도: 중급 + 카테고리: 일상
    ↓ POST /v1/messages
Claude 응답:
{
  "background": "You are at a busy coffee shop in New York.",
  "user_role": "A customer ordering a customized drink",
  "ai_role": "A barista taking orders",
  "goal": "Order a drink with specific customizations"
}
```

**응답 파싱**: Claude가 JSON을 Markdown 코드블록으로 감싸는 경우를 처리:

```dart
// 마크다운 코드블록 제거 후 JSON 파싱
final jsonText = text
    .replaceAll(RegExp(r'```json\s*'), '')
    .replaceAll(RegExp(r'```\s*'), '')
    .trim();
```

### 3.3 ConversationAgent (구현 예정 — 팀원 B)

**역할**: ScenarioAgent가 만든 시나리오를 바탕으로 실시간 대화 진행

**핵심 기술**: **대화 맥락 유지** — 이전 메시지를 모두 포함해서 Claude에 전달

```dart
// 대화 기록 전체를 messages 배열에 포함
messages: [
  { "role": "system", "content": "You are [ai_role]. The scene is [background]..." },
  { "role": "user",   "content": "Hi, can I get a latte?" },
  { "role": "assistant", "content": "Of course! What size would you like?" },
  { "role": "user",   "content": "Large please" },  // 현재 메시지
]
```

### 3.4 FeedbackAgent (구현 예정 — 팀원 B)

**역할**: 대화 종료 후 문법 오류, 자연스러운 표현, 개선 제안 피드백 제공

**출력 형식** (JSON 구조화된 피드백):

```json
{
  "grammar_errors": [
    { "original": "I am go to store", "corrected": "I am going to the store" }
  ],
  "expression_suggestions": [
    { "used": "very good", "natural": "That sounds great!" }
  ],
  "naturalness_score": 7.5,
  "summary": "전반적으로 좋은 대화였습니다. 진행형 시제를 조금 더 연습해 보세요."
}
```

### 3.5 AnalysisAgent (유료 기능 — 개발 예정)

**역할**: 사용자의 여러 대화 기록을 종합 분석 → 반복되는 약점 패턴 도출

```
입력: 지난 10회 대화의 피드백 데이터
출력: "당신은 3인칭 단수 's' 탈락 오류가 70% 이상의 대화에서 발견됩니다"
```

---

## 4. 기술 아키텍처: Claude API 연동 방식

### 4.1 현재 구조 (프로토타입)

```
Flutter 앱
    └── ScenarioService (lib/services/)
            └── HTTP POST → api.anthropic.com
                           (API 키가 클라이언트에 있음 — 데모 전용)
```

### 4.2 목표 구조 (보안 강화 버전)

```
Flutter 앱
    └── ScenarioService
            └── HTTP POST → [Supabase Edge Function] (TypeScript 서버)
                                └── Claude API 호출 (API 키는 서버 환경변수)
                                    api.anthropic.com
```

> **왜 서버를 거쳐야 하는가?**  
> API 키가 앱에 포함되면 apk/ipa 파일 분석으로 키가 노출된다.  
> 서버(Edge Function)에서 키를 관리하면 클라이언트 코드에 키가 없다.

---

## 5. 상태 관리: Riverpod + AsyncValue

Claude API 호출은 비동기 작업이다. 로딩 중 / 성공 / 실패 세 가지 상태를 UI에 반영해야 한다.

Riverpod의 `AsyncValue`가 이를 깔끔하게 처리한다:

```dart
// 시나리오 생성 상태 감시
final generateState = ref.watch(scenarioGenerateProvider);

// UI에서 세 상태를 선언적으로 처리
generateState.when(
  loading: () => CircularProgressIndicator(),
  data: (scenario) => ScenarioCard(scenario: scenario),
  error: (err, _) => Text('오류: $err'),
);
```

---

## 6. 추후 개발 방향

### 6.1 단기 (13~14주차)

| 항목 | 내용 | 담당 |
|------|------|------|
| ConversationAgent 구현 | 실시간 채팅 UI + Claude 대화 맥락 유지 | 팀원 B |
| FeedbackAgent 구현 | 대화 종료 후 피드백 JSON 파싱 + 화면 표시 | 팀원 B |
| API 키 보안 강화 | Supabase Edge Function으로 이전 | 팀원 A |
| 대화 기록 저장 | 로컬 DB 또는 Supabase PostgreSQL | 팀원 A/B |

### 6.2 중기 (최종 발표 전)

| 항목 | 내용 |
|------|------|
| AnalysisAgent 구현 | 누적 데이터 → 약점 리포트 생성 (유료 기능) |
| 음성 지원 (STT/TTS) | 마이크로 말하기 → 텍스트 변환 → Claude 전송 |
| 프롬프트 고도화 | 난이도/카테고리별 시스템 프롬프트 세분화 |
| 오프라인 대응 | 네트워크 없을 때 에러 메시지 + 재시도 로직 |

### 6.3 장기 (출시 가정 시)

| 항목 | 내용 |
|------|------|
| 스트리밍 응답 | Claude 응답을 문자 단위로 실시간 표시 (타이핑 효과) |
| 개인화 프롬프트 | 사용자별 학습 이력 → 시스템 프롬프트에 반영 |
| 다국어 확장 | 영어 외 일본어, 중국어 대화 지원 |
| 비용 최적화 | 프롬프트 캐싱(Anthropic Prompt Caching) 도입으로 API 비용 절감 |

### 6.4 프롬프트 엔지니어링 개선 계획

현재 프롬프트는 단순한 지시문 형태다. 앞으로 아래 기법을 도입할 계획이다:

```
현재:  "JSON 형식으로 응답하세요"
개선 1: Few-shot — 좋은 시나리오 예시 2~3개를 프롬프트에 포함
개선 2: Chain-of-Thought — "단계별로 생각한 뒤 JSON을 출력하세요"
개선 3: 시스템 프롬프트 분리 — ConversationAgent의 페르소나를 더 구체적으로 정의
```

---

## 7. 발표 Q&A 예상 답변

**Q. Claude를 선택한 이유는?**  
A. GPT-4와 비교해 한국어 처리 품질이 동급이며, API 가격 대비 성능이 우수하다.  
특히 Haiku 모델은 응답 속도가 매우 빠르고 비용이 낮아 실시간 대화 앱에 적합하다.

**Q. API 키가 앱에 있으면 위험하지 않나?**  
A. 맞다. 현재는 프로토타입이라 클라이언트에 있지만, 최종 버전에서는  
Supabase Edge Function(서버)을 통해 API 키를 서버 환경변수로 관리한다.

**Q. 4개 Agent가 서로 어떻게 연결되나?**  
A. 데이터 객체를 통해 연결된다. ScenarioAgent → `Scenario` 모델 생성 →  
ConversationAgent가 이를 받아 시스템 프롬프트로 활용 → 대화 종료 후  
FeedbackAgent에 전체 대화 기록 전달 → AnalysisAgent에 피드백 리스트 전달.

**Q. Claude Code(CLI)와 Claude(API)는 다른 건가?**  
A. 다르다. Claude API는 앱 안에서 영어 시나리오를 만들기 위해 호출하는 것이고,  
Claude Code는 이 앱의 코드를 작성할 때 사용하는 개발 도구다.  
둘 다 같은 Claude 모델을 기반으로 하지만 용도가 완전히 다르다.

---

*작성일: 2026-05-24 | MEF 팀원 A*
