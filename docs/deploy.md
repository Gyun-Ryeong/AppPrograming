# 배포 가이드

> MEF 앱의 배포 절차.
> 백엔드 서버 없음 — Gemini API 직접 호출, 로컬 더미 인증 사용.

---

## 사전 준비

```bash
flutter doctor          # 환경 점검
flutter --version       # Flutter 3.44.1 이상
```

`lib/constants/api_config.dart` 파일이 있어야 한다 (`.gitignore`에 포함되어 있으므로 직접 생성):

```dart
class ApiConfig {
  ApiConfig._();

  static const String _geminiApiKey = 'YOUR_GEMINI_API_KEY';
  static const String _model = 'gemini-2.5-flash';
  static const String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent?key=$_geminiApiKey';
}
```

> Gemini API 키는 [Google AI Studio](https://aistudio.google.com)에서 발급받는다.

---

## 1. 발표 자료 — GitHub Pages 배포

발표 슬라이드(`index.html`)는 GitHub Pages로 배포한다.

```bash
# index.html 수정 후 push하면 자동 반영
git add index.html
git commit -m "docs: 발표자료 업데이트"
git push origin main
```

배포 URL: `https://gyun-ryeong.github.io/AppPrograming/`

> GitHub Pages 최초 활성화는 저장소 Settings → Pages → Branch: main / (root) → Save

---

## 2. Flutter 웹 빌드

```bash
flutter build web --release
```

빌드 결과물: `build/web/`

로컬에서 확인:
```bash
flutter run -d chrome
```

---

## 3. Android APK 빌드

```bash
flutter build apk --release
```

빌드 결과물: `build/app/outputs/flutter-apk/app-release.apk`

테스트 기기에 설치:
```bash
# USB 연결 후 (USB 디버깅 활성화 필요)
adb install build/app/outputs/flutter-apk/app-release.apk
```

---

## 4. 발표 데모 체크리스트

발표 전날 반드시 확인:

- [ ] `api_config.dart`에 Gemini API 키 입력 여부 확인
- [ ] 시나리오 생성 → 대화 → 피드백 전체 플로우 동작 확인
- [ ] 테스트 계정 확인 (`test@mef.com` / `test1234`)
- [ ] 발표 장소 Wi-Fi 환경 확인 (Gemini API는 온라인 필수)
- [ ] 오프라인 폴백: 화면 녹화 영상 준비
- [ ] GitHub Pages URL 접속 확인

---

## 자주 묻는 문제

**Q: 시나리오 생성이 안 됨**
- `api_config.dart`의 API 키 확인
- Gemini API 키 유효 여부 확인 (Google AI Studio 콘솔)
- 429 오류면 rate limit — 잠시 후 재시도

**Q: `flutter build apk` 중 Gradle 오류**
```bash
cd android && ./gradlew clean && cd ..
flutter build apk --release
```

**Q: Chrome 실행 시 CORS 오류**
- Gemini API는 URL에 키를 포함하는 방식으로 CORS 헤더 없이 호출 가능
- 오류 발생 시 `flutter run -d chrome --web-browser-flag "--disable-web-security"` 시도
