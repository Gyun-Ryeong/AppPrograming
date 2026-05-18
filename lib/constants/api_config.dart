// Claude API 설정값
// ⚠️ 실제 API 키는 git에 커밋하지 않도록 주의 (데모용으로만 사용)

class ApiConfig {
  ApiConfig._();

  // Anthropic Console(console.anthropic.com)에서 발급받은 API 키
  static const String claudeApiKey = 'YOUR_CLAUDE_API_KEY';

  // 사용할 Claude 모델 (빠르고 저렴한 Haiku 사용)
  static const String claudeModel = 'claude-haiku-4-5-20251001';

  static const String claudeApiUrl = 'https://api.anthropic.com/v1/messages';
  static const String anthropicVersion = '2023-06-01';
}
