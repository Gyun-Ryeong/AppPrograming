// 인증 상태 관리 — 메모리 기반 Mock 인증 (Supabase 제거로 로컬 Map 사용)

import 'package:flutter_riverpod/flutter_riverpod.dart';

// 테스트용 계정 (앱 종료 시 초기화)
const _mockUsers = {
  'test@mef.com': 'test1234',
};

// 인증 상태 Notifier
class AuthNotifier extends Notifier<AsyncValue<String?>> {
  // 메모리에 등록된 사용자 저장 (앱 종료 시 초기화)
  final Map<String, String> _localUsers = Map.from(_mockUsers);

  @override
  AsyncValue<String?> build() => const AsyncValue.data(null);

  /// 로그인 — 이메일/비밀번호 확인 후 상태 업데이트
  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 500)); // 로딩 UX

    if (_localUsers[email] == password) {
      state = AsyncValue.data(email);
    } else {
      state = AsyncValue.error('이메일 또는 비밀번호가 올바르지 않습니다.', StackTrace.current);
    }
  }

  /// 회원가입 — 중복 이메일 확인 후 등록
  Future<void> signUp({required String email, required String password}) async {
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 500));

    if (_localUsers.containsKey(email)) {
      state = AsyncValue.error('이미 사용 중인 이메일입니다.', StackTrace.current);
    } else {
      _localUsers[email] = password;
      state = AsyncValue.data(email);
    }
  }

  /// 로그아웃
  void signOut() => state = const AsyncValue.data(null);
}

final authNotifierProvider =
    NotifierProvider<AuthNotifier, AsyncValue<String?>>(AuthNotifier.new);
