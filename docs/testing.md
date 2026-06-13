# 테스트 전략 (Testing Strategy)

> MEF 프로젝트의 테스트 범위와 실행 방법.
> 7주 과제 특성상 단위 테스트 중심, 통합 테스트는 수동 체크리스트로 병행.
> 키워드: 단위 테스트, 통합 테스트, 성능 최적화, unit test, integration test

---

## 테스트 계층

```
수동 E2E 테스트        — 전체 시나리오: 로그인 → 시나리오 → 채팅 → 피드백 → 분석
     ↓
통합 테스트 (수동)      — 화면 + Provider 연결, AI API 응답 검증
     ↓
단위 테스트 ★          — 모델 JSON 파싱, 서비스 응답 파싱, 라우팅 로직
```

7주 프로젝트 권장: **단위 테스트 집중 + 수동 통합 체크리스트**

---

## 단위 테스트 (Unit Test)

### 실행 방법

```bash
flutter test
```

테스트 파일 위치: `test/`

```bash
# 특정 파일만 실행
flutter test test/models/scenario_test.dart

# 커버리지 측정
flutter test --coverage
```

### 테스트 파일 구조

```
test/
├── models/
│   ├── scenario_test.dart      # Scenario.fromJson() 파싱 검증
│   ├── message_test.dart       # Message 모델 직렬화
│   └── feedback_test.dart      # Feedback 모델 파싱
└── services/
    ├── scenario_service_test.dart   # ScenarioAgent JSON 파싱
    └── feedback_service_test.dart   # FeedbackAgent JSON 파싱
```

### 모델 단위 테스트 예시

```dart
// test/models/scenario_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mef/models/scenario.dart';

void main() {
  group('Scenario 모델 — 단위 테스트', () {
    test('fromJson: 정상 JSON 파싱', () {
      final json = {
        'id': 'test_001',
        'background': 'You are at a coffee shop.',
        'user_role': 'Customer',
        'ai_role': 'Barista',
        'goal': 'Order a coffee and ask about the menu.',
      };

      final scenario = Scenario.fromJson(json);

      expect(scenario.background, 'You are at a coffee shop.');
      expect(scenario.userRole, 'Customer');
      expect(scenario.aiRole, 'Barista');
    });

    test('fromJson: 필수 필드 누락 시 예외', () {
      final json = {'background': 'Only background'};
      expect(() => Scenario.fromJson(json), throwsA(anything));
    });
  });
}
```

---

## 통합 테스트 (Integration Test)

### 테스트 흐름

전체 사용자 여정을 검증한다. 각 단계가 끊김 없이 연결되어야 한다.

```
로그인 → 홈 → 시나리오 입력 → 시나리오 확인
  → 채팅 → 대화 종료 → 피드백
  → 홈 → 대화 기록 → 기록 상세
  → 약점 분석 [유료]
```

### 실행 방법

```bash
# 통합 테스트 실행 (Windows 데스크톱 권장)
flutter test integration_test/

# 또는 수동으로 앱 실행 후 체크리스트 확인
flutter run -d windows
```

---

## 성능 최적화 검증

성능 최적화 적용 여부를 코드 리뷰로 확인한다.

### maxOutputTokens 검증

```bash
# 각 서비스 파일에서 토큰 예산 확인
grep -n "maxOutputTokens" lib/services/*.dart
```

기대 결과:
```
conversation_service.dart: 'maxOutputTokens': 512
scenario_service.dart:     'maxOutputTokens': 1024
feedback_service.dart:     'maxOutputTokens': 2048
analysis_service.dart:     'maxOutputTokens': 4096
```

### responseMimeType 검증

```bash
# JSON 반환 강제 설정 확인
grep -n "responseMimeType" lib/services/*.dart
```

기대 결과:
```
scenario_service.dart:  'responseMimeType': 'application/json'
feedback_service.dart:  'responseMimeType': 'application/json'
analysis_service.dart:  'responseMimeType': 'application/json'
```
ConversationAgent에는 없어야 정상 (자유 텍스트 응답).

### 정적 분석

```bash
flutter analyze
```

기대 결과: `No issues found!`

---

## 수동 테스트 체크리스트 (발표 전 필수)

### 인증 흐름
- [ ] 회원가입 → 계정 생성 성공
- [ ] 로그인 (test@mef.com / test1234) → 홈 화면 이동
- [ ] 로그아웃 → 로그인 화면 이동
- [ ] 미로그인 상태에서 홈 직접 접근 → 로그인 화면으로 리디렉션

### 시나리오 생성 흐름
- [ ] 상황 텍스트 입력 + 난이도/카테고리 선택 → "시나리오 생성" 버튼
- [ ] 로딩 중 LoadingOverlay 표시 (중복 클릭 차단 확인)
- [ ] 시나리오 결과 화면에 background / user_role / ai_role / goal 표시
- [ ] "대화 시작" 버튼 → 채팅 화면 이동

### 채팅 흐름
- [ ] AI 첫 메시지 자동 표시
- [ ] 사용자 메시지 입력 → 전송 → AI 응답 수신
- [ ] 말풍선 좌우 정렬 (사용자 오른쪽, AI 왼쪽)
- [ ] "대화 종료" 버튼 → 피드백 화면 이동

### 피드백 흐름
- [ ] 자연스러움 점수 표시 (0~100)
- [ ] 문법 오류 카드 목록 (원문 / 수정안 / 설명)
- [ ] expression_suggestions 목록 표시
- [ ] "다시 연습" → 시나리오 입력, "홈으로" → 홈

### 대화 기록 흐름
- [ ] 홈에서 기록 목록 진입
- [ ] 세션 목록 표시
- [ ] 세션 탭 → 상세 화면 (과거 대화 + 피드백)

### 약점 분석 흐름 [유료]
- [ ] 세션 0개: API 호출 없이 기본 메시지 표시
- [ ] 세션 1개 이상: AnalysisAgent 호출 → 약점 패턴 표시

### 성능 최적화 검증
- [ ] 시나리오 생성 버튼: 로딩 중 중복 클릭 시 추가 API 호출 없음
- [ ] 채팅: 전송 버튼 연속 클릭 시 중복 메시지 없음
- [ ] JSON 파싱 오류 없음 (시나리오 / 피드백 / 분석 각 1회 이상 정상 동작)

---

## 알려진 제약사항

| 항목 | 내용 | 비고 |
|------|------|------|
| 데이터 영속성 | 앱 종료 시 대화 기록 초기화 | Riverpod 메모리 저장, 과제 범위 허용 |
| Chrome CORS | 웹 빌드에서 Gemini API 직접 호출 차단 | `flutter run -d windows` 사용 권장 |
| iOS 테스트 | macOS + Xcode 필요 | 과제 범위 외 |
| API 키 노출 | `api_config.dart`가 클라이언트에 존재 | `.gitignore` 적용, 발표 시 한계 언급 |
