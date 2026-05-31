// 로컬 더미 인증 Provider — Supabase 없이 메모리에서 로그인/회원가입 상태를 관리한다
// 실제 서버 연동 없이 앱 흐름을 테스트하기 위한 구현

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';

// 앱 실행 동안 유지되는 로컬 사용자 DB (이메일 → 비밀번호)
// 기본 테스트 계정 포함
final Map<String, String> _localUsers = {
  'test@mef.com': 'test1234',
};

// 인증 상태 Notifier — AsyncValue<User?>
// null = 미로그인, User = 로그인 완료
class AuthNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async => null; // 앱 시작 시 미로그인 상태

  // 로그인: 로컬 DB에서 이메일/비밀번호 확인
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    // 네트워크 딜레이 시뮬레이션
    await Future.delayed(const Duration(milliseconds: 600));

    final stored = _localUsers[email];
    if (stored == null || stored != password) {
      state = AsyncError('이메일 또는 비밀번호가 올바르지 않습니다', StackTrace.current);
      return;
    }

    state = AsyncData(User(email: email));
  }

  // 회원가입: 로컬 DB에 이메일/비밀번호 저장 후 즉시 로그인
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    await Future.delayed(const Duration(milliseconds: 600));

    if (_localUsers.containsKey(email)) {
      state = AsyncError('이미 등록된 이메일입니다', StackTrace.current);
      return;
    }

    _localUsers[email] = password;
    state = AsyncData(User(email: email));
  }

  // 로그아웃
  void signOut() {
    state = const AsyncData(null);
  }
}

// 전역 Provider — 모든 화면에서 ref.watch(authNotifierProvider)로 접근
final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, User?>(
  AuthNotifier.new,
);
