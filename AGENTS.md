<!--
  설계 의도: 왜 단일 파일인가?
  ─────────────────────────────────────────────────────────────
  Claude Code CLI는 새 세션을 시작할 때 AGENTS.md를 첫 번째로 읽는다.
  파일이 여러 곳에 분산되면 AI는 "어느 파일이 진실인가"를 판단하지 못하고,
  팀원은 업데이트할 파일을 찾느라 시간을 낭비한다.

  단일 파일 전략의 장점:
  1. 단일 진실 공급원(Single Source of Truth) — 규칙 충돌 없음
  2. 새 세션 시작 시 컨텍스트 복구가 한 번의 Read로 끝남
  3. agents / skills / rules / commands 간의 교차 참조가 자연스러움
  4. 팀원 A·B가 같은 파일을 공유하므로 협업 오해 감소

  파일 구조:
  §1 PROJECT    — 프로젝트 한 줄 요약 + 현재 상태
  §2 AGENTS     — 4개 AI Agent 역할 · 입출력 · 실제 프롬프트 구조
  §3 SKILLS     — 자주 쓰는 작업의 step-by-step 절차
  §4 RULES      — 코딩 규칙 · 커밋 컨벤션 · 보안 체크리스트
  §5 COMMANDS   — 자주 쓰는 Flutter / Git 명령어 모음
-->

# AGENTS.md — MEF 통합 운영 지침서

> **단일 파일 원칙**: 이 파일 하나가 agent 정의, skills, rules, commands를 모두 담는다.
> 새 세션 시작 → 이 파일 읽기 → 작업 시작. 다른 파일 먼저 찾지 말 것.

---

## §1 PROJECT — 프로젝트 개요

**MEF(My English Friend)** — 사용자가 상황을 입력하면 AI가 시나리오를 생성하고
실시간 대화 후 피드백을 제공하는 Flutter 기반 영어 회화 트레이너 앱.

| 항목 | 값 |
|------|-----|
| 플랫폼 | Flutter 3.44.1 / Dart ^3.11.5 |
| 상태 관리 | Riverpod 2.6.1 |
| 라우팅 | go_router 14 |
| AI API | Google Gemini 2.5 Flash (직접 호출) |
| 인증 | Mock (메모리 Map, test@mef.com / test1234) |
| DB | 없음 (Riverpod 메모리, 앱 종료 시 초기화) |

### 현재 구현 상태

| 화면 / 기능 | 상태 | 파일 |
|------------|------|------|
| 로그인·회원가입 | ✅ | `screens/auth/` |
| 홈 화면 | ✅ | `screens/home/` |
| 시나리오 입력·결과 | ✅ | `screens/scenario/` |
| 채팅 화면 | ✅ | `screens/conversation/` |
| 피드백 화면 | ✅ | `screens/feedback/` |
| 대화 기록 | ✅ | `screens/history/` |
| 약점 분석 (유료) | ✅ | `screens/analysis/` |
| ADR | ✅ | `.planning/decisions/ADR-0001~0005` |
| 발표 자료 | ✅ | `index.html` (GitHub Pages) |

---

## §2 AGENTS — 4개 AI Agent 정의

```
사용자 상황 입력
      ↓
ScenarioAgent ── 시나리오 생성 (background / roles / goal)
      ↓
ConversationAgent ── 시나리오 맥락 유지하며 실시간 대화
      ↓
FeedbackAgent ── 대화 종료 후 문법/표현/자연스러움 종합 피드백
      ↓
AnalysisAgent ── 누적 세션 분석, 약점 패턴 리포트 [유료]
```

모든 Agent는 **`lib/services/`** 에서만 Gemini API를 호출한다.
API 키는 `lib/constants/api_config.dart` — **절대 커밋 금지**.

---

### Agent 1 — ScenarioAgent

**파일**: `lib/services/scenario_service.dart`
**역할**: 사용자 자유 입력을 구조화된 시나리오 JSON으로 변환

| 항목 | 값 |
|------|-----|
| 입력 | situation(String), difficulty(String), category(String) |
| 출력 | `Scenario` 모델 (id, background, user_role, ai_role, goal) |
| maxOutputTokens | 1024 |
| responseMimeType | `application/json` (필수) |

