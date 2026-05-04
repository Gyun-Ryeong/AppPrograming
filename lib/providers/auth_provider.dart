// 인증 상태 관리 — Riverpod Provider
// TODO: supabase_flutter + flutter_riverpod 패키지 추가 후 구현

// 사용자 정보 모델
class AuthUser {
  final String id;
  final String email;

  const AuthUser({required this.id, required this.email});
}

// TODO: Riverpod Provider 구현
// final authProvider = StateNotifierProvider<AuthNotifier, AuthUser?>((ref) {
//   return AuthNotifier();
// });
//
// class AuthNotifier extends StateNotifier<AuthUser?> {
//   AuthNotifier() : super(null);
//
//   Future<void> signIn(String email, String password) async {
//     // Supabase signInWithPassword 호출
//   }
//
//   Future<void> signOut() async {
//     // Supabase signOut 호출
//     state = null;
//   }
// }
