# MEF 개발 환경 설정 가이드

> 목표: 이 문서만 따라하면 **5분 안에** `flutter run`으로 앱이 실행된다.

---

## 사전 준비 — Flutter SDK 설치 확인

터미널에서 아래 명령어를 실행해 버전이 출력되는지 확인한다.

```bash
flutter --version
```

출력 예시:
```
Flutter 3.x.x • channel stable
Dart 3.x.x
```

없으면 [Flutter 공식 설치 가이드](https://docs.flutter.dev/get-started/install)에서 운영체제에 맞게 설치한다.

설치 후 환경 점검:
```bash
flutter doctor
```

`flutter doctor`에서 **Android toolchain** 또는 **Xcode** 항목에 체크가 없어도 에뮬레이터나 실기기가 연결되어 있으면 실행할 수 있다.

---

## 1단계: 저장소 클론

```bash
git clone https://github.com/Gyun-Ryeong/AppPrograming.git
cd AppPrograming
```

---

## 2단계: 패키지 설치

```bash
flutter pub get
```

> `pubspec.yaml`에 정의된 의존성이 설치된다. 1분 이내 완료.

---

## 3단계: 앱 실행

### 방법 A — 연결된 기기 확인 후 실행 (가장 기본)

```bash
# 연결된 기기 목록 확인
flutter devices

# 기본 기기로 실행
flutter run
```

### 방법 B — Android 에뮬레이터

1. Android Studio 실행 → Virtual Device Manager → 에뮬레이터 시작
2. 터미널에서:
   ```bash
   flutter run
   ```

### 방법 C — 실기기 (USB 연결)

1. 안드로이드: 설정 → 개발자 옵션 → USB 디버깅 활성화 후 USB 연결
2. 아이폰: Xcode에서 기기 신뢰 설정 후 연결
3. 터미널에서:
   ```bash
   flutter run
   ```

---

## 4단계: 코드 수정 → 즉시 확인

앱이 실행된 상태에서 `lib/` 안의 파일을 수정하고 저장하면 **자동으로 Hot Reload**된다.

- **r** 키: Hot Reload (상태 유지하며 UI만 갱신)
- **R** 키: Hot Restart (앱 전체 재시작)
- **q** 키: 종료

---

## 자주 쓰는 명령어

| 명령어 | 설명 |
|--------|------|
| `flutter run` | 앱 실행 |
| `flutter pub get` | 패키지 설치 |
| `flutter pub add <패키지명>` | 새 패키지 추가 |
| `flutter analyze` | 정적 분석 (코드 품질 검사) |
| `flutter test` | 테스트 실행 |
| `flutter build apk` | Android APK 빌드 |
| `flutter build ios` | iOS 빌드 (Mac 전용) |

---

## 프로젝트 구조 한눈에 보기

```
mef/
├── lib/                    # 실제 Dart 코드 (여기서 개발)
│   ├── main.dart           # 앱 진입점
│   ├── screens/            # 화면 위젯 (auth, home, scenario, conversation, feedback, history, analysis)
│   ├── widgets/            # 재사용 공통 위젯
│   ├── services/           # AI Agent 및 Supabase API 호출 (AI 호출은 여기서만)
│   ├── providers/          # Riverpod 상태 관리
│   ├── models/             # 데이터 모델 (Scenario, Message, Feedback 등)
│   ├── router/             # go_router 라우팅 설정
│   └── constants/          # 색상, 문자열 등 공통 상수
├── test/                   # 테스트 코드
├── android/                # Android 네이티브 설정 (직접 수정 거의 없음)
├── ios/                    # iOS 네이티브 설정 (직접 수정 거의 없음)
├── pubspec.yaml            # 패키지 의존성 정의 (npm의 package.json 역할)
├── docs/                   # 개발 문서
└── .planning/              # 기획 문서
```

**핵심 규칙**: AI 호출(Anthropic API)은 반드시 `lib/services/` 에서만 수행한다. 화면 위젯에서 직접 호출하지 않는다.

---

## pubspec.yaml 패키지 추가 예시

나중에 아래 패키지들을 추가할 예정이다:

```yaml
dependencies:
  flutter:
    sdk: flutter
  supabase_flutter: ^2.0.0   # Supabase 인증 + DB
  flutter_riverpod: ^2.0.0   # 상태 관리
  go_router: ^14.0.0         # 네비게이션
  http: ^1.0.0               # HTTP 요청
  fl_chart: ^0.69.0          # 차트 (약점 분석 화면)
```

추가 후 반드시 실행:
```bash
flutter pub get
```

---

## 문제 해결

**Q: `flutter run` 시 "No connected devices" 오류**
- `flutter devices`로 기기 목록 확인
- Android: USB 디버깅 활성화 여부 확인
- 에뮬레이터가 꺼져 있으면 Android Studio에서 먼저 실행

**Q: `flutter pub get` 중 네트워크 오류**
- 사내 네트워크(VPN) 사용 중이면 해제 후 시도
- `flutter pub get --verbose`로 상세 로그 확인

**Q: Hot Reload가 안 된다**
- 새 파일을 추가하거나 `pubspec.yaml`을 수정했다면 **R**(Hot Restart) 또는 앱 재실행 필요
- `flutter clean && flutter pub get && flutter run`으로 초기화

**Q: Android 빌드 시 Java/Gradle 오류**
- Java 17 이상 설치 후 `flutter config --jdk-dir=<JDK 경로>` 실행