**프롬프트 구조**:
```
You are a scenario generator for English conversation practice.
Based on the user's input, respond ONLY with a JSON object:
{
  "id": "unique_id_001",
  "background": "Scene description in English",
  "user_role": "User's role in English",
  "ai_role": "AI partner's role in English",
  "goal": "Conversation goal in English"
}

Situation: {situation}
Difficulty: {difficulty}
Category: {category}

Respond with JSON only. No explanation, no markdown.
```

---

### Agent 2 — ConversationAgent

**파일**: `lib/services/conversation_service.dart`
**역할**: 시나리오 맥락을 유지하며 실시간 영어 대화 진행

| 항목 | 값 |
|------|-----|
| 입력 | Scenario 객체 + List\<Message\> 히스토리 + 현재 메시지 |
| 출력 | AI 응답 문자열 (영어 자유 텍스트) |
| maxOutputTokens | 512 |
| responseMimeType | 없음 (자유 텍스트 응답) |
| Gemini 특이사항 | `system_instruction` 필드 사용 |

**시스템 프롬프트 구조**:
```
You are an English conversation practice partner.

[Background]: {scenario.background}
[Your role]: {scenario.aiRole}
[User's role]: {scenario.userRole}
[Goal]: {scenario.goal}

Rules:
- Respond in English only
- Stay within the scenario context
- Keep responses concise (2-4 sentences)
- Be encouraging and natural
```

**히스토리 변환**: `List<Message>` → Gemini `contents` 배열 (`role: user/model`)

---

### Agent 3 — FeedbackAgent

**파일**: `lib/services/feedback_service.dart`
**역할**: 대화 종료 후 문법 오류, 표현 개선, 자연스러움 점수 제공

| 항목 | 값 |
|------|-----|
| 입력 | List\<Message\> (사용자 메시지만 분석) |
| 출력 | `Feedback` 모델 (grammar_errors, expression_suggestions, naturalness_score, overall_comment) |
| maxOutputTokens | 2048 |
| responseMimeType | `application/json` (필수) |

**프롬프트 구조**:
```
You are an English language tutor analyzing a student's conversation practice.
Analyze the following student messages and respond ONLY with a JSON object:
{
  "grammar_errors": [
    {
      "original": "the exact sentence the student wrote",
      "corrected": "the corrected version",
      "explanation": "설명 (한국어로)"
    }
  ],
  "expression_suggestions": ["More natural alternative 1", "..."],
  "naturalness_score": 75,
  "overall_comment": "전반적인 평가 (한국어로, 2-3문장, 격려 포함)"
}

Student messages:
{userMessages}

Rules:
- naturalness_score: 0-100 정수
- grammar_errors: 실제 오류만 (없으면 빈 배열)
- expression_suggestions: 2-3개
- Respond with JSON only.
```

---

### Agent 4 — AnalysisAgent [유료]

**파일**: `lib/services/analysis_service.dart`
**역할**: 누적 대화 세션에서 반복 약점 패턴을 발굴하고 다음 연습을 추천

| 항목 | 값 |
|------|-----|
| 입력 | List\<ConversationSession\> 전체 누적 세션 |
| 출력 | `AnalysisReport` 모델 (total_sessions, weakness_patterns, improvement_trend, recommended_scenario) |
| maxOutputTokens | 4096 |
| temperature | 0.3 (안정적 분석 우선) |
| responseMimeType | `application/json` (필수) |
| 특이사항 | 세션 0개면 API 호출 없이 기본값 즉시 반환 |

**프롬프트 구조**:
```
Analyze these English practice messages and return ONLY this JSON:
{
  "total_sessions": {sessionCount},
  "weakness_patterns": [
    {"category": "시제 오류", "frequency": 0.4, "examples": ["I am go to school"]}
  ],
  "improvement_trend": "stable",
  "recommended_scenario": "카페에서 주문하기"
}

Student messages:
{allUserMessages}

weakness_patterns max 3 items. All text values in Korean except examples.
```

---

## §3 SKILLS — 자주 쓰는 작업 절차

