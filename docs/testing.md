# 테스트 전략

> MEF 프로젝트의 테스트 범위와 실행 방법.
> 7주 과제 특성상 단위 테스트 중심, E2E는 수동 체크리스트로 대체.

---

## 테스트 계층

```
E2E (수동)          — 전체 시나리오: 로그인 → 시나리오 생성 → 채팅 → 피드백
  ↓
통합 테스트         — 화면 + Provider 연결, Supabase 연동
  ↓
단위 테스트 ★       — 서비스 함수, 모델 파싱, 라우팅 로직
```

7주 프로젝트 권장: **단위 테스트 집중 + 수동 E2E 체크리스트**

---

## 단위 테스트 실행

```bash
flutter test
```

테스트 파일 위치: `test/`

```bash
# 특정 파일만 실행
flutter test test/models/scenario_test.dart

# 커버리지 측정
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

---

## 테스트 파일 구조

```
test/
├── models/
│   ├── scenario_test.dart      # Scenario.fromJson() 파싱 검증
│   ├── message_test.dart       # Message 모델 직렬화
│   └── feedback_test.dart      # Feedback 모델 파싱
├── services/
│   ├── scenario_service_test.dart    # ScenarioAgent 응답 파싱
│   └── feedback_service_test.dart    # FeedbackAgent 응답 파싱
└── router/
    └── app_router_test.dart    # 라우팅 로직 (인증 상태별 리디렉션)
```

---

## 모델 테스트 예시

```dart
// test/models/scenario_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mef/models/scenario.dart';

void main() {
  group('Scenario 모델', () {
    test('fromJson: 정상 JSON 파싱', () {
      // AI가 반환하는 JSON 형식
      final json = {
        'background': 'You are at a coffee shop.',
        'user_role': 'Customer',
        'ai_role': 'Barista',
        'goal': 'Order a coffee and ask about the menu.',
        'difficulty': 'beginner',
        'category': 'daily',
      };

      final scenario = Scenario.fromJson(json);

      expect(scenario.background, 'You are at a coffee shop.');
      expect(scenario.userRole, 'Customer');
      expect(scenario.difficulty, 'beginner');
    });

    test('toJson: JSON으로 변환', () {
      final scenario = Scenario(
        background: 'Test background',
        userRole: 'Customer',
        aiRole: 'Barista',
        goal: 'Test goal',
        difficulty: 'beginner',
        category: 'daily',
      );

      final json = scenario.toJson();

      expect(json['background'], 'Test background');
      expect(json['user_role'], 'Customer');
    });
  });
}
```

---

## 수동 테스트 체크리스트 (발표 전 필수)

### 인증 흐름
- [ ] 회원가입 → 이메일 확인 메일 수신
- [ ] 로그인 → 홈 화면 이동
- [ ] 로그아웃 → 로그인 화면 이동
- [ ] 미로그인 상태에서 홈 직접 접근 → 로그인 화면으로 리디렉션

### 시나리오 생성 흐름
- [ ] 상황 텍스트 입력 → 난이도 / 카테고리 선택 → "시나리오 생성" 버튼
- [ ] 로딩 중 `CircularProgressIndicator` 표시
- [ ] 시나리오 결과 화면에 배경 / 역할 / 목표 표시
- [ ] "대화 시작" 버튼 → 채팅 화면 이동

### 채팅 흐름
- [ ] AI 첫 메시지 자동 표시
- [ ] 사용자 메시지 입력 → 전송 → AI 응답 수신
- [ ] 말풍선 좌우 정렬 (사용자 오른쪽, AI 왼쪽)
- [ ] "대화 종료" 버튼 → 피드백 화면 이동

### 피드백 흐름
- [ ] 자연스러움 점수 표시 (0~100)
- [ ] 문법 오류 카드 목록 (원문 / 수정안 / 설명)
- [ ] "다시 연습" → 시나리오 입력 화면
- [ ] "홈으로" → 홈 화면

### 대화 기록 흐름
- [ ] 홈에서 기록 목록 진입
- [ ] 세션 목록 (날짜 + 시나리오 요약 + 점수)
- [ ] 세션 탭 → 상세 화면 (과거 대화 + 피드백)

---

## 알려진 제약사항

- **AI 응답 테스트**: Supabase Edge Function이 배포되어 있어야 실제 AI 응답 테스트 가능. 로컬에서는 목(Mock) 응답으로 대체.
- **인증 통합 테스트**: 실제 Supabase 프로젝트 연결 필요. `.env` 파일 설정 필수.
- **iOS 테스트**: macOS + Xcode 환경 필요. 수업 과제 범위 외.
