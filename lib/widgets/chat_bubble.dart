// 채팅 말풍선 위젯 — 사용자(오른쪽)와 AI(왼쪽) 구분
import 'package:flutter/material.dart';
import 'package:mef/constants/app_colors.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser; // true: 사용자(오른쪽), false: AI(왼쪽)

  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        constraints: BoxConstraints(
          // 화면 너비의 75% 이상 넘지 않도록 제한
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppColors.bubbleUser : AppColors.bubbleAI,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isUser ? AppColors.bubbleUserText : AppColors.bubbleAIText,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
