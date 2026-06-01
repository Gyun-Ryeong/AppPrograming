# ADR-0005: AI API 제공자 — OpenRouter

- 상태: Accepted
- 날짜: 2026-05-24
- 결정자: MEF 팀

## 배경

MEF 앱의 핵심 기능(시나리오 생성, 대화, 피드백)은 LLM API 호출이 필요하다.
초기에는 Anthropic Claude API를 Supabase Edge Function을 통해 호출할 계획이었으나,
Supabase 제거(ADR-0003) 결정으로 클라이언트에서 직접 호출하는 방식으로 변경됐다.

## 고려한 대안

### 대안 A: Anthropic Claude API 직접 호출
- 장점: 성능 우수, 공식 SDK 있음
- 단점: 유료 (무료 크레딧 없음), 수업 과제에 비용 부담

### 대안 B: Google Gemini API
- 장점: 무료 티어 있음, Google 공식 지원
- 단점: 별도 API 키 발급, 팀이 익숙하지 않음

### 대안 C: OpenRouter (선택)
- 장점: 여러 LLM 모델을 하나의 API로 사용, 무료 모델 다수 제공, OpenAI 호환 형식
- 단점: 무료 모델은 속도 제한(rate limit) 있음, 외부 서비스 의존

## 결정

**OpenRouter**를 선택한다.
현재 사용 모델: `meta-llama/llama-3.3-70b-instruct:free` (Meta Llama 3.3 70B)

## 이유

1. **무료 사용 가능**: 수업 과제 기간 동안 무료 모델로 충분
2. **OpenAI 호환 형식**: `http` 패키지로 단순 POST 요청, 별도 SDK 불필요
3. **모델 유연성**: 모델명만 바꾸면 다른 LLM으로 즉시 전환 가능
4. **수업에서 사용 경험**: 팀이 OpenRouter 계정 보유

## 결과

긍정:
- API 키 하나로 다양한 무료 LLM 사용 가능
- 코드 변경 없이 모델 교체 가능 (`api_config.dart`의 model 값만 수정)

부정 / 제약:
- 무료 모델은 사용량 많은 시간대에 429(rate limit) 오류 발생
- API 키가 클라이언트 코드에 존재 → 실제 서비스에서는 서버 프록시 필요
- `api_config.dart`는 `.gitignore`에 포함 → 팀원 각자 직접 생성 필요

## API 설정 방법

`lib/constants/api_config.dart` 직접 생성 (git에 포함되지 않음):

```dart
class ApiConfig {
  ApiConfig._();
  static const String apiKey = 'sk-or-v1-...';
  static const String model = 'meta-llama/llama-3.3-70b-instruct:free';
  static const String apiUrl = 'https://openrouter.ai/api/v1/chat/completions';
}
```

## 발표 Q&A 대비

> "AI API는 어떻게 호출하나요?"
→ "OpenRouter를 통해 Meta의 Llama 3.3 70B 모델을 사용합니다.
   http 패키지로 직접 POST 요청을 보내고, OpenAI 호환 형식으로 응답을 받습니다.
   실제 서비스에서는 API 키 보호를 위해 서버 프록시를 도입할 계획입니다."

## 후속 작업

- [ ] 발표 데모 전 API 정상 동작 확인
- [ ] 무료 모델 rate limit 대비 백업 모델 준비
- [ ] 실제 서비스 전환 시 서버 프록시 도입
