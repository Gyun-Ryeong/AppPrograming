# ADR-0003: 백엔드 선택 — Supabase

- 상태: Accepted
- 날짜: 2026-05-18
- 결정자: MEF 팀

## 배경

MEF 앱에는 아래 백엔드 기능이 필요하다:
1. 사용자 인증 (회원가입 / 로그인 / 세션 유지)
2. 데이터 저장 (대화 세션, 메시지, 피드백)
3. AI API 프록시 (Anthropic Claude API 키를 클라이언트에 노출하지 않기 위한 서버)

## 고려한 대안

### 대안 A: Firebase (Google)
- 장점: 문서 풍부, Flutter 공식 SDK 있음, Realtime Database / Firestore
- 단점: NoSQL 구조 — 관계형 데이터(세션↔메시지↔피드백) 표현 불편, Cloud Functions 콜드스타트 느림, Google 종속성

### 대안 B: 직접 서버 (Node.js / Express + PostgreSQL)
- 장점: 완전한 제어권, 원하는 구조 자유롭게 구성
- 단점: 서버 인프라 직접 관리, 인증 직접 구현, 7주 안에 완성 불가능한 범위

### 대안 C: AWS Amplify
- 장점: 엔터프라이즈 수준 인프라
- 단점: 학습 비용 매우 높음, 무료 티어 복잡, 설정 과정 길어 수업 과제에 부적합

### 대안 D: Supabase (선택)
- 장점: PostgreSQL 기반(관계형 DB), Auth 내장, Edge Function으로 서버리스 API 프록시, 오픈소스, 무료 티어 충분 (500MB DB, 500K Edge Function 요청/월)
- 단점: Firebase 대비 커뮤니티 규모 작음, Edge Function 콜드스타트 있음

## 결정

**Supabase**를 선택한다 (`supabase_flutter: ^2.0.0`).

## 이유

1. **관계형 DB**: 세션-메시지-피드백 간 외래키 관계를 PostgreSQL로 자연스럽게 표현
2. **API 키 보호**: Supabase Edge Function(TypeScript)이 Anthropic API 키를 서버에서만 관리 → 클라이언트 코드에 키 노출 없음
3. **Auth 내장**: Supabase Auth로 이메일/비밀번호 인증을 3줄로 구현 (`supabase.auth.signInWithPassword()`)
4. **오픈소스**: Firebase처럼 벤더 락인 없음
5. **무료 티어**: 수업 과제 기간(7주) 동안 과금 없음

## 결과

긍정:
- DB 스키마를 SQL로 직접 관리 (버전 관리 가능)
- Flutter SDK가 Auth + DB + Storage를 통합 제공

부정 / 제약:
- Supabase URL과 anon key를 `.env` 파일로 관리해야 함 (git 커밋 금지)
- Edge Function 배포는 Supabase CLI 필요

## DB 스키마 요약

```sql
sessions   -- 대화 세션 (user_id, scenario, status, 시작/종료 시각)
messages   -- 대화 메시지 (session_id, role, content)
feedbacks  -- 피드백 결과 (session_id, grammar_errors, expression_suggestions, naturalness_score)
```

## 후속 작업

- [ ] Supabase 프로젝트 생성 (supabase.com)
- [ ] `lib/main.dart`에 `Supabase.initialize()` 추가
- [ ] `.env.example` 파일로 URL/키 형식 공유
- [ ] Edge Function 초안 작성 (Anthropic API 프록시)
