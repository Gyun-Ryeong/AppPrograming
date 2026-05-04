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

## 핵심 원칙 (절대 잊지 말 것)
이 프로젝트는 바이브 코딩 수업 과제이다.
AI가 생성한 모든 코드와 문서는
반드시 본인이 처음부터 끝까지 읽고
이해하지 못한 부분은 다시 질문해서
본인의 언어로 설명할 수 있어야 한다.

"AI가 만들었어요"는 발표에서 답이 되지 않는다.
