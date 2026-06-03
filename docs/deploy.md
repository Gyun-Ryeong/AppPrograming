# 배포 가이드

> MEF 앱 배포 절차. 현재는 로컬 실행 및 APK 빌드 기준.

---

## 사전 준비

```bash
flutter doctor    # 환경 점검
flutter --version # Flutter 3.35.3 이상
```

---

## 1. API 키 설정

`lib/constants/api_config.dart` 직접 생성 (git에 포함되지 않음):

```dart
class ApiConfig {
  ApiConfig._();
  static const String apiKey = 'YOUR_GOOGLE_AI_STUDIO_KEY';
  static const String model = 'gemini-2.5-flash';
  static const String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=YOUR_GOOGLE_AI_STUDIO_KEY';
}
```

API 키 발급: `aistudio.google.com` → Get API Key → Create API Key

---

## 2. 웹(크롬) 실행

```bash
flutter pub get
flutter run -d chrome
```

---

## 3. Windows 앱 실행

```bash
flutter run -d windows
```

---

## 4. Android APK 빌드

```bash
# 릴리즈 APK 빌드
flutter build apk --release

# 결과물 위치
# build/app/outputs/flutter-apk/app-release.apk
```

테스트 기기에 설치:
```bash
flutter install
```

---

## 발표 데모 체크리스트

- [ ] API 키 설정 확인
- [ ] `flutter run` 실행 확인
- [ ] 로그인 → 시나리오 → 채팅 → 피드백 흐름 1회 테스트
- [ ] 데모 영상 백업 준비 (API 불안정 대비)
- [ ] 노트북 충전 100%

---

## 자주 묻는 문제

**Q: 시나리오 생성이 실패해요**
→ Google AI Studio 무료 모델 rate limit (하루 20회). 잠시 후 재시도.

**Q: `flutter pub get` 오류**
```bash
flutter clean
flutter pub get
```

**Q: api_config.dart를 찾을 수 없다는 오류**
→ `.gitignore`에 포함된 파일. 위 1번 단계 참고해서 직접 생성.
