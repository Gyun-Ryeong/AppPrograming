# MEF — My English Friend

> AI 기반 영어 회화 트레이너 모바일 앱 (Flutter)

---

## 앱 소개

**MEF(My English Friend)** 는 원하는 상황을 입력하면 AI가 대화 파트너가 되어 실전 영어를 연습하고, 대화 후 문법·표현·자연스러움에 대한 종합 피드백을 제공하는 모바일 앱입니다.

기존 영어 앱과의 차이점:
- 정해진 대본이 아닌 **사용자가 직접 상황을 입력**
- AI가 그 상황에 맞는 시나리오를 생성한 뒤 **실시간 대화 진행**
- 대화 종료 후 **즉각적이고 구체적인 피드백** 제공
- 누적 데이터로 **개인 약점 패턴 분석** (유료)

---

## 기술 스택

| 레이어 | 기술 | 역할 |
|--------|------|------|
| 모바일 프레임워크 | Flutter 3.x (Dart) | iOS / Android 앱 |
| 인증 / DB | Supabase | 사용자 인증, PostgreSQL DB |
| AI API | Anthropic Claude | 4개 Agent 처리 |
| 상태 관리 | Riverpod | 전역 상태 관리 |
| 네비게이션 | go_router | 선언적 라우팅 |
| AI 프록시 | Supabase Edge Functions (TypeScript) | API 키 보호 |

---

## 설치 및 실행

### 사전 준비

```bash
flutter --version   # Flutter 3.x 이상 필요
flutter doctor      # 환경 점검
```

### 실행

```bash
# 1. 저장소 클론
git clone https://github.com/Gyun-Ryeong/AppPrograming.git
cd AppPrograming

# 2. 패키지 설치
flutter pub get

# 3. 앱 실행
flutter run
```

자세한 설정 방법은 **[docs/setup.md](docs/setup.md)** 를 참고하세요.

---

## 프로젝트 구조

```
mef/
├── lib/                    # Dart 소스 코드
│   ├── main.dart           # 앱 진입점
│   ├── screens/            # 화면 위젯
│   │   ├── auth/           # 로그인, 회원가입
│   │   ├── home/           # 홈 화면
│   │   ├── scenario/       # 상황 입력, 시나리오 확인
│   │   ├── conversation/   # 채팅 화면
│   │   ├── feedback/       # 피드백 결과
│   │   ├── history/        # 대화 기록
│   │   └── analysis/       # 약점 분석 (유료)
│   ├── services/           # AI Agent / Supabase API 호출 (외부 통신은 여기서만)
│   ├── providers/          # Riverpod 상태 관리
│   ├── models/             # 데이터 모델 (Scenario, Message, Feedback 등)
│   ├── router/             # go_router 라우팅 설정
│   ├── widgets/            # 재사용 공통 위젯
│   └── constants/          # 색상, 문자열 등 공통 상수
├── test/                   # 테스트 코드
├── android/                # Android 네이티브 설정
├── ios/                    # iOS 네이티브 설정
├── pubspec.yaml            # 패키지 의존성
├── docs/                   # 개발 문서
└── .planning/              # 기획 문서
```

---

## AI Agent 구조

```
사용자 입력 (상황 텍스트)
        │
        ▼
  ScenarioAgent ──────→ 시나리오 생성 (배경 / 역할 / 목표)
        │
        ▼
ConversationAgent ──────→ 실시간 대화 진행 (맥락 유지)
        │
        ▼
  FeedbackAgent ──────→ 종합 피드백 (문법 / 표현 / 자연스러움)
        │
        ▼
  AnalysisAgent ──────→ 약점 패턴 누적 분석 [유료]
```

모든 Agent는 `lib/services/` 에서 Supabase Edge Function을 통해 Anthropic Claude API를 호출합니다.  
API 키는 Edge Function 환경변수에만 존재하며 클라이언트에 노출되지 않습니다.

---

## 주요 기능 현황

| 기능 | 설명 | 상태 |
|------|------|------|
| 시나리오 생성 | 상황 입력 → AI가 배경/역할/목표 생성 | 🔧 개발 중 |
| 실시간 대화 | AI 파트너와 영어로 대화 | 🔧 개발 중 |
| 피드백 | 문법 오류 · 표현 개선 · 자연스러움 점수 | 🔧 개발 중 |
| 대화 기록 | 과거 세션 및 피드백 다시 보기 | 🔧 개발 중 |
| 약점 분석 | 누적 오류 패턴 분석 리포트 (유료) | 📋 기획됨 |

---

## 문서

| 문서 | 설명 |
|------|------|
| [docs/setup.md](docs/setup.md) | 개발 환경 설정 (zero → flutter run) |
| [docs/architecture.md](docs/architecture.md) | 시스템 아키텍처 및 Mermaid 다이어그램 |
| [.planning/00-vision.md](.planning/00-vision.md) | 프로젝트 비전 및 목표 |
| [.planning/01-requirements.md](.planning/01-requirements.md) | 기능 요구사항 (MoSCoW) |
| [.planning/02-wbs.md](.planning/02-wbs.md) | WBS |
| [.planning/04-schedule.md](.planning/04-schedule.md) | 7주 개발 일정 |
| [.planning/decisions/ADR-0001](.planning/decisions/ADR-0001-react-native-vs-flutter.md) | Flutter 선택 근거 (ADR) |

---

> 바이브 코딩 수업 과제로 진행 중인 프로젝트입니다.
> AI Agent(Claude Code)가 코드와 문서 생성을 보조하며,
> 모든 결과물은 개발자가 직접 검토하고 설명할 수 있는 내용을 기반으로 합니다.
