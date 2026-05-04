// 앱 전체 색상 상수 — 하드코딩 금지, 여기서만 정의한다

import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // 인스턴스 생성 방지

  static const Color primary = Color(0xFF4A90D9);
  static const Color primaryDark = Color(0xFF2C6FAD);
  static const Color accent = Color(0xFF50C878);

  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFE53935);

  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFFBDBDBD);

  // 채팅 말풍선
  static const Color bubbleUser = Color(0xFF4A90D9);
  static const Color bubbleAI = Color(0xFFF0F0F0);
  static const Color bubbleUserText = Colors.white;
  static const Color bubbleAIText = Color(0xFF1A1A2E);
}
