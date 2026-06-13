# Gemini API 실전 사용 가이드

> 이 프로젝트에서 Gemini API를 사용하면서 발견한 것들을 정리한다.
> 공식 문서에 없거나, 공식 문서만 봐서는 모르는 실전 지식 위주.

---

## 기본 구조

MEF에서 Gemini API를 호출하는 방식은 **REST API 직접 호출** 이다.
SDK를 쓰지 않고 `http` 패키지로 POST 요청을 보낸다.

```dart
// 엔드포인트 형식 (api_config.dart에 저장됨)
// https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key={apiKey}

final response = await http.post(
  Uri.parse(ApiConfig.apiUrl),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({
    'contents': [
      {
        'role': 'user',
        'parts': [{'text': prompt}],
      }
    ],
    'generationConfig': {
      'maxOutputTokens': 1024,
    },
  }),
);
```

### 응답 파싱

Gemini의 응답 구조:

```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          { "text": "AI 응답 텍스트" }
        ],
        "role": "model"
      }
    }
  ]
}
```

Dart 파싱 코드:

```dart
final body = jsonDecode(response.body) as Map<String, dynamic>;
final text = (body['candidates'] as List)
    .first['content']['parts'][0]['text'] as String;
```

---

## 핵심 파라미터

### responseMimeType — JSON 강제 출력

```dart
'generationConfig': {
  'maxOutputTokens': 1024,
  'responseMimeType': 'application/json',  // ← JSON Agent에 필수
},
```

**왜 필요한가**: Gemini 2.5 Flash는 thinking 모드에서 JSON 앞뒤에 설명 텍스트나
마크다운 코드블록(` ```json `)을 붙여 반환한다.
`responseMimeType: 'application/json'` 없이는 `jsonDecode()` 파싱이 실패할 수 있다.

| Agent | responseMimeType 필요 여부 |
|-------|--------------------------|
| ScenarioAgent | ✅ 필요 (Scenario JSON 반환) |
| ConversationAgent | ❌ 불필요 (자유 텍스트 응답) |
| FeedbackAgent | ✅ 필요 (Feedback JSON 반환) |
| AnalysisAgent | ✅ 필요 (AnalysisReport JSON 반환) |

### system_instruction — 시스템 프롬프트

ConversationAgent처럼 역할을 고정해야 하는 경우:

```dart
body: jsonEncode({
  'system_instruction': {
    'parts': [
      {'text': '시스템 프롬프트 내용'}
    ],
  },
  'contents': [...],
  'generationConfig': {...},
}),
```

> `system_instruction`은 `contents` 배열과 별개 필드다. `contents`에 role: `system`을 넣는 방식은 Gemini에서 지원하지 않는다 (OpenAI 형식과 다름).

### temperature — 응답 다양성 제어

```dart
'generationConfig': {
  'temperature': 0.3,  // 0.0~1.0, 낮을수록 결정론적(분석 용도)
}
```

- **ScenarioAgent**: 기본값 (창의적 시나리오 생성 → 다양할수록 좋음)
- **AnalysisAgent**: `0.3` (패턴 분석 → 안정적 결과 필요)

---

## 에러 처리

### 429 Too Many Requests

```dart
if (response.statusCode == 429) {
  throw Exception('서버가 혼잡합니다. 잠시 후 다시 시도해주세요.');
}
```

**원인**: API 호출 한도 초과. 유료 계정이면 잠시 후 재시도로 해결.

### 200 OK인데 JSON 파싱 실패

**원인**: `responseMimeType: 'application/json'` 누락.
확인 방법: `print(response.body)`로 실제 응답 텍스트 확인.

**해결**: `generationConfig`에 `responseMimeType: 'application/json'` 추가.

### CORS 오류 (Chrome 전용)

**증상**: `Access to XMLHttpRequest ... blocked by CORS policy`

**원인**: 브라우저는 CORS 정책을 강제 적용. Gemini 서버가 Flutter 웹 앱 origin을 허용하지 않음.

**해결**: `flutter run -d windows` 사용. 데스크톱 앱은 브라우저 샌드박스 없음.

---

## 멀티턴 대화 (ConversationAgent)

Gemini는 대화 히스토리를 매 요청에 포함해야 한다. 서버 세션이 없다.

```dart
// Message 리스트 → Gemini contents 배열로 변환
final contents = [
  ...history.map((m) => {
    'role': m.isUser ? 'user' : 'model',  // ← 'assistant' 아님! 'model'
    'parts': [{'text': m.content}],
  }),
  {
    'role': 'user',
    'parts': [{'text': userMessage}],
  },
];
```

> **주의**: Gemini는 `role`이 `user`와 `model`만 지원한다.
> OpenAI처럼 `assistant` 또는 `system`을 쓰면 400 오류.

---

## 프롬프트 작성 팁

### JSON 반환 프롬프트

`responseMimeType: 'application/json'`을 썼더라도 프롬프트에도 JSON 형식을 명시하면 더 안정적이다:

```
Respond ONLY with a JSON object in this exact format:
{
  "field1": "value",
  "field2": 0
}
No explanation, no markdown.
```

### 한국어 + 영어 혼용

MEF는 영어 대화 연습 앱이므로:
- 대화 응답 (ConversationAgent): **영어만**
- 피드백/분석 설명 (FeedbackAgent, AnalysisAgent): **한국어**
- 예시 문장 (grammarErrors.examples): **영어** (원문 그대로)

---

## 모델별 특성

| 모델 | 특성 | MEF 사용 여부 |
|------|------|--------------|
| `gemini-2.5-flash` | thinking 모드, 빠른 응답, JSON 출력 안정 | ✅ 현재 사용 |
| `gemini-1.5-flash` | 안정적, thinking 없음, 저렴 | 대안 |
| `gemini-1.5-pro` | 고성능, 느림, 비쌈 | AnalysisAgent 대안 |

현재 `api_config.dart`의 `model` 상수 하나만 바꾸면 모델 교체 가능.
