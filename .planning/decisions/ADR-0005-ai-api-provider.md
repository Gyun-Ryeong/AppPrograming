# ADR-0005: AI API 제공자 — Google Gemini 2.5 Flash

| 항목 | 내용 |
|------|------|
| 상태 | 승인됨 (Accepted) |
| 결정일 | 2026-06-13 (OpenRouter → Gemini로 변경) |
| 결정자 | MEF 팀 |
| 관련 ADR | ADR-0003 (백엔드 없음) |

---

## 맥락 (Context)

MEF 앱의 핵심 기능(시나리오 생성, 대화, 피드백, 분석)은 LLM API 호출이 필요하다.
초기에는 Anthropic Claude API → Supabase Edge Function → OpenRouter 순서로 계획이 바뀌었고,
최종적으로 Google Gemini 2.5 Flash를 직접 호출하는 방식으로 결정됐다.

### 변경 이력

| 시점 | 계획 | 이유 |
|------|------|------|
| 10주차 초기 | Anthropic Claude (Supabase 프록시) | Supabase 사용 계획 |
| 11주차 | OpenRouter (무료 Llama 모델) | Supabase 제거 후 무료 모델 필요 |
| 12주차 | **Google Gemini 2.5 Flash (최종)** | 유료 결제 후 안정적 모델 확보 |

---

## 결정 (Decision)

**Google Gemini 2.5 Flash**를 선택한다.
네이티브 Gemini REST API를 `http` 패키지로 직접 호출한다.

---

## 선택 이유 (Rationale)

1. **성능**: Gemini 2.5 Flash는 thinking 모드를 지원해 복잡한 시나리오 생성·분석에 적합
2. **JSON 강제 출력**: `responseMimeType: 'application/json'` 파라미터로 순수 JSON 반환 보장
3. **OpenAI 호환 불필요**: Gemini 네이티브 API 형식 사용 → 중간 레이어 없음
4. **결제 후 안정성**: 유료 사용으로 rate limit 문제 해소

---

## 고려한 대안 (Rejected Alternatives)

### Anthropic Claude API 직접 호출
- 버린 이유: 초기 무료 크레딧 소진 후 비용 발생, 수업 과제 초기에 부담

### OpenRouter (Meta Llama 3.3 70B free)
- 버린 이유: 무료 모델의 429 rate limit이 빈번해 데모 중 오류 발생
  → 발표 리스크가 너무 높아 유료 결제 가능한 Gemini로 전환

### Firebase ML / Vertex AI
- 버린 이유: Flutter 앱에서 직접 호출하기 위한 설정 복잡도가 높음

---

## API 설정 방법

`lib/constants/api_config.dart` 직접 생성 (`.gitignore` 적용 — 절대 커밋 금지):

```dart
class ApiConfig {
  ApiConfig._();
  // Gemini API 키 — Google AI Studio(aistudio.google.com)에서 발급
  static const String apiKey = 'AIza...';
  static const String model = 'gemini-2.5-flash';
  static const String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey';
}
```

---

## Gemini API 호출 패턴

```dart
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
      'responseMimeType': 'application/json', // JSON 반환 Agent에 필수
    },
  }),
);

// 응답 파싱: candidates[0].content.parts[0].text
final body = jsonDecode(response.body) as Map<String, dynamic>;
final text = (body['candidates'] as List).first['content']['parts'][0]['text'] as String;
```

> **중요**: ConversationAgent는 자유 텍스트 응답이므로 `responseMimeType` 없음.
> ScenarioAgent / FeedbackAgent / AnalysisAgent는 JSON 파싱이 필요하므로 반드시 포함.

---

## 트레이드오프 및 결과

| 항목 | 결과 |
|------|------|
| API 키 노출 | `api_config.dart`가 클라이언트에 존재 → 발표 시 보안 한계 솔직히 언급 |
| CORS (Chrome) | Chrome 웹 빌드에서 CORS로 직접 호출 차단 → `flutter run -d windows` 권장 |
| thinking 모델 JSON | Gemini 2.5 Flash가 JSON 외 텍스트 포함 가능 → `responseMimeType` 로 해결 |
| 비용 | 유료 결제 필요 (무료 tier 소진 시) |

---

## 발표 Q&A 대비

> "AI API는 어떤 것을 사용했나요?"
→ "Google Gemini 2.5 Flash를 직접 호출합니다. `http` 패키지로 REST API POST 요청을 보내고,
   `responseMimeType: 'application/json'`으로 JSON 응답을 강제해 파싱 안정성을 높였습니다."

> "API 키가 앱에 있는 건 보안 문제 아닌가요?"
→ "맞습니다. 수업 데모용 임시 방식이고, 실제 서비스라면 서버 프록시를 통해 키를 숨겨야 합니다."
