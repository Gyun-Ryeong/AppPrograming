# MEF 개발 환경 설정 가이드

> 목표: 이 문서만 따라하면 **5분 안에** 앱이 실기기 또는 에뮬레이터에서 실행된다.

---

## 사전 준비 (설치 확인)

터미널에서 아래 명령어를 실행해 버전이 출력되는지 확인한다.

```bash
node -v      # v18 이상 필요
npm -v       # v9 이상
git --version
```

없으면 [Node.js 공식 사이트](https://nodejs.org)에서 LTS 버전을 설치한다.

---

## 1단계: 저장소 클론

```bash
git clone <저장소 주소>
cd project/mef
```

---

## 2단계: 의존성 설치

```bash
npm install
```

> `node_modules/` 폴더가 생성되면 완료. 1–2분 소요.

---

## 3단계: 앱 실행

### 방법 A — Expo Go 앱 (가장 빠름, 추천)

1. 스마트폰에 **Expo Go** 앱 설치
   - [iOS App Store](https://apps.apple.com/app/expo-go/id982107779)
   - [Google Play](https://play.google.com/store/apps/details?id=host.exp.exponent)

2. 터미널에서 실행:
   ```bash
   npm start
   ```

3. 터미널에 QR 코드가 표시되면, Expo Go 앱으로 스캔한다.
   - iOS: 카메라 앱으로 스캔 → Expo Go에서 열기
   - Android: Expo Go 앱 내 스캔 버튼 사용

### 방법 B — Android 에뮬레이터

1. Android Studio 설치 후, AVD(가상 기기) 실행
2. 터미널에서:
   ```bash
   npm run android
   ```

### 방법 C — iOS 시뮬레이터 (Mac 전용)

```bash
npm run ios
```

---

## 4단계: 코드 수정 → 즉시 확인

`app/(tabs)/index.tsx` 파일에서 텍스트를 수정하고 저장하면, 앱이 **자동으로 새로고침**된다.

---

## 자주 쓰는 명령어

| 명령어 | 설명 |
|--------|------|
| `npm start` | 개발 서버 시작 (QR 코드 방식) |
| `npm run android` | Android 에뮬레이터에서 실행 |
| `npm run ios` | iOS 시뮬레이터에서 실행 (Mac 전용) |
| `npm run lint` | ESLint 코드 품질 검사 |

---

## 프로젝트 구조 한눈에 보기

```
mef/
├── app/                    # 화면 라우팅 (Expo Router, 파일 = 경로)
│   ├── _layout.tsx         # 루트 레이아웃 (전체 앱 감싸는 프로바이더)
│   ├── modal.tsx           # 모달 화면
│   └── (tabs)/             # 하단 탭 네비게이션
│       ├── index.tsx       # 홈 탭
│       └── explore.tsx     # 탐색 탭
├── src/                    # 실제 비즈니스 로직 코드
│   ├── components/         # 재사용 UI 컴포넌트
│   ├── constants/          # 색상, 폰트 등 공통 상수
│   ├── context/            # 전역 상태 (AuthContext 등)
│   ├── hooks/              # 커스텀 훅
│   └── services/           # AI Agent 및 Supabase API 호출 (AI 호출은 여기서만)
├── assets/                 # 이미지, 폰트 등 정적 파일
└── docs/                   # 개발 문서 (지금 이 파일)
```

**핵심 규칙**: AI 호출(Anthropic API)은 반드시 `src/services/` 에서만 수행한다. 화면 컴포넌트에서 직접 호출하지 않는다.

---

## import 경로 규칙

이 프로젝트는 `@/` 별칭이 프로젝트 루트를 가리킨다.

```typescript
// 올바른 예시
import { ThemedText } from '@/src/components/themed-text';
import { Colors } from '@/src/constants/theme';
import { useColorScheme } from '@/src/hooks/use-color-scheme';
import { generateScenario } from '@/src/services/scenarioService';

// 라우팅 이미지 등 루트 레벨 파일
import logo from '@/assets/images/logo.png';
```

---

## 문제 해결

**Q: QR 스캔 후 앱이 열리지 않는다**
- 스마트폰과 개발 PC가 **같은 Wi-Fi**에 연결되어 있는지 확인한다.
- 안 되면 터미널에서 `s` 키를 눌러 터널 모드로 전환한다.

**Q: `npm install` 중 에러가 난다**
- Node.js 버전을 확인한다 (`node -v`). v18 미만이면 업그레이드한다.
- `npm cache clean --force` 후 다시 시도한다.

**Q: 변경사항이 앱에 반영되지 않는다**
- Expo Go 앱을 완전히 종료 후 재시작한다.
- 터미널에서 `r` 키를 눌러 강제 새로고침한다.
