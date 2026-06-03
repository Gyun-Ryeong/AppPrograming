# WBS — 팀원 B 담당 작업 기록

> 매 주차 작업 완료 후 체크 및 실제 소요 시간 기록
> 발표 전 팀원 A의 02-wbs-a.md와 합쳐서 02-wbs.md로 통합

---

## 11주차 (2026-05-18)

### 환경 설정
- [x] pubspec.yaml 패키지 추가 (flutter_riverpod, go_router, http) — 0.5d
- [x] Windows 개발자 모드 활성화 (Flutter 심볼릭 링크 허용) — 0.1d
- [x] flutter pub get 실행 및 패키지 설치 확인 — 0.1d

### 앱 테마 및 공통 설정
- [x] main.dart — Riverpod ProviderScope 래핑 + AppColors 기반 전역 테마 적용 — 0.5d
- [x] flutter analyze 오류 0개 확인 — 0.2d

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
- [x] ADR-0003 백엔드 없음 결정 작성 — 0.3d
- [x] ADR-0004 인증 방식 작성 — 0.3d
- [x] ADR-0005 AI API 제공자 (OpenRouter → Google AI Studio) 작성 — 0.3d
- [x] ADR-SPEECH.md 60초 말하기 스크립트 작성 — 0.3d
- [x] docs/testing.md 테스트 전략 작성 — 0.5d
- [x] BONUS.md 가산점 신청 트래킹 초안 작성 — 0.3d
- [x] AGENTS.md, task-b.md 수업 자료 반영 및 최신화 — 0.5d

### 11주차 합계
- 완료 항목: 20개
- 총 소요: 약 6d (실제 작업 기준)

---

## 12주차 (2026-06-01)

### 채팅 화면 UI
- [x] conversation_screen.dart — 채팅 화면 레이아웃 (말풍선 ListView, 역방향 스크롤) — 1d
- [x] 텍스트 입력창 + 전송 버튼 구현 — 0.3d
- [x] 시나리오 요약 카드 (상단) — 0.3d
- [x] 대화 종료 버튼 — 0.2d

### ConversationAgent 서비스
- [x] conversation_service.dart — Google AI Studio 네이티브 API 호출 구현 — 1d
- [x] conversation_provider.dart — 대화 히스토리 Riverpod 상태 관리 — 0.5d

### API 연동 작업
- [x] OpenRouter → Google AI Studio로 API 전환 — 0.5d
- [x] api_config.dart 구조 설계 (gitignore 처리) — 0.3d
- [x] 429 rate limit 오류 메시지 처리 — 0.2d

### 버그 수정
- [x] feedback_service.dart JSON 파싱 오류 수정 (maxOutputTokens 2048) — 0.3d
- [x] analysis_service.dart JSON 파싱 오류 수정 (maxOutputTokens 4096) — 0.3d
- [x] auth_provider.dart authNotifierProvider 구현 (팀원 A 화면 연동) — 0.3d

### 대화 기록
- [x] history_detail_screen.dart — 과거 대화 내용 상세 보기 화면 — 0.5d
- [x] history_screen.dart — 카드 탭 시 상세 화면 이동 연결 — 0.2d

### 문서
- [x] briefing-12week.md 팀원 브리핑 문서 작성 — 0.3d
- [x] script.md 중간 발표 대본 작성 — 0.5d
- [x] CLAUDE.md 푸시 전 체크리스트 추가 — 0.2d
- [x] flutter analyze 오류 0개 확인 — 0.1d

### 12주차 합계
- 완료 항목: 18개
- 총 소요: 약 7.3d (실제 작업 기준)

---

## 13주차 (예정)

- [ ] 전체 흐름 통합 테스트 (로그인→시나리오→채팅→피드백→기록)
- [ ] 발표 데모 영상 녹화 (30초 백업용)
- [ ] docs/testing.md 실제 테스트 결과 반영
- [ ] BONUS.md 완성 (가산점 증빙 정리)
- [ ] WBS 합본 (02-wbs-a.md + 02-wbs-b.md → 02-wbs.md)

---

## 14주차 (예정)

- [ ] 최종 발표 준비
- [ ] 코드 정리 및 주석 보강
