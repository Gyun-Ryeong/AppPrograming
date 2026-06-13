# 시행착오 로그

> 개발 중 마주친 문제, 시도한 해결책, 최종 해결법을 날짜순으로 기록한다.
> 해결 못한 것도 남긴다. 다음 사람(또는 나중의 나)을 위해.

---

## 기록 형식

```
## [날짜] 문제 제목
**증상**: 무엇이 잘못됐는가
**원인**: 왜 그랬는가
**시도한 것**: 뭘 해봤는가 (실패 포함)
**해결**: 최종 해결법
**교훈**: 다음에 같은 실수를 피하려면
```

---

## [2026-05-24] Supabase 설정 복잡도 — 백엔드 제거 결정

**증상**: Supabase 프로젝트 생성, Edge Function 작성, Flutter 클라이언트 연동까지 예상 시간이 2~3일이었다.

**원인**: Edge Function은 TypeScript로 작성하고, Flutter 클라이언트와 HTTP로 연동해야 한다. 7주 일정에서 1주를 인프라에 쓰기에는 부담이 컸다.

**시도한 것**:
- Supabase 대시보드에서 프로젝트 생성 시도
- `supabase_flutter` 패키지 pubspec에 추가

**해결**: Supabase 전면 제거. `http` 패키지로 AI API를 직접 호출하는 구조로 전환.

**교훈**: 인프라는 과제의 목적(AI 기능 시연)과 분리해서 생각해야 한다. 핵심 아닌 것에 시간을 쓰면 핵심이 늦어진다.

---

## [2026-05-24] OpenRouter 무료 모델 429 Too Many Requests

**증상**: 앱 실행 후 시나리오 생성 버튼을 누르면 `429 Too Many Requests` 오류.

**원인**: OpenRouter의 무료 모델(`meta-llama/llama-3.3-70b-instruct:free`)은 분당 요청 수 제한이 있다. 여러 번 테스트하거나 피크 시간대에 사용하면 limit에 걸린다.

**시도한 것**:
- 잠깐 기다렸다가 재시도 → 일시적으로 해결되지만 불안정
- 다른 무료 모델로 변경 → 마찬가지로 rate limit 발생

**해결**: Google Gemini 2.5 Flash로 전환 (유료 결제). 안정적인 API로 교체.

**교훈**: 무료 API는 개발 테스트용으로만 쓰고, 발표 전에는 안정적인 유료 옵션으로 전환해야 한다. 데모 중 429 오류는 치명적이다.

---

## [2026-06-13] Chrome에서 Gemini API POST 실패 (CORS)

**증상**: `flutter run -d chrome`으로 실행했을 때 시나리오 생성이 안 됨.
DevTools 콘솔: `POST https://generativelanguage.googleapis.com/... 에 대한 CORS 정책 차단`

**원인**: Chrome(브라우저)은 CORS 정책을 강제한다. Gemini API 서버가 Flutter 웹 앱의 origin에 대해 CORS 헤더를 반환하지 않아 브라우저가 요청을 차단한다.

**시도한 것**:
- `Content-Type: application/json` 헤더 추가 → 효과 없음 (CORS는 헤더 문제가 아님)
- `flutter run -d chrome --web-browser-flag "--disable-web-security"` → 개발 중에는 우회 가능하지만 데모용으로 부적절

**해결**: `flutter run -d windows` (Windows 데스크톱 빌드)로 전환. 데스크톱 앱은 브라우저 샌드박스가 없어 CORS 제약이 없음.

**교훈**: Flutter 웹(Chrome)에서 외부 API를 직접 호출하면 CORS에 막힌다. 서버 프록시가 없는 구조에서는 데스크톱 또는 모바일 빌드를 사용해야 한다.

```
Chrome 웹 빌드  →  CORS 차단  →  ❌ 불가
Windows 데스크톱  →  CORS 없음  →  ✅ 가능
Android/iOS  →  CORS 없음  →  ✅ 가능
```

---

## [2026-06-13] Gemini 2.5 Flash — JSON 파싱 실패

**증상**: 시나리오 생성 요청 후 `FormatException: Unexpected character` 파싱 오류.
API 응답은 200 OK인데 JSON 파싱이 실패한다.

**원인**: Gemini 2.5 Flash는 "thinking" 모드를 지원하는 모델이다. thinking 모드에서는 AI가 추론 과정을 텍스트로 포함해 응답할 수 있고, JSON 앞뒤로 설명 텍스트나 마크다운 코드블록(` ```json `)이 붙어서 반환될 수 있다.

```
// 실제 응답 예시 (문제 상황)
"text": "Here is the scenario:\n```json\n{...}\n```"

// jsonDecode()는 ```json 블록을 처리 못함 → FormatException
```

**시도한 것**:
- 정규식으로 ` ```json ` 제거 → 부분 해결, 그러나 모든 케이스 처리 못함
- 프롬프트에 "Respond with JSON only" 명시 → 일부 경우 해결, 불안정

**해결**: `generationConfig`에 `responseMimeType: 'application/json'` 추가.
이 파라미터는 Gemini에게 "순수 JSON만 반환하라"고 강제한다.

```dart
'generationConfig': {
  'maxOutputTokens': 1024,
  'responseMimeType': 'application/json',  // ← 이 한 줄
},
```

적용 대상: ScenarioAgent, FeedbackAgent, AnalysisAgent (JSON 반환 필요 3개)
비적용: ConversationAgent (자유 텍스트 응답)

**교훈**: thinking 모델은 프롬프트만으로 JSON 순수 반환을 보장하기 어렵다.
API가 제공하는 `responseMimeType` 파라미터를 적극 사용할 것.

---

## [2026-06-13] flutter run — 기기 선택 오류

**증상**: `flutter run` 실행 시 오류:
`More than one device connected; please specify a device with the '-d <deviceId>' flag.`

**원인**: Android 에뮬레이터, Windows, Chrome이 동시에 연결된 상태.

**해결**: 목적에 맞게 명시적으로 기기 지정:

```bash
flutter run -d windows   # 데스크톱 (API 테스트 권장)
flutter run -d chrome    # 웹 (CORS 주의)
flutter run -d emulator-5554  # 특정 에뮬레이터
flutter devices  # 연결된 기기 목록 확인
```

**교훈**: 기기가 여러 개 연결됐을 때 `-d` 플래그는 필수다. 항상 명시적으로 지정하는 습관을 들일 것.

---

## [미해결] 대화 기록 앱 종료 후 초기화

**증상**: 앱을 종료하고 다시 실행하면 이전 대화 기록이 모두 사라진다.

**원인**: 데이터를 Riverpod 메모리에만 저장하고 있다. `shared_preferences` 또는 로컬 DB(Hive, Isar)를 사용하지 않음.

**현재 상태**: ⚠️ 미해결 — 수업 과제 범위 내에서는 허용. 발표 시 한계로 언급.

**향후 해결 방향**: `shared_preferences`로 간단한 직렬화 저장, 또는 Hive/Isar 로컬 DB 도입.

---

## [미해결] Android 빌드 서명 키 미설정

**증상**: `flutter build apk --release` 실행 시 서명 키스토어가 없으면 디버그 서명으로만 빌드된다.

**현재 상태**: ⚠️ 미해결 — 과제 제출 범위에서는 디버그 APK로 충분.

**향후 해결 방향**: `android/key.properties` + `.jks` 파일 생성 후 `build.gradle` 설정.
키 파일은 절대 git에 커밋하지 말 것 (이미 `.gitignore` 적용됨).
