# ADR-0001: 모바일 프레임워크 선택 — Flutter vs React Native

| 항목 | 내용 |
|------|------|
| 상태 | 승인됨 (Accepted) |
| 결정일 | 2026-05-04 (초기 React Native → Flutter로 변경) |
| 결정자 | 프로젝트 팀 |
| 관련 문서 | docs/architecture.md |

---

## 맥락 (Context)

MEF는 iOS와 Android 모두를 지원하는 모바일 앱이다.
네이티브 앱(Swift + Kotlin) 대신 크로스플랫폼 프레임워크를 사용하기로 결정했고,
유력한 두 선택지는 **Flutter**와 **React Native**다.

초기에 React Native(Expo)로 프로젝트를 시작했으나,
실제 개발 진입 시점에 Flutter로 전환하기로 결정했다.

---

## 결정 (Decision)

**Flutter를 선택한다.**

---

## 선택 이유 (Rationale)

### Flutter를 선택한 이유

1. **완벽한 UI 일관성**
   Flutter는 자체 렌더링 엔진(Skia/Impeller)을 사용해 iOS와 Android에서 픽셀 단위로 동일한 UI를 보장한다.
   React Native는 각 플랫폼의 네이티브 컴포넌트를 사용하므로 플랫폼별 UI 차이가 발생할 수 있다.

2. **성능 우위**
   Flutter는 네이티브 코드로 직접 컴파일되며 JS Bridge가 없다.
   React Native는 JavaScript Bridge(또는 JSI)를 통해 네이티브와 통신하므로 성능 병목이 생길 수 있다.
   채팅 UI처럼 실시간 업데이트가 잦은 화면에서 Flutter가 더 유리하다.

3. **Google 공식 지원 및 성장하는 생태계**
   Flutter는 Google이 직접 개발·유지하며, pub.dev 생태계가 빠르게 성장 중이다.
   Supabase, HTTP 호출, 차트 라이브러리 등 이 프로젝트에 필요한 패키지가 모두 존재한다.

4. **Dart의 타입 안전성**
   Dart는 강타입 언어로, 컴파일 타임에 에러를 잡을 수 있다.
   AI 응답을 파싱하고 모델 클래스로 변환하는 과정에서 런타임 오류보다 컴파일 오류가 훨씬 디버깅하기 쉽다.

5. **단일 코드베이스의 완성도**
   Flutter 하나로 Android / iOS / Web / Desktop 모두 빌드 가능하다.
   과제 수준에서는 Android + iOS만 필요하지만, 향후 확장성이 뛰어나다.

---

## 비교 분석 (React Native와의 비교)

| 항목 | Flutter | React Native |
|------|---------|-------------|
| 언어 | Dart | JavaScript / TypeScript |
| 렌더링 | 자체 엔진 (Skia/Impeller) | 플랫폼 네이티브 컴포넌트 |
| UI 일관성 | 완벽 (픽셀 단위 동일) | 플랫폼별 차이 있음 |
| 성능 | 매우 우수 (JS Bridge 없음) | 우수 (JSI로 개선 중) |
| 학습 곡선 | 보통 (Dart 신규 학습 필요) | 낮음 (JS/React 경험 시) |
| 생태계 | pub.dev, 빠르게 성장 중 | npm 풍부 |
| 빠른 프로토타입 | flutter run으로 즉시 | Expo Go로 즉시 |
| 상태 관리 | Riverpod (공식 권장) | Context / Zustand 등 다양 |
| 네비게이션 | go_router (공식 권장) | React Navigation |

---

## 결과적으로 버린 대안 (Rejected Alternatives)

### React Native (Expo)
- **버린 이유**:
  - JS Bridge 기반 아키텍처는 실시간 채팅처럼 업데이트가 잦은 화면에서 성능 우려가 있다.
  - 플랫폼별 UI 차이를 별도로 처리해야 하는 오버헤드가 발생한다.
  - Expo Go의 편리함은 있지만, 네이티브 모듈 제한이 STT/TTS 구현 시 장벽이 될 수 있다.
- **아쉬운 점**: JavaScript/TypeScript 경험이 있다면 초기 진입 장벽이 낮고, npm 생태계의 AI SDK 활용이 편리하다.

### 네이티브 (Swift + Kotlin 별도 개발)
- **버린 이유**: iOS와 Android를 각각 개발해야 하므로 7주 일정에서 비현실적이다.

---

## 예상 트레이드오프 및 완화 방안

| 트레이드오프 | 완화 방안 |
|-------------|-----------|
| Dart 언어 신규 학습 필요 | Flutter 공식 문서 + Flutter Cookbook로 빠르게 습득 |
| Supabase Edge Function은 TypeScript 작성 | Flutter 클라이언트와 HTTP POST로 통신 — 언어 혼용이지만 레이어가 명확히 분리됨 |
| pub.dev 일부 패키지 품질 편차 | 공식 권장 패키지 우선 사용 (supabase_flutter, go_router, riverpod) |

---

## 검토 시점

다음 상황이 발생하면 이 결정을 재검토한다:
- pub.dev에서 핵심 기능 구현에 필요한 패키지를 찾을 수 없는 경우
- Flutter의 특정 플랫폼 빌드 환경 문제로 개발이 2일 이상 지연되는 경우
