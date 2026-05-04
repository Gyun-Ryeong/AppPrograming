# ADR-0001: 모바일 프레임워크 선택 — React Native vs Flutter

| 항목 | 내용 |
|------|------|
| 상태 | 승인됨 (Accepted) |
| 결정일 | 2026-05-03 |
| 결정자 | 프로젝트 팀 |
| 관련 문서 | docs/architecture.md |

---

## 맥락 (Context)

MEF는 iOS와 Android 모두를 지원하는 모바일 앱이다.  
네이티브 앱(Swift + Kotlin) 대신 크로스플랫폼 프레임워크를 사용하기로 결정했고,
현재 유력한 두 선택지는 **React Native**와 **Flutter**다.

두 프레임워크 모두 단일 코드베이스로 iOS/Android를 동시에 지원하며,
성숙한 생태계를 가지고 있다.

---

## 결정 (Decision)

**React Native를 선택한다.**

---

## 선택 이유 (Rationale)

### React Native를 선택한 이유

1. **기존 기술 스택과의 연속성**  
   팀(또는 개발자)이 JavaScript/TypeScript와 React에 이미 익숙하다.  
   Flutter는 Dart라는 새로운 언어를 배워야 하므로 학습 비용이 추가로 발생한다.

2. **웹 개발 지식의 재활용**  
   React 컴포넌트 모델, 훅(Hook), 상태 관리 개념이 React Native에 그대로 적용된다.  
   HTML/CSS 경험이 있다면 Flexbox 레이아웃을 빠르게 습득할 수 있다.

3. **JavaScript 생태계의 풍부한 라이브러리**  
   npm 생태계를 그대로 활용할 수 있다.  
   Anthropic SDK, Supabase JS 클라이언트 등 AI/BaaS 라이브러리가 공식 JS 버전으로 제공된다.

4. **Expo를 통한 빠른 프로토타이핑**  
   Expo Go 앱을 사용하면 네이티브 빌드 없이 실기기에서 즉시 테스트 가능하다.  
   빌드 환경(Xcode, Android Studio) 설정 없이 개발을 시작할 수 있어 초기 진입 장벽이 낮다.

5. **커뮤니티 및 레퍼런스**  
   Meta가 주도하며 Microsoft, Shopify 등 대기업이 프로덕션에서 사용 중이다.  
   Stack Overflow, GitHub Issues 등에 한국어 자료도 상대적으로 풍부하다.

---

## 비교 분석 (Flutter와의 비교)

| 항목 | React Native | Flutter |
|------|-------------|---------|
| 언어 | JavaScript / TypeScript | Dart |
| 학습 곡선 | 낮음 (JS/React 경험 있을 때) | 보통 (Dart 신규 학습 필요) |
| 성능 | 우수 (JS Bridge → JSI로 개선 중) | 매우 우수 (직접 렌더링) |
| UI 일관성 | 네이티브 컴포넌트 사용 (플랫폼별 차이 있음) | 자체 렌더링 엔진 (완벽한 일관성) |
| 생태계 | npm 풍부, AI/BaaS SDK 공식 지원 | pub.dev, 성장 중 |
| 빠른 프로토타입 | Expo Go로 즉시 가능 | 빌드 환경 필요 |
| 구글/AI SDK | JS SDK 공식 제공 | Dart SDK 별도 확인 필요 |

---

## 결과적으로 버린 대안 (Rejected Alternatives)

### Flutter
- **버린 이유**: Dart 언어를 새로 배워야 하는 학습 비용, JavaScript 기반 AI/BaaS SDK와의 통합 추가 작업 필요.
- **아쉬운 점**: 성능과 UI 일관성은 Flutter가 더 뛰어날 수 있다. 특히 복잡한 애니메이션이나 게임 수준의 UI가 필요하다면 Flutter가 유리하다.

### React Native CLI (Expo 없이)
- **버린 이유**: 네이티브 빌드 설정(Xcode, Android Studio)이 필요해 초기 환경 설정에 시간이 소요된다. 수업 과제 특성상 빠른 프로토타이핑이 우선이므로 **Expo 기반 React Native**로 시작한다.

---

## 예상 트레이드오프 및 완화 방안

| 트레이드오프 | 완화 방안 |
|-------------|-----------|
| JS Bridge 성능 병목 가능성 | 과제 수준에서는 문제 없음. 필요 시 JSI/TurboModules 적용 |
| Expo 제약 (일부 네이티브 기능 제한) | 음성 녹음 등 필요 시 Expo 플러그인 또는 Bare Workflow 전환 |
| 플랫폼별 UI 차이 (iOS vs Android) | 핵심 화면은 직접 테스트, 공통 컴포넌트 사용으로 최소화 |

---

## 검토 시점

다음 상황이 발생하면 이 결정을 재검토한다:
- AI 응답 스트리밍 처리에서 JS Bridge 성능이 UX에 영향을 주는 경우
- 음성 입력(STT) 구현 시 Expo 제약으로 인해 핵심 기능 구현이 불가한 경우
