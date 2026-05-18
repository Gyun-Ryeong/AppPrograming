# 배포 가이드

> MEF 앱의 배포 절차. Android APK 직접 설치 기준.
> iOS 배포는 Apple Developer 계정 필요 (수업 과제 범위 외).

---

## 사전 준비

```bash
flutter doctor          # 환경 점검
flutter --version       # Flutter 3.35.3 이상
```

Android 배포에 필요한 것:
- Android Studio (SDK 포함) 또는 Android 커맨드라인 도구
- 서명 키스토어 파일 (아래 단계에서 생성)

---

## 1. Supabase Edge Function 배포

AI API 프록시 서버(Edge Function)를 먼저 배포해야 앱이 동작한다.

```bash
# Supabase CLI 설치 (최초 1회)
npm install -g supabase

# 로그인
supabase login

# 프로젝트 링크 (YOUR_PROJECT_ID는 Supabase 콘솔에서 확인)
supabase link --project-ref YOUR_PROJECT_ID

# Edge Function 배포
supabase functions deploy conversation-agent
supabase functions deploy scenario-agent
supabase functions deploy feedback-agent
```

Edge Function 환경변수 설정 (Supabase 콘솔 → Settings → Edge Functions):
```
ANTHROPIC_API_KEY=sk-ant-...
```

---

## 2. Android APK 빌드

### 2-1. 서명 키스토어 생성 (최초 1회)

```bash
keytool -genkey -v -keystore android/app/mef-release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias mef-key
```

> ⚠️ `mef-release.jks` 파일은 절대 git에 커밋하지 않는다.

### 2-2. `android/key.properties` 파일 생성

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=mef-key
storeFile=mef-release.jks
```

> ⚠️ `key.properties`도 git 커밋 금지 (`.gitignore`에 포함됨).

### 2-3. `android/app/build.gradle` 서명 설정 확인

```gradle
def keyProperties = new Properties()
def keyPropertiesFile = rootProject.file('key.properties')
if (keyPropertiesFile.exists()) {
    keyPropertiesFile.withReader('UTF-8') { reader ->
        keyProperties.load(reader)
    }
}

android {
    signingConfigs {
        release {
            keyAlias keyProperties['keyAlias']
            keyPassword keyProperties['keyPassword']
            storeFile keyProperties['storeFile'] ? file(keyProperties['storeFile']) : null
            storePassword keyProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### 2-4. APK 빌드

```bash
# 환경변수 설정 (.env 파일 또는 직접 입력)
# SUPABASE_URL, SUPABASE_ANON_KEY 필요

flutter build apk --release
```

빌드 결과물: `build/app/outputs/flutter-apk/app-release.apk`

---

## 3. 테스트 기기에 설치

```bash
# USB 연결 후 (USB 디버깅 활성화 필요)
flutter install

# 또는 APK 파일 직접 전송 후 설치
adb install build/app/outputs/flutter-apk/app-release.apk
```

---

## 4. 발표 데모 체크리스트

발표 전날 반드시 확인:

- [ ] Supabase Edge Function 배포 상태 확인
- [ ] Supabase 무료 티어 한도 확인 (DB 500MB, Edge Function 500K/월)
- [ ] 테스트 계정 사전 생성 (회원가입 과정 생략 가능하도록)
- [ ] 발표 장소 Wi-Fi 환경 확인 (Supabase는 온라인 필수)
- [ ] 오프라인 폴백: 화면 캡처 또는 녹화 영상 준비
- [ ] APK 파일 USB에 백업

---

## 자주 묻는 문제

**Q: `flutter build apk` 중 Gradle 오류**
```bash
cd android && ./gradlew clean && cd ..
flutter build apk --release
```

**Q: Supabase Edge Function 응답 없음**
- Supabase 콘솔 → Logs → Edge Functions에서 오류 확인
- `ANTHROPIC_API_KEY` 환경변수 설정 여부 재확인

**Q: 앱 설치 후 로그인이 안 됨**
- `lib/main.dart`의 Supabase URL/key 확인
- Supabase 콘솔 → Authentication → URL Configuration에서 Redirect URL 확인
