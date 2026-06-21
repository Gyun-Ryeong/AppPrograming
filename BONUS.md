# BONUS.md — 가산점 신청 트래킹

> 발표 시 이 파일을 슬라이드 1장으로 어필할 것.
> 가산점은 자동 부여되지 않음 — 반드시 발표에서 직접 설명해야 한다.

---

## 신청 항목

| 항목 | 점수 | 상태 | 증빙 |
|------|------|------|------|
| A. AI Agent 활용 사례 | +1 | ✅ 완료 | `AGENTS.md`, `.github/agents/`, `BONUS.md` |
| B. 본인만의 부트스트랩 기법 | +2 | ❌ 미작성 | `AUTHORING.{이름}.md` 필요 |
| C. LLM Wiki 운영 | +1 | ✅ 완료 | `.planning/wiki/` 7개 파일, 20개+ 항목 |
| D. AI Agent 리포트 발표 | +2 | ❌ 미예약 | 10분 이상, 별도 신청 |

**현재 확보 가산점: +2점 (A + C)**
**최대 목표: +4점 (A + B + C + D)**

---

## A. AI Agent 활용 사례 (+1점)

### 사용한 에이전트 / 워크플로우

| 도구 | 사용 시점 | 효과 |
|------|----------|------|
| Claude Code CLI | 전체 개발 과정 | 코드/문서 자동 생성 |
| AGENTS.md 패턴 | 팀 협업 시작 | 팀원 Claude CLI가 컨텍스트 없이도 작업 범위 파악 |
| `.github/agents/task-*.md` | 매 세션 | 팀원별 담당 범위 자동 로드 |

### 절약된 시간 / 향상된 품질 사례

- **기획 문서 5개**: 수동 작성 예상 2~3시간 → Claude Code로 30분
- **AGENTS.md 팀 협업 구조**: 팀원이 새 세션 시작 시 브리핑 없이 바로 작업 가능
- **Flutter lib/ 구조 + 모든 뼈대 파일**: 구조 설계 + 파일 생성 자동화

---

## B. 본인만의 부트스트랩 기법 (+2점) — 미완성

> 작성 예정: `AUTHORING.{본인이름}.v0.1.0.md`
>
> 내용: 새 프로젝트 시작 시 AGENTS.md, task-*.md, ADR 시리즈를
> 하나의 명령으로 생성하는 개인화 부트스트랩 파일

**TODO:**
- [ ] 본인 이름으로 파일 생성
- [ ] "왜 이렇게 만들었는가" 2~3분 설명 준비
- [ ] 실제 프로젝트에 사용된 흔적 커밋

---

## C. LLM Wiki (+1점) — 완료

`.planning/wiki/` 폴더에 7개 파일, 20개+ 항목 운영 중.

| 파일 | 내용 | 항목 수 |
|------|------|---------|
| `00-index.md` | 위키 목적·사용법·빠른 참조 | — |
| `01-architecture-evolution.md` | 아키텍처 변천 (React Native→Flutter→Gemini) | 4개 |
| `02-trial-and-error.md` | 시행착오 로그 (Supabase, CORS, JSON 오류 등) | 5개 |
| `03-gemini-api-guide.md` | Gemini API 실전 사용법 | 6개 |
| `04-flutter-patterns.md` | Riverpod·Flutter 패턴 정리 | 5개 |
| `decisions-log.md` | 판단·시행착오 시간순 기록 | 8개 |
| `glossary.md` | 프로젝트 용어 사전 | 22개 |
