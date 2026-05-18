// Supabase 프로젝트 설정값
// TODO: supabase.com 에서 프로젝트 생성 후 실제 값으로 교체할 것
// ⚠️ 실제 키를 입력한 뒤에는 git에 커밋하지 않도록 주의

class SupabaseConfig {
  SupabaseConfig._(); // 인스턴스 생성 방지

  // supabase.com → 프로젝트 → Settings → API → Project URL
  static const String url = 'YOUR_SUPABASE_URL';

  // supabase.com → 프로젝트 → Settings → API → anon public key
  static const String anonKey = 'YOUR_SUPABASE_ANON_KEY';
}
