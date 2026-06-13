# MEF Wiki — 프로젝트 맥락 · 결정 히스토리

> **목적**: 개발하면서 내린 판단, 시행착오, 해결법을 축적하는 내부 지식 베이스.
> 코드에 담기지 않는 "왜"와 "어떻게"를 기록한다.
>
> **공식 의사결정 문서**(ADR)와 달리 wiki는 과정 중 발견한 것을 자유롭게 쌓는다.
> 짧은 메모도 괜찮다. 나중에 읽는 사람(미래의 나, 팀원, 발표 준비 중인 나)을 위해 쓴다.

---

## 문서 목록

| 파일 | 내용 | 마지막 업데이트 |
|------|------|----------------|
| [01-architecture-evolution.md](01-architecture-evolution.md) | 아키텍처가 어떻게 바뀌었는가 (React Native → Flutter → 백엔드 제거 → Gemini) | 2026-06-13 |
| [02-trial-and-error.md](02-trial-and-error.md) | 시행착오 로그 — 무엇이 왜 실패했고 어떻게 해결했는가 | 2026-06-13 |
| [03-gemini-api-guide.md](03-gemini-api-guide.md) | Gemini API 실전 사용법 — thinking 모델 특성, CORS, JSON 강제 | 2026-06-13 |
| [04-flutter-patterns.md](04-flutter-patterns.md) | 이 프로젝트에서 쓴 Flutter/Riverpod 패턴 정리 | 2026-06-13 |

---

## 기록 규칙

1. **날짜를 항상 기록한다** — 언제 발견했는지가 맥락이다
2. **해결 못한 것도 기록한다** — 미해결 문제는 `⚠️ 미해결` 태그
3. **짧아도 괜찮다** — 한 줄 메모도 나중에 가치 있다
4. **ADR과 중복되어도 괜찮다** — wiki는 과정, ADR은 결론
5. **새로운 시행착오 발생 시** → `02-trial-and-error.md`에 추가
6. **새로운 기술 결정 시** → `ADR-NNNN` 파일 생성 + 이 index 업데이트

---

## 빠른 참조

- 지금 Gemini API가 안 된다 → [03-gemini-api-guide.md](03-gemini-api-guide.md)
- 왜 Flutter를 쓰는가 → [01-architecture-evolution.md](01-architecture-evolution.md) + ADR-0001
- 발표에서 시행착오 질문 받을 것 같다 → [02-trial-and-error.md](02-trial-and-error.md)
- Riverpod AsyncNotifier 패턴이 헷갈린다 → [04-flutter-patterns.md](04-flutter-patterns.md)
