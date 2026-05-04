# MEF — WBS (Work Breakdown Structure)

> 3단계 깊이: 대분류 → 중분류 → 작업 항목

---

## 1. 프로젝트 관리

### 1.1 계획 수립
- 1.1.1 비전 및 요구사항 문서 작성
- 1.1.2 WBS 및 일정 수립
- 1.1.3 기술 스택 결정 및 ADR 작성

### 1.2 진행 관리
- 1.2.1 주차별 진행 상황 점검
- 1.2.2 리스크 식별 및 대응

### 1.3 발표 준비
- 1.3.1 중간 발표 자료 제작
- 1.3.2 최종 발표 자료 제작
- 1.3.3 데모 시나리오 준비

---

## 2. 환경 설정 및 인프라

### 2.1 개발 환경 구축
- 2.1.1 Flutter SDK 설치 및 `flutter doctor` 통과 확인
- 2.1.2 Android Studio / VS Code + Flutter 플러그인 설정
- 2.1.3 에뮬레이터(Android/iOS) 또는 실기기 연결 확인
- 2.1.4 Git 저장소 초기화 및 브랜치 전략 설정

### 2.2 백엔드 인프라
- 2.2.1 Supabase 프로젝트 생성 및 인증 설정
- 2.2.2 데이터베이스 스키마 설계 (users, sessions, messages, feedbacks)
- 2.2.3 Supabase Edge Functions 설정 (AI 프록시)

### 2.3 AI 연동 설정
- 2.3.1 Anthropic API 키 발급 및 Supabase 환경변수 설정
- 2.3.2 AI 서비스 레이어 기반 구조 작성 (lib/services/)
- 2.3.3 API 호출 에러 핸들링 및 로딩 상태 처리

---

## 3. 사용자 인증

### 3.1 회원가입 / 로그인
- 3.1.1 회원가입 화면 위젯 구현 (lib/screens/auth/)
- 3.1.2 로그인 화면 위젯 구현
- 3.1.3 supabase_flutter 패키지로 이메일/비밀번호 인증 연동

### 3.2 세션 관리
- 3.2.1 자동 로그인 (onAuthStateChange 스트림) 처리
- 3.2.2 로그아웃 기능 구현
- 3.2.3 인증 상태에 따른 라우팅 분기 처리 (go_router redirect)

---

## 4. 시나리오 생성 (ScenarioAgent)

### 4.1 입력 화면
- 4.1.1 상황 입력 TextField 위젯 구현
- 4.1.2 난이도 선택 위젯 구현 (초급/중급/고급 — SegmentedButton)
- 4.1.3 카테고리 선택 위젯 구현 (일상/비즈니스/여행/학업 — ChoiceChip)

### 4.2 AI 시나리오 생성
- 4.2.1 ScenarioAgent 프롬프트 설계
- 4.2.2 시나리오 생성 서비스 함수 작성 (lib/services/scenario_service.dart)
- 4.2.3 생성된 시나리오 파싱 및 Scenario 모델 매핑 (lib/models/scenario.dart)

### 4.3 시나리오 확인 화면
- 4.3.1 시나리오 결과 표시 위젯 구현
- 4.3.2 "대화 시작" 버튼 연결
- 4.3.3 시나리오 재생성 기능 구현

---

## 5. 실시간 대화 (ConversationAgent)

### 5.1 채팅 UI
- 5.1.1 채팅 화면 레이아웃 구현 (말풍선 ListView, 역방향 스크롤)
- 5.1.2 텍스트 입력창(TextField) 및 전송 버튼 구현
- 5.1.3 AI 응답 로딩 인디케이터 구현 (CircularProgressIndicator)

### 5.2 대화 로직
- 5.2.1 ConversationAgent 프롬프트 설계 (시스템 프롬프트 + 대화 히스토리)
- 5.2.2 대화 서비스 함수 작성 (lib/services/conversation_service.dart)
- 5.2.3 대화 히스토리 상태 관리 (Riverpod StateNotifier)

### 5.3 대화 종료
- 5.3.1 "대화 종료" 버튼 구현
- 5.3.2 대화 내용 Supabase DB 저장
- 5.3.3 피드백 생성 화면으로 자동 전환

---

## 6. 피드백 (FeedbackAgent)

### 6.1 피드백 생성
- 6.1.1 FeedbackAgent 프롬프트 설계 (문법/표현/자연스러움)
- 6.1.2 피드백 서비스 함수 작성 (lib/services/feedback_service.dart)
- 6.1.3 피드백 결과 파싱 및 Feedback 모델 매핑 (lib/models/feedback.dart)

### 6.2 피드백 화면
- 6.2.1 피드백 결과 표시 위젯 구현 (항목별 Card)
- 6.2.2 오류 문장 / 개선 문장 비교 표시 위젯
- 6.2.3 "다시 연습하기" / "홈으로" 버튼 구현

---

## 7. 대화 기록 관리

### 7.1 기록 목록
- 7.1.1 완료된 세션 목록 화면 구현 (ListView.builder)
- 7.1.2 세션별 날짜/시나리오 요약 표시 (ListTile)
- 7.1.3 Supabase에서 기록 조회 쿼리 작성

### 7.2 기록 상세
- 7.2.1 과거 대화 내용 다시 보기 화면 구현
- 7.2.2 과거 피드백 다시 보기 화면 구현

---

## 8. 약점 분석 (AnalysisAgent — 유료)

### 8.1 분석 로직
- 8.1.1 AnalysisAgent 프롬프트 설계
- 8.1.2 누적 피드백 데이터 집계 쿼리 작성
- 8.1.3 분석 서비스 함수 작성 (lib/services/analysis_service.dart)

### 8.2 분석 화면
- 8.2.1 약점 패턴 시각화 위젯 구현 (fl_chart 패키지 활용)
- 8.2.2 유료 기능 잠금 UI 및 구매 유도 화면

---

## 9. 앱 공통 요소

### 9.1 네비게이션
- 9.1.1 go_router 설정 (선언적 라우팅)
- 9.1.2 화면 경로(route) 상수 정의
- 9.1.3 인증 상태에 따른 redirect 처리

### 9.2 공통 위젯 및 테마
- 9.2.1 버튼, 입력 필드, 카드 공통 위젯 작성 (lib/widgets/)
- 9.2.2 로딩 오버레이 / 에러 스낵바 공통 위젯 작성
- 9.2.3 앱 테마(ThemeData) 및 색상/폰트 상수 정의 (lib/constants/)

### 9.3 테스트
- 9.3.1 주요 서비스 함수 단위 테스트 작성 (test/)
- 9.3.2 전체 플로우 수동 E2E 테스트 (시나리오 → 대화 → 피드백)
