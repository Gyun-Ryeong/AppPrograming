# AGENTS.md — MEF 프로젝트 AI Agent 운영 지침

> 이 파일은 Claude Code CLI가 이 저장소에서 작업할 때 자동으로 읽는 지침서다.
> 새로운 세션을 시작하면 반드시 이 파일부터 읽고 프로젝트 맥락을 파악할 것.

---

## 프로젝트 한 줄 요약

**MEF(My English Friend)** — 사용자가 상황을 입력하면 AI가 시나리오를 생성하고 실시간 대화 후 피드백을 제공하는 Flutter 기반 영어 회화 트레이너 앱.

---

## 현재 상태 (2026-05-24 기준)

| 영역 | 상태 | 비고 |
|------|------|------|
| 기획 문서 | ✅ 완료 | `.planning/` 참고 |
| 아키텍처 문서 | ✅ 완료 | `docs/architecture.md` 참고 |
| Flutter 프로젝트 | ✅ 실행됨 | Flutter 3.35.3 / Dart 3.9.2 |
| 홈 화면 | ✅ 완료 | 카드형 메뉴 UI |
| 시나리오 입력/결과 화면 | ✅ 완료 | 팀원 A 구현 |
| 공통 위젯 3개 | ✅ 완료 | chat_bubble, primary_button, loading_overlay |
| ADR 문서 | ✅ 완료 | ADR-0001, 0002, 0003 작성됨 |
| docs/deploy.md | ✅ 완료 | 과제 +4점 조건 충족 |
| docs/testing.md | ✅ 완료 | 과제 +4점 조건 충족 |
| BONUS.md | ✅ 초안 완료 | 가산점 신청 트래킹 |
| **채팅 화면** | ❌ 미구현 | 팀원 B 담당 |
| **피드백 화면** | ❌ 미구현 | 팀원 B 담당 |
| **대화 기록 화면** | ❌ 미구현 | 팀원 B 담당 |

### 아키텍처 변경 이력 (중요)

> Supabase 제거 결정 (2026-05-24)
> Claude API를 `http` 패키지로 **직접 호출**하는 방식으로 변경됨.
> 데이터는 DB 없이 **Riverpod 메모리**에만 저장 (앱 종료 시 초기화).

| 항목 | 변경 전 | 변경 후 |
|------|---------|---------|
| 백엔드 | Supabase | 없음 |
| AI 호출 | Supabase Edge Function | http 패키지 직접 호출 |
| 인증 | Supabase Auth | 메모리 Mock (test@mef.com / test1234) |
| 데이터 저장 | PostgreSQL | Riverpod 메모리 |

### 현재 패키지 (pubspec.yaml)

| 패키지 | 용도 |
|--------|------|
| `flutter_riverpod` | 전역 상태 관리 |
| `http` | Claude API 직접 호출 |
| `go_router` | 선언적 라우팅 |

### 수업 일정 (10~15주차)

| 주차 | 목표 | 현재 |
|------|------|------|
| 10주차 | 기획·일정 수립 | ✅ 완료 |
| 11주차 | 설계·환경 구축 | ✅ 완료 |
| 12주차 | 핵심 기능 1 + **중간 발표** | 🔄 진행 중 |
| 13주차 | 핵심 기능 2 + 테스트 | ❌ 미시작 |
| 14주차 | 마감·배포·문서 | ❌ 미시작 |
| 15주차 | **최종 발표** | ❌ 미시작 |

---

## 기술 스택

| 레이어 | 기술 |
|--------|------|
| 모바일 | Flutter (Dart) |
| 인증 / DB | 없음 (Riverpod 메모리만 사용) |
| AI API | Anthropic Claude (`http` 패키지로 직접 호출) |
| 상태 관리 | Riverpod (`flutter_riverpod`) |
| 네비게이션 | go_router |
| API 설정 | `lib/constants/api_config.dart` |

---

## 프로젝트 구조

```
lib/
├── main.dart               # 앱 진입점 (현재 기본 카운터 앱)
├── screens/                # 화면 위젯 — 각 화면은 단일 책임
│   ├── auth/               # 로그인, 회원가입
│   ├── home/               # 홈 화면
│   ├── scenario/           # 상황 입력, 시나리오 확인
│   ├── conversation/       # 채팅 화면
│   ├── feedback/           # 피드백 결과
│   ├── history/            # 대화 기록
│   └── analysis/           # 약점 분석 (유료)
├── services/               # ★ AI 호출은 반드시 여기서만
│   ├── scenario_service.dart
│   ├── conversation_service.dart
│   ├── feedback_service.dart
│   └── analysis_service.dart
├── providers/              # Riverpod 상태 관리
├── models/                 # 데이터 모델 (이미 작성됨)
├── router/                 # go_router 설정
├── widgets/                # 재사용 공통 위젯
└── constants/              # 색상(app_colors.dart), 문자열(app_strings.dart)
```

---

## AI Agent 흐름

```
사용자 입력 → ScenarioAgent → ConversationAgent → FeedbackAgent → AnalysisAgent(유료)
```

Claude API를 `http` 패키지로 **클라이언트에서 직접 호출**한다.
API 키는 `lib/constants/api_config.dart`의 `claudeApiKey`에 설정.
> ⚠️ 수업 과제용 임시 방식. 실제 서비스라면 서버 프록시 필수.

---

## 코딩 규칙 (반드시 지킬 것)

1. **한국어 주석 필수** — 모든 함수/클래스에 한국어 주석 (발표 설명 대비)
2. **AI 호출은 services/ 에서만** — 화면 위젯에서 직접 API 호출 금지
3. **하드코딩 금지** — 문자열은 `AppStrings`, 색상은 `AppColors` 사용
4. **파일명 snake_case** — Dart 관례 (예: `scenario_service.dart`)
5. **단일 책임** — 화면 위젯은 UI만, 로직은 service/provider로 분리

---

## 팀 구성 및 역할

이 프로젝트는 **2인 팀**이 바이브 코딩으로 개발 중이다.

- **팀원 A**: 인증 + ScenarioAgent + AnalysisAgent
  → `.github/agents/task-a.md` 참고
- **팀원 B**: 공통 UI + ConversationAgent + FeedbackAgent + 기록
  → `.github/agents/task-b.md` 참고

**중요**: 두 사람 모두 발표에서 전체 코드를 설명할 수 있어야 한다.
본인 담당이 아닌 코드도 반드시 읽고 이해할 것.

---

## 참고 문서

- `docs/architecture.md` — 시스템 아키텍처 + Mermaid 다이어그램
- `docs/setup.md` — 개발 환경 설정 (zero → flutter run)
- `.planning/04-schedule.md` — 7주 개발 일정
- `.planning/decisions/ADR-0001-react-native-vs-flutter.md` — Flutter 선택 근거

---

## Claude에게 요청할 때 유용한 컨텍스트

새 세션에서 작업을 시작할 때 아래 문장을 첫 메시지에 붙이면 빠르게 컨텍스트를 공유할 수 있다:

> "AGENTS.md와 .github/agents/task-[a 또는 b].md를 읽고 내 작업 범위를 파악한 뒤 [작업 내용]을 도와줘."
