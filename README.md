# MEF — My English Friend

> AI 기반 영어 회화 트레이너 모바일 앱

---

## 앱 소개

**MEF(My English Friend)** 는 원하는 상황을 입력하면 AI가 대화 파트너가 되어 실전 영어를 연습하고, 대화 후 문법·표현·자연스러움에 대한 종합 피드백을 제공하는 모바일 앱입니다.

기존 영어 앱과의 차이점:
- 정해진 대본이 아닌 **사용자가 직접 상황을 입력**
- AI가 그 상황에 맞는 시나리오를 생성한 뒤 **실시간 대화 진행**
- 대화 종료 후 **즉각적이고 구체적인 피드백** 제공
- 누적 데이터로 **개인 약점 패턴 분석** (유료)

---

## 주요 기능

| 기능 | 설명 | 상태 |
|------|------|------|
| 시나리오 생성 | 상황 입력 → AI가 배경/역할/목표 생성 | 🔧 개발 중 |
| 실시간 대화 | AI 파트너와 영어로 대화 | 🔧 개발 중 |
| 피드백 | 문법 오류 · 표현 개선 · 자연스러움 점수 | 🔧 개발 중 |
| 대화 기록 | 과거 세션 및 피드백 다시 보기 | 🔧 개발 중 |
| 약점 분석 | 누적 오류 패턴 분석 리포트 (유료) | 📋 기획됨 |

---

## AI Agent 구조

```
사용자 입력
    │
    ▼
ScenarioAgent ──→ 시나리오 생성 (배경 / 역할 / 목표)
    │
    ▼
ConversationAgent ──→ 실시간 대화 (맥락 유지)
    │
    ▼
FeedbackAgent ──→ 종합 피드백 (문법 / 표현 / 자연스러움)
    │
    ▼
AnalysisAgent ──→ 약점 패턴 분석 [유료]
```

---

## 기술 스택

| 레이어 | 기술 |
|--------|------|
| 모바일 | React Native + Expo |
| 인증 / DB | Supabase |
| AI | Anthropic Claude API |
| 언어 | TypeScript |

---

## 시작하기

자세한 설정 방법은 **[docs/setup.md](docs/setup.md)** 를 참고하세요.

```bash
# 의존성 설치
npm install

# 개발 서버 시작
npm start
```

스마트폰에 **Expo Go** 앱을 설치한 뒤, 터미널의 QR 코드를 스캔하면 실기기에서 바로 실행됩니다.

---

## 프로젝트 구조

```
mef/
├── app/          # 화면 라우팅 (Expo Router)
├── src/
│   ├── components/   # 재사용 UI 컴포넌트
│   ├── constants/    # 색상, 폰트 등 공통 상수
│   ├── context/      # 전역 상태 관리
│   ├── hooks/        # 커스텀 훅
│   └── services/     # AI Agent 및 API 호출 레이어
├── assets/       # 이미지, 폰트 등 정적 파일
└── docs/         # 개발 문서
```

---

## 문서

| 문서 | 설명 |
|------|------|
| [docs/setup.md](docs/setup.md) | 개발 환경 설정 (zero → run) |
| [docs/architecture.md](docs/architecture.md) | 시스템 아키텍처 및 다이어그램 |
| [.planning/00-vision.md](.planning/00-vision.md) | 프로젝트 비전 및 목표 |
| [.planning/01-requirements.md](.planning/01-requirements.md) | 기능 요구사항 (MoSCoW) |
| [.planning/02-wbs.md](.planning/02-wbs.md) | WBS |
| [.planning/04-schedule.md](.planning/04-schedule.md) | 7주 개발 일정 |
| [.planning/decisions/](.planning/decisions/) | 기술 결정 기록 (ADR) |

---

## 개발 현황

> 바이브 코딩 수업 과제로 진행 중인 프로젝트입니다.
> AI Agent(Claude Code)가 코드와 문서 생성을 보조하며,
> 모든 결과물은 개발자가 직접 검토하고 이해한 내용을 기반으로 합니다.
