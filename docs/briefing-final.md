# MEF 발표 브리핑

> 발표 자료 제작 시 참고용 — 현재 프로젝트의 실제 구현 상태 기준

---

## 앱 한 줄 소개

> "상황을 입력하면 AI가 파트너가 되어 실전 영어를 연습하고, 대화 후 문법·표현 피드백을 제공하는 앱"

---

## 기술 스택 (실제 사용 기준)

| 항목 | 기술 | 비고 |
|------|------|------|
| 프레임워크 | Flutter 3.44.1 (Dart) | Android / iOS / Web 동시 지원 |
| 상태 관리 | Riverpod 2.6.1 | AsyncNotifier, Notifier |
| 라우팅 | go_router 14 | 선언형 라우팅 |
| AI API | Google Gemini 2.5 Flash | 직접 HTTP 호출 |
| 인증 | 로컬 메모리 더미 | test@mef.com / test1234 |
| 배포 | GitHub Pages (발표자료), APK (앱) | 백엔드 서버 없음 |

---

## 4개 AI Agent 구조

| Agent | 역할 | 파일 | 상태 |
|-------|------|------|------|
| ScenarioAgent | 상황 입력 → 시나리오 JSON 생성 | `scenario_service.dart` | ✅ 완성 |
| ConversationAgent | 시나리오 기반 실시간 대화 | `conversation_service.dart` | ✅ 완성 |
| FeedbackAgent | 대화 종료 후 문법/표현 피드백 | `feedback_service.dart` | ✅ 완성 |
| AnalysisAgent | 누적 대화 약점 패턴 분석 | `analysis_service.dart` | ✅ 완성 |

---

## 화면 구성 (총 8개)

| 화면 | 경로 | 담당 |
|------|------|------|
| 로그인 | `/login` | 팀원 A |
| 회원가입 | `/sign-up` | 팀원 A |
| 홈 | `/` | 팀원 B |
| 상황 입력 | `/scenario/input` | 팀원 A |
| 시나리오 확인 | `/scenario/result` | 팀원 A |
| 대화 | `/conversation` | 팀원 B |
| 피드백 | `/feedback` | 팀원 B |
| 대화 기록 | `/history` | 팀원 B |
| 약점 분석 | `/analysis` | 팀원 A + B |

---

## 발표 시연 흐름 (권장 순서)

```
1. 앱 실행 → 로그인 화면
2. test@mef.com / test1234 로그인
3. 홈 화면 → "새 대화 시작"
4. 상황 입력: "카페에서 음료 주문하기" / 중급 / 일상
5. "시나리오 생성" 버튼 → Gemini API 호출 (약 2~3초)
6. 시나리오 확인 화면 — 배경/역할/목표 표시
7. "대화 시작" → 채팅 화면 — AI와 실제 영어 대화
8. "대화 종료" → 피드백 화면 — 문법 오류 + 자연스러움 점수
9. (선택) 약점 분석 화면 — 누적 패턴 시각화
```

---

## 아키텍처 핵심 원칙 (발표 설명용)

```
Presentation  →  Application  →  Domain  →  Data
screens/          providers/      models/    services/
```

- **화면(screens)**: UI만 담당, 로직 없음
- **providers**: 상태 관리 (AsyncValue로 로딩/성공/에러 처리)
- **services**: AI API 호출 전담 (화면에서 직접 호출 금지)
- **models**: 데이터 구조 정의 (Scenario, Feedback, AnalysisReport 등)

---

## 예상 Q&A

**Q. Flutter를 선택한 이유?**
> 단일 코드베이스로 Android·iOS 동시 지원, JS Bridge 없이 네이티브 컴파일 → 실시간 채팅 UI에 유리. React Native 대비 UI 일관성 우수. (ADR-0001)

**Q. 왜 Supabase를 제거했나?**
> 수업 과제 범위에서 DB 없이 동작하는 MVP를 먼저 완성하는 것이 우선. API 키 보호는 추후 서버 프록시로 해결 예정. (ADR-0003)

**Q. API 키가 클라이언트에 있으면 보안 문제 아닌가?**
> 맞다. 현재는 프로토타입이라 `api_config.dart`에 있고 `.gitignore`로 git에서 제외. 실서비스 전환 시 서버 프록시(Edge Function 등) 도입 예정.

**Q. 상태 관리로 Riverpod을 선택한 이유?**
> Provider의 context 의존 문제 해결, 컴파일 타임 안전성, `AsyncValue`로 로딩/성공/에러 세 상태를 선언적으로 처리 가능. (ADR-0002)

**Q. 대화 기록이 앱 종료 후에도 유지되나?**
> 현재는 메모리에만 저장되어 앱 종료 시 초기화됨. 추후 `shared_preferences` 또는 SQLite 연동 예정.

**Q. 새 화면을 추가하면 어느 폴더에?**
> `lib/screens/` 하위에 기능명 폴더 생성 후 파일 추가. 상태 필요 시 `lib/providers/`, API 호출 시 `lib/services/`에 추가.

---

## 과제 점수 현황

| 점수 | 항목 | 상태 |
|------|------|------|
| +1 | vision.md, requirements.md | ✅ |
| +2 | wbs.md, schedule.md | ✅ |
| +3 | architecture.md + ADR 5개 | ✅ |
| +4 | setup.md, deploy.md, testing.md | ✅ |
| +5 | AGENTS.md + README.md + .github/agents/ | ✅ |

**가산점 항목 (확인 필요):**
- `BONUS.md` — AI Agent 활용 사례 기록 여부
- `AUTHORING.{이름}.md` — 본인 부트스트랩 파일
