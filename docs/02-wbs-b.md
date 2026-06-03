# WBS — 팀원 B 담당 작업 기록

> 매 주차 작업 완료 후 체크 및 실제 소요 시간 기록
> 발표 전 팀원 A의 02-wbs-a.md와 합쳐서 02-wbs.md로 통합

---

## 11주차 (2026-05-18)

### 환경 설정
- [x] pubspec.yaml 패키지 추가 (supabase_flutter, flutter_riverpod, go_router) — 0.5d
- [x] Windows 개발자 모드 활성화 (Flutter 심볼릭 링크 허용) — 0.1d
- [x] flutter pub get 실행 및 패키지 설치 확인 — 0.1d

### 앱 테마 및 공통 설정
- [x] main.dart — Riverpod ProviderScope 래핑 + AppColors 기반 전역 테마 적용 — 0.5d
- [x] flutter analyze 오류 0개 확인 (기존 widget_test.dart 수정 포함) — 0.2d

### 공통 위젯
- [x] chat_bubble.dart — isUser 값으로 좌/우 말풍선 구분 위젯 — 0.5d
- [x] primary_button.dart — isLoading으로 로딩 스피너 전환 공통 버튼 — 0.3d
- [x] loading_overlay.dart — AI 응답 대기 중 화면 전체 오버레이 — 0.3d

### 네비게이션
- [x] app_router.dart — GoRouter 인스턴스 구현, 경로 상수 정의 — 0.5d
- [x] home_screen.dart — 홈 화면 UI (시나리오 생성 / 대화 기록 버튼) — 0.5d
- [x] main.dart에 go_router 연결 (MaterialApp.router) — 0.2d

### 문서
- [x] ADR-0002 Riverpod 선택 이유 작성 — 0.3d
- [x] ADR-0003 Supabase 선택 이유 작성 — 0.3d
- [x] ADR-SPEECH.md 60초 말하기 스크립트 작성 — 0.3d
- [x] docs/deploy.md 배포 절차 작성 — 0.5d
- [x] docs/testing.md 테스트 전략 작성 — 0.5d
- [x] BONUS.md 가산점 신청 트래킹 초안 작성 — 0.3d
- [x] AGENTS.md, task-a/b.md 10·11주차 수업 자료 반영 — 0.5d

### 11주차 합계
- 완료 항목: 18개
- 총 소요: 약 5.7d (실제 작업 기준)

---

## 12주차 (예정)

### 채팅 화면 UI
- [ ] conversation_screen.dart — 채팅 화면 레이아웃 (말풍선 ListView, 역방향 스크롤)
- [ ] 텍스트 입력창 + 전송 버튼 구현
- [ ] 시나리오 요약 카드 (상단)
- [ ] 대화 종료 버튼

### ConversationAgent 서비스
- [ ] conversation_service.dart — Edge Function 호출 구현
- [ ] 대화 히스토리 Riverpod 상태 관리

---

## 13주차 (예정)

### 피드백 화면
- [ ] feedback_screen.dart — 자연스러움 점수 + 문법 오류 카드
- [ ] feedback_service.dart — FeedbackAgent Edge Function 호출

### 대화 기록
- [ ] history_list_screen.dart — 세션 목록
- [ ] history_detail_screen.dart — 과거 대화 + 피드백 상세

---

## 14주차 (예정)

- [ ] docs/testing.md 보완 (실제 테스트 결과 반영)
- [ ] BONUS.md 완성 (가산점 증빙 정리)
