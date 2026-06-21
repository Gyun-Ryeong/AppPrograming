# 의사결정 기록 (Decisions Log)

> MEF 개발 과정에서 내린 판단·시행착오·해결법을 시간순으로 기록한다.
> 키워드: wiki, 암묵지, 지식 관리, 의사결정 기록, 판단 이유
>
> 공식 ADR과의 차이: ADR은 확정된 결론, 이 로그는 결정 과정과 이유를 담는다.

---

## 2026-05-04 | 프레임워크 선택 — Flutter 확정

**판단**: React Native 대신 Flutter 선택

**이유**:
- 단일 코드로 Android·iOS·Web 동시 지원 (7주 과제에 최적)
- Dart는 처음이지만 null-safety가 명확해 오류 잡기 쉬움
- 네이티브 컴파일로 채팅 UI 애니메이션 성능 유리

→ 공식 기록: ADR-0001

---

## 2026-05-10 | 상태 관리 — Riverpod 선택

**판단**: Provider, BLoC, GetX 제외, Riverpod 선택

**각 대안 탈락 이유**:
- Provider: BuildContext 의존성 — 화면 바깥에서 상태 접근 불가
- BLoC: 엄격한 단방향 흐름이 7주 과제에 과잉, 보일러플레이트 과다
- GetX: 편리하지만 "마법"이 많아 발표에서 동작 원리 설명 곤란

**Riverpod 선택 근거**: AsyncValue로 로딩/성공/에러 3상태 선언적 처리, 컴파일 타임 안전성

→ 공식 기록: ADR-0002

---

## 2026-05-18 | 상황 입력 방식 — 자유 텍스트 채택

**판단**: 드롭다운 선택지 대신 자유 텍스트 + 보조 선택(난이도/카테고리) 조합

**이유**:
- 정해진 선택지는 사용자가 원하는 상황을 정확히 표현하기 어려움
- AI(ScenarioAgent)가 자유 텍스트를 구조화하는 것이 핵심 차별화 포인트
- 발표 데모: "원하는 상황을 자유롭게 입력" → AI가 즉시 시나리오 생성

---

## 2026-05-24 | 아키텍처 전환 — Supabase 제거

**판단**: Supabase 백엔드 완전 제거, Riverpod 메모리 저장으로 대체

**이유**:
- Supabase 무료 티어 설정 예상보다 복잡 (Edge Function 배포만 1~2일 소요 예상)
- 7주 과제에서 MVP 기능 완성이 우선순위
- 인증: Mock(test@mef.com/test1234) 메모리 Map으로 발표 시연 충분
- 데이터 영속성 없음은 허용 가능한 제약으로 합의

**트레이드오프**: 앱 종료 시 대화 기록 초기화 → 발표 시 "알려진 제약"으로 명시

→ 공식 기록: ADR-0003, ADR-0004

---

## 2026-05-24 | AI API 전환 — Claude → OpenRouter → Gemini 2.5 Flash

**1차 전환 (Claude → OpenRouter)**:
- Anthropic Claude API 비용 부담 → OpenRouter 무료 티어 선택
- Meta Llama 3.3 70B 사용 시작

**2차 전환 (OpenRouter → Gemini 2.5 Flash)**:
- OpenRouter 429 Rate Limit 빈번 발생 — 실습 중 계속 차단
- Gemini 2.5 Flash: Google AI Studio 무료 티어, 관대한 Rate Limit
- HTTP 직접 호출 가능 → 별도 SDK·프록시 서버 불필요
- `responseMimeType: 'application/json'` 지원으로 JSON 파싱 안정성 확보

→ 공식 기록: ADR-0005

---

## 2026-05-28 | JSON 파싱 오류 — responseMimeType으로 해결

**문제**: Gemini 2.5 Flash가 JSON 요청에 마크다운 코드블록(` ```json `)을 포함해 응답
→ `jsonDecode()` 실패, `FormatException`

**시도한 해결책 순서**:
1. 프롬프트에 "JSON only" 지시 강화 → 간헐적 실패 여전
2. 정규식으로 ` ```json ` 제거 → 불안정, 예외 케이스 발생
3. `generationConfig`에 `responseMimeType: 'application/json'` 추가 → **완전 해결**

**교훈**: Gemini 2.5 Flash는 thinking 모드 지원 모델 — 자체 설명 텍스트를 붙이는 성향.
`responseMimeType`으로 순수 JSON만 강제해야 파싱 오류 0%.

---

## 2026-05-29 | CORS 이슈 — Windows 데스크톱 빌드로 우회

**문제**: Chrome 웹 빌드에서 Gemini API 직접 호출 차단
→ `XMLHttpRequest error` 발생 (브라우저 Same-Origin 정책)

**해결**: `flutter run -d windows` — Windows 데스크톱 빌드 사용
→ 데스크톱 환경은 브라우저 CORS 정책 무관, API 직접 호출 가능

**교훈**: 클라이언트에서 직접 외부 API 호출 시 CORS는 웹에서만 문제.
발표 시연은 반드시 Windows 빌드로 진행할 것.

---

## 2026-06-04 | maxOutputTokens — Agent별 토큰 예산 차별화

**문제**:
- 토큰 낮으면 JSON 중간 잘림 → 파싱 오류
- 토큰 높으면 불필요한 응답 지연 + API 비용

**판단**: Agent 응답 복잡도에 맞게 차별화

| Agent | maxOutputTokens | 근거 |
|-------|----------------|------|
| ConversationAgent | 512 | 2-4문장 자연어 응답 충분 |
| ScenarioAgent | 1,024 | JSON 4개 필드, 중간 복잡도 |
| FeedbackAgent | 2,048 | 오류 목록 + 제안 + 종합 의견 |
| AnalysisAgent | 4,096 | 누적 세션 전체 분석 + 패턴 3개 |

---

## 2026-06-13 | 429 Rate Limit 대응 — 자동 재시도 헬퍼 추가

**문제**: 발표 중 짧은 시간에 여러 번 API 호출 시 429 Rate Limit 발생
→ 에러 화면 노출, 발표 흐름 끊김

**해결**: `gemini_api_helper.dart` 신규 생성
→ 429 응답 시 1.5초 대기 후 자동 1회 재시도
→ 4개 서비스 파일이 모두 이 헬퍼를 통해 API 호출

**교훈**: 발표 안정성을 위해 자동 재시도 로직은 필수.
1회 재시도로 대부분의 순간적 Rate Limit 해소 가능.

---

## 2026-06-13 | 채팅 화면 버그 — 대화 초기화 누락

**문제**: 새 시나리오로 채팅 화면 진입 시 이전 대화 메시지가 잔존

**원인**: `ConversationScreen`의 `initState`에서 Provider 초기화 누락

**해결**: `initState`에 `ref.read(conversationProvider.notifier).reset()` 추가

**교훈**: 화면 재진입 시 상태 초기화는 `initState`에서 명시적으로 처리할 것.
Riverpod Provider는 화면 이탈 후에도 상태를 유지하므로 직접 초기화 필요.
