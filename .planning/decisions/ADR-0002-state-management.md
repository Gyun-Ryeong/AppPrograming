# ADR-0002: 상태 관리 라이브러리 — Riverpod

- 상태: Accepted
- 날짜: 2026-05-18
- 결정자: MEF 팀

## 배경

Flutter 앱에서 아래 상태를 전역으로 관리해야 한다:
- Supabase 인증 상태 (로그인 여부, 현재 사용자)
- 화면 간 데이터 전달 (시나리오 → 채팅 → 피드백)
- 비동기 API 호출 상태 (로딩 / 성공 / 에러)

상태 관리 라이브러리 없이 `setState`만 쓰면 화면이 늘어날수록 prop drilling 문제가 생긴다.

## 고려한 대안

### 대안 A: Provider (공식 Flutter 팀 권장)
- 장점: 공식 문서 풍부, 학습 곡선 낮음
- 단점: context 의존성 높음, 런타임에 잘못된 Provider 접근 시 에러 발생

### 대안 B: BLoC (Business Logic Component)
- 장점: 단방향 데이터 흐름, 엄격한 구조, 대규모 팀에 적합
- 단점: 보일러플레이트 과다, 7주 단기 프로젝트에 과도한 복잡도

### 대안 C: GetX
- 장점: 라우팅·상태·DI를 하나로 처리, 코드량 최소
- 단점: 마법 같은 동작으로 디버깅 어려움, 발표 Q&A에서 "왜 이렇게 되나" 설명 불가

### 대안 D: Riverpod (선택)
- 장점: Provider의 단점 해결 (context 불필요), 컴파일 타임 안전성, 코드 생성 없이도 간단하게 사용 가능, 공식 문서 및 커뮤니티 성숙
- 단점: Provider보다 약간 높은 학습 곡선

## 결정

**Riverpod**을 선택한다 (`flutter_riverpod: ^2.0.0`).

## 이유

1. **컴파일 타임 안전성**: 잘못된 Provider 참조를 런타임이 아닌 컴파일 타임에 잡음
2. **context 독립**: 위젯 트리 외부에서도 상태 접근 가능 → services/ 레이어 분리 원칙과 궁합이 좋음
3. **비동기 처리**: `AsyncValue`로 로딩/성공/에러 상태를 선언적으로 처리
4. **발표 설명 가능**: "Provider를 개선한 라이브러리" 한 줄로 설명 가능

## 결과

긍정:
- 인증 상태를 `ref.watch(authProvider)`로 어느 화면에서나 안전하게 접근
- 서비스 레이어와 화면 레이어가 명확하게 분리

부정 / 제약:
- `ConsumerWidget` 상속 필요 — 기존 `StatelessWidget` 변환 필요
- 팀원 모두 Riverpod 문서 최소 1회 읽어야 함

## 후속 작업

- [ ] `lib/providers/auth_provider.dart` 구현
- [ ] 각 화면을 `ConsumerWidget` 또는 `ConsumerStatefulWidget`으로 작성