### Skill A — 새 화면 추가

```
1. lib/screens/{기능}/ 디렉토리 생성
2. {기능}_screen.dart 파일 생성
   - 맨 위에 한국어 주석으로 화면 역할 설명
   - StatelessWidget 또는 ConsumerWidget 선택
   - UI만 담당, API 호출 금지
3. lib/router/app_router.dart 에 GoRoute 추가
   - AppRoutes 상수에 경로 문자열 추가
   - builder에 새 화면 import
4. 필요하면 lib/providers/{기능}_provider.dart 생성
   - Notifier(동기) 또는 AsyncNotifier(비동기) 선택
   - service 호출은 provider에서만
5. git commit: "feat: {기능} 화면 구현"
```

### Skill B — 새 서비스(AI 호출) 추가

```
1. lib/services/{기능}_service.dart 생성
2. 파일 맨 위에 "// {AgentName}: 역할 설명" 한국어 주석
3. Gemini API 호출 기본 패턴:

   final response = await http.post(
     Uri.parse(ApiConfig.apiUrl),
     headers: {'Content-Type': 'application/json'},
     body: jsonEncode({
       'contents': [
         {
           'role': 'user',
           'parts': [{'text': _buildPrompt(...)}],
         }
       ],
       'generationConfig': {
         'maxOutputTokens': {N},
         'responseMimeType': 'application/json',  ← JSON 반환 시 필수
       },
     }),
   );

4. 에러 처리 필수:
   - 429: throw Exception('서버가 혼잡합니다. 잠시 후 다시 시도해주세요.')
   - 기타: throw Exception('{기능} 실패: ${response.statusCode}')
5. JSON 파싱 실패 시 try/catch 로 기본값 반환 (앱 크래시 방지)
6. lib/providers/{기능}_provider.dart 에서 서비스 호출
7. git commit: "feat: {기능}Agent 서비스 구현"
```

### Skill C — 새 모델 추가

```
1. lib/models/{이름}.dart 생성
2. fromJson(Map<String, dynamic>) 팩토리 생성자 구현
3. toJson() 메서드 구현 (히스토리 저장 필요 시)
4. 불변 클래스 원칙: final 필드, const 생성자
5. git commit: "feat: {이름} 모델 추가"
```

### Skill D — 기존 화면에 AI 기능 연결

```
1. provider 파일에서 AsyncNotifier 상태 확인
2. screen에서 ref.watch(provider) 로 AsyncValue 구독
3. AsyncValue.when(
     data: (value) => 결과 위젯,
     loading: () => LoadingOverlay(),
     error: (e, _) => 에러 메시지 위젯,
   ) 패턴 사용
4. 버튼 onPressed → ref.read(provider.notifier).메서드() 호출
```

---

## §4 RULES — 코딩 규칙

### 코딩 규칙

| 번호 | 규칙 | 이유 |
|------|------|------|
| R1 | **한국어 주석 필수** — 모든 함수·클래스에 | 발표 시 설명 가능해야 함 |
| R2 | **AI 호출은 services/ 에서만** | 화면이 API에 직접 의존하면 테스트·교체 불가 |
| R3 | **하드코딩 금지** — 문자열은 `AppStrings`, 색상은 `AppColors` | 수정 시 한 곳만 고치면 됨 |
| R4 | **파일명 snake_case** — `scenario_service.dart` | Dart 공식 관례 |
| R5 | **화면은 UI만** — 비즈니스 로직은 provider, API는 service | MVVM 레이어 분리 |
| R6 | **상태 관리 Riverpod** — AsyncNotifier(비동기), Notifier(동기) | 선언적, 컴파일 타임 안전성 |
| R7 | **라우팅 go_router** — `context.go()` / `context.push()` | `Navigator.push` 금지 |
| R8 | **responseMimeType 필수** — JSON 반환 Agent에 | Gemini 2.5 Flash thinking 모델이 JSON 외 텍스트 포함 가능 |

### 레이어 의존 방향

```
screens/ → providers/ → services/ → Gemini API
  (UI)       (상태)       (통신)

models/  ← 모든 레이어에서 참조 (의존 방향 없음)
```

