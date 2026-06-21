# MEF — My English Friend

> AI 기반 영어 회화 트레이너 모바일 앱 (Flutter)

---

## 앱 소개

**MEF(My English Friend)** 는 원하는 상황을 입력하면 AI가 대화 파트너가 되어 실전 영어를 연습하고,
대화 후 문법·표현·자연스러움에 대한 종합 피드백을 제공하는 모바일 앱입니다.

기존 영어 앱과의 차이점:
- 정해진 대본이 아닌 **사용자가 직접 상황을 입력**
- AI가 그 상황에 맞는 시나리오를 생성한 뒤 **실시간 대화 진행**
- 대화 종료 후 **즉각적이고 구체적인 피드백** 제공
- 누적 데이터로 **개인 약점 패턴 분석** [유료]

---

## 기술 스택

| 레이어 | 기술 | 역할 |
|--------|------|------|
| 모바일 프레임워크 | Flutter 3.44.1 (Dart) | Android·iOS·Windows 앱 |
| AI API | Google Gemini 2.5 Flash | 4개 Agent 처리 |
| 상태 관리 | Riverpod 2.6.1 | 전역 상태 관리 |
| 라우팅 | go_router 14 | 선언적 라우팅 |
| 인증 | Mock (메모리 Map) | test@mef.com / test1234 |
| DB | 없음 (Riverpod 메모리) | 앱 종료 시 초기화 |

---

## 설치 및 실행

### 사전 준비

```bash
flutter --version   # Flutter 3.44.1 이상 필요
flutter doctor      # 환경 점검
```

### 실행

```bash
# 1. 저장소 클론
git clone https://github.com/Gyun-Ryeong/AppPrograming.git
cd AppPrograming

# 2. 패키지 설치
flutter pub get

# 3. API 키 설정 (lib/constants/api_config.dart 생성 — .gitignore 적용됨)
# ApiConfig.apiUrl에 Gemini API 엔드포인트 입력

# 4. 앱 실행 (Windows 권장 — Chrome은 CORS로 Gemini API 차단됨)
flutter run -d windows
```

자세한 설정 방법은 **[docs/setup.md](docs/setup.md)** 를 참고하세요.

---

## 프로젝트 구조

```
mef/
├── lib/                    # Dart 소스 코드
│   ├── main.dart           # 앱 진입점
│   ├── screens/            # 화면 위젯 (UI만 담당)
│   │   ├── auth/           # 로그인, 회원가입
│   │   ├── home/           # 홈 화면
│   │   ├── scenario/       # 상황 입력, 시나리오 확인
│   │   ├── conversation/   # 채팅 화면
│   │   ├── feedback/       # 피드백 결과
│   │   ├── history/        # 대화 기록
│   │   └── analysis/       # 약점 분석 [유료]
│   ├── services/           # AI Agent / 외부 통신 (API 호출은 여기서만)
│   ├── providers/          # Riverpod 상태 관리
│   ├── models/             # 데이터 모델 (Scenario, Message, Feedback 등)
│   ├── router/             # go_router 라우팅 설정
│   ├── widgets/            # 재사용 공통 위젯
│   └── constants/          # 색상, 문자열, API 설정 등 상수
├── test/                   # 테스트 코드
├── docs/                   # 개발 문서
├── .planning/              # 기획 문서 + ADR + Wiki
│   ├── decisions/          # ADR-0001~0005 기술 결정 기록
│   └── wiki/               # 프로젝트 암묵지·시행착오 위키
└── AGENTS.md               # AI Agent·Rules·Skills·Commands 단일 통합 정책 파일
```

> **운영 원칙**: 이 프로젝트는 **단일 정책 파일(AGENTS.md)** 과 **위키 기반 암묵지 관리(.planning/wiki/)** 를 운영한다.
> AGENTS.md 하나로 agent 정의·skills·rules·commands를 통합 관리해 팀원과 AI 모두 일관된 작업 맥락을 공유한다.

---

## AI Agent 구조

```
사용자 입력 (상황 텍스트)
        │
        ▼
  ScenarioAgent ──────→ 시나리오 생성 (background / user_role / ai_role / goal)
        │
        ▼
ConversationAgent ──────→ 실시간 대화 진행 (맥락 유지, system_instruction 활용)
        │
        ▼
  FeedbackAgent ──────→ 종합 피드백 (문법 오류 / 표현 제안 / 자연스러움 점수)
        │
        ▼
  AnalysisAgent ──────→ 약점 패턴 누적 분석 [유료]
```

모든 Agent는 `lib/services/` 에서 Google Gemini 2.5 Flash API를 직접 호출한다.
API 키는 `lib/constants/api_config.dart` (`.gitignore` 적용 — 저장소에 포함되지 않음).

---

## 주요 기능 현황

| 기능 | 설명 | 상태 |
|------|------|------|
| 시나리오 생성 | 상황 입력 → AI가 배경/역할/목표 JSON 생성 | ✅ 완료 |
| 실시간 대화 | AI 파트너와 영어로 대화, 히스토리 유지 | ✅ 완료 |
| 피드백 | 문법 오류 · 표현 개선 · 자연스러움 점수 | ✅ 완료 |
| 대화 기록 | 과거 세션 및 피드백 다시 보기 | ✅ 완료 |
| 약점 분석 | 누적 오류 패턴 분석 리포트 [유료] | ✅ 완료 |

---

## 문서

| 문서 | 설명 |
|------|------|
| [AGENTS.md](AGENTS.md) | **통합 정책 파일** — agent/skills/rules/commands 단일 파일 관리 |
| [docs/setup.md](docs/setup.md) | 개발 환경 설정 (zero → flutter run) |
| [docs/architecture.md](docs/architecture.md) | 시스템 아키텍처 및 Mermaid 다이어그램 |
| [docs/testing.md](docs/testing.md) | 테스트 전략 및 수동 체크리스트 |
| [docs/performance.md](docs/performance.md) | 성능 최적화 (maxOutputTokens, responseMimeType 등) |
| [docs/deploy.md](docs/deploy.md) | 빌드 및 배포 절차 |
| [.planning/wiki/](/.planning/wiki/) | **프로젝트 위키** — 시행착오·의사결정·용어 사전 암묵지 관리 |
| [.planning/decisions/](/.planning/decisions/) | ADR-0001~0005 기술 선택 근거 |

---

> 바이브 코딩 수업 과제로 진행한 프로젝트입니다.
> AI Agent(Claude Code)가 코드·문서 생성을 보조하며,
> 모든 결과물은 개발자가 직접 검토하고 발표에서 설명할 수 있는 내용을 기반으로 합니다.
