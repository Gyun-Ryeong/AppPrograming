# 아키텍처 진화 히스토리

> 이 문서는 MEF 프로젝트가 처음 기획에서 현재까지 어떻게 바뀌었는지를 기록한다.
> 각 변경에는 반드시 "왜 바꿨는가" 이유가 포함되어야 한다.

---

## 전체 흐름 요약

```
10주차 기획
  └─ React Native + Supabase + Claude API
          ↓  [실제 개발 시작, 11주차]
  └─ Flutter + Supabase + Claude API
          ↓  [Supabase 설정 복잡도, 7주 일정 압박]
  └─ Flutter + 백엔드 없음 + OpenRouter (무료 Llama)
          ↓  [무료 rate limit 429, 데모 리스크]
  └─ Flutter + 백엔드 없음 + Google Gemini 2.5 Flash  ← 현재
```

---

## 변경 1: React Native → Flutter (11주차)

**변경 전**: React Native (Expo)
**변경 후**: Flutter 3.44.1

### 왜 바꿨는가

- 10주차 기획 단계에서는 팀이 JavaScript에 더 익숙했기 때문에 React Native를 1순위로 고려했다.
- 실제 개발 환경을 설정하면서 Expo의 네이티브 모듈 제한(STT/TTS 구현 시 문제), JS Bridge 성능 우려를 발견했다.
- Flutter는 단일 코드베이스로 완벽한 UI 일관성을 보장하고, 채팅 UI처럼 빠른 업데이트에 강점이 있다.
- Dart 학습 비용이 있지만, 7주 내 과제 완성이라면 Flutter 생태계(Riverpod, go_router)가 더 성숙했다.

### 배운 것

- 기획 단계에서 기술 스택을 확정하기 전에 짧은 프로토타입을 만들어 검증했어야 했다.
- Flutter Hello World까지 도달하는 데 0.5일 소요 — 생각보다 짧았다.

→ 공식 결정: ADR-0001

---

## 변경 2: Supabase → 백엔드 없음 (11주차)

**변경 전**: Supabase (PostgreSQL + Auth + Edge Function)
**변경 후**: 백엔드 없음, Riverpod 메모리만 사용

### 왜 바꿨는가

- Supabase 프로젝트 생성 → Edge Function 배포 → Dart 클라이언트 연동까지 예상 소요: 2~3일
- 7주 중 1주를 인프라에 쓰면 핵심 기능(시나리오, 대화, 피드백) 구현 시간이 부족하다.
- 수업 과제 목적은 AI 기능 시연이지, DB 아키텍처 시연이 아니다.
- Riverpod 메모리로 충분히 발표 데모가 가능하다.

### 발생한 부작용

- API 키가 클라이언트 코드(`api_config.dart`)에 노출됨
  → `.gitignore`로 파일 자체를 커밋 차단하는 방식으로 완화
- 앱 종료 시 모든 데이터(대화 기록, 사용자 계정) 초기화
  → 수업 과제 데모 범위 내에서는 허용 가능한 트레이드오프

→ 공식 결정: ADR-0003, ADR-0004

---

## 변경 3: Claude API → OpenRouter → Gemini 2.5 Flash (12주차)

**변경 전 1단계**: Anthropic Claude API (Supabase 프록시 경유)
**변경 전 2단계**: OpenRouter (`meta-llama/llama-3.3-70b-instruct:free`)
**변경 후**: Google Gemini 2.5 Flash 네이티브 API

### Claude → OpenRouter

- Supabase 제거 후 클라이언트에서 직접 API 호출 필요
- Anthropic Claude API는 무료 크레딧 없음 → 수업 과제 기간에 비용 부담
- OpenRouter가 무료 모델(Llama 3.3 70B)을 OpenAI 호환 형식으로 제공 → 즉시 적용

### OpenRouter → Gemini

- 무료 Llama 모델에서 `429 Too Many Requests` 빈번 발생
  - 데모 중 오류는 치명적 → 발표 리스크 너무 높음
- Gemini API 유료 결제로 rate limit 해소
- Gemini 2.5 Flash의 `responseMimeType: 'application/json'`이 JSON 파싱 안정성을 크게 높임
  (OpenRouter Llama는 JSON 외 텍스트를 섞어 반환해 파싱 실패 빈번)

### 배운 것

- 무료 API에 의존하면 데모 리스크가 생긴다. 발표 직전에는 유료/안정적 옵션 확보 필요.
- LLM이 JSON을 반환한다고 해서 순수 JSON만 반환하는 건 아니다.
  thinking 모델은 JSON 앞뒤에 설명 텍스트를 붙이는 경향이 있다.
  → `responseMimeType: 'application/json'` 파라미터로 강제 해결.

→ 공식 결정: ADR-0005

---

## 현재 아키텍처 (2026-06-13)

```
Flutter App (Windows / Android / iOS)
  │
  ├── screens/      UI — Riverpod 구독, 이벤트 전달
  ├── providers/    상태 — AsyncNotifier, services 호출
  ├── services/     통신 — Gemini REST API 직접 호출
  └── models/       데이터 — fromJson / toJson

  외부: Google Gemini 2.5 Flash API
  인증: 메모리 Mock (test@mef.com / test1234)
  DB: 없음 (Riverpod 메모리)
```

### 이 구조가 과제에 최적인 이유

- 레이어 분리가 명확 → 발표 때 설명하기 쉽다
- services/ 하나만 보면 AI 연동 방식을 전부 이해할 수 있다
- 실제 서비스 전환 시 services/ 레이어만 수정하면 된다 (서버 프록시 추가 등)
