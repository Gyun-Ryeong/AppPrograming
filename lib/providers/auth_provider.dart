// 인증 상태 관리 — Supabase Auth 스트림을 Riverpod으로 감싼다

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Supabase 클라이언트 단일 인스턴스를 Provider로 노출
final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// 현재 로그인한 사용자 정보 — null이면 비로그인 상태
final authUserProvider = StreamProvider<User?>((ref) {
  final supabase = ref.watch(supabaseProvider);
  // onAuthStateChange 스트림: 로그인/로그아웃/세션 갱신 시 자동으로 새 값 방출
  return supabase.auth.onAuthStateChange.map((event) => event.session?.user);
});

// 로그인/로그아웃 액션을 담당하는 Notifier
class AuthNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  // 이메일/비밀번호 로그인
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    });
  }

  // 이메일/비밀번호 회원가입
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );
    });
  }

  // 로그아웃
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Supabase.instance.client.auth.signOut();
    });
  }
}

// 화면에서 signIn/signUp/signOut 호출할 때 사용하는 Provider
final authNotifierProvider =
    NotifierProvider<AuthNotifier, AsyncValue<void>>(AuthNotifier.new);