레이어를 역방향으로 참조하는 코드(예: service에서 BuildContext 사용)는 작성 금지.

### 커밋 컨벤션

형식: `type: 한국어 한 줄 설명 (50자 이내)`

| type | 상황 |
|------|------|
| `feat` | 새 기능 추가 |
| `fix` | 버그 수정 |
| `chore` | 설정, 의존성, gitignore 등 |
| `docs` | 문서 변경 (ADR, README 등) |
| `refactor` | 기능 변경 없는 코드 정리 |
| `style` | UI/스타일만 변경 |

예시:
```
feat: 채팅 화면 ConversationAgent 연동
fix: 시나리오 JSON 파싱 실패 수정
docs: ADR-0005 Gemini API 선택 근거 추가
chore: api_config.dart gitignore 추가
```

### 보안 체크리스트 (푸시 전 필수)

`git status`에서 아래 파일이 staged 상태이면 **절대 커밋·푸시 금지**:

```
lib/constants/api_config.dart      ← Gemini API 키
lib/constants/supabase_config.dart ← Supabase 설정
android/key.properties             ← 서명 키 비밀번호
android/app/*.jks                  ← 서명 키스토어
.env, .env.*                       ← 환경변수 파일
```

---

## §5 COMMANDS — 자주 쓰는 명령어

### 앱 실행

```bash
# Windows 데스크톱 (CORS 없음, API 직접 호출 가능) ← 권장
flutter run -d windows

# Chrome 웹 (CORS로 Gemini API 직접 호출 차단됨)
flutter run -d chrome

# 연결된 기기 목록 확인
flutter devices

# 실행 중인 앱 모두 종료
flutter run 후 q 입력
```

### 빌드

```bash
# 릴리즈 빌드 (Windows)
flutter build windows

# 릴리즈 빌드 (APK)
flutter build apk --release

# 빌드 캐시 초기화 (빌드 오류 시)
flutter clean && flutter pub get
```

### 패키지 관리

```bash
# pubspec.yaml 변경 후
flutter pub get

# 패키지 버전 업그레이드
flutter pub upgrade

# 현재 패키지 목록
flutter pub deps
```

### Git 협업

```bash
# 작업 시작 전 최신 코드 받기 (필수)
git pull origin main

# 변경 파일 확인 (보안 파일 포함 여부 체크)
git status

# 스테이징
git add lib/screens/conversation/conversation_screen.dart
git add lib/services/conversation_service.dart

# 커밋
git commit -m "feat: 채팅 화면 ConversationAgent 연동"

# 푸시
git push origin main
```

### 디버깅

```bash
# 빌드 오류 상세 확인
flutter run -v

# Dart 분석 (타입 오류, 미사용 변수)
flutter analyze

# 코드 포맷팅
dart format lib/

# 테스트 실행
flutter test
```

### 발표 자료 배포 (GitHub Pages)

```bash
# index.html 수정 후
git add index.html
git commit -m "style: 발표 슬라이드 내용 수정"
git push origin main
# → GitHub Pages 자동 배포 (1~2분 소요)
```

---

## 참고 문서

| 문서 | 위치 | 내용 |
|------|------|------|
| 아키텍처 | `docs/architecture.md` | 시스템 구조 + Mermaid 다이어그램 |
| 개발 환경 설정 | `docs/setup.md` | zero → flutter run |
| 배포 | `docs/deploy.md` | 빌드 및 배포 절차 |
| 테스트 | `docs/testing.md` | 테스트 방법 및 체크리스트 |
| Flutter 선택 근거 | `.planning/decisions/ADR-0001` | 대안 비교 포함 |
| Riverpod 선택 근거 | `.planning/decisions/ADR-0002` | Provider·BLoC·GetX 비교 |
| 백엔드 제거 결정 | `.planning/decisions/ADR-0003` | Supabase 제거 이유 |
| Mock 인증 결정 | `.planning/decisions/ADR-0004` | 인증 방식 선택 |
| Gemini API 선택 | `.planning/decisions/ADR-0005` | OpenRouter 대신 Gemini 직접 |
| 프로젝트 규칙 | `CLAUDE.md` | Claude Code 전용 지침 |
