// 대화 메시지 모델 — 채팅 화면의 각 말풍선 데이터

class Message {
  final String role;    // 'user' 또는 'assistant'
  final String content;
  final DateTime createdAt;

  const Message({
    required this.role,
    required this.content,
    required this.createdAt,
  });

  // 사용자가 보낸 메시지인지 여부
  bool get isUser => role == 'user';

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      role: json['role'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'role': role,
    'content': content,
    'created_at': createdAt.toIso8601String(),
  };
}
