// Gemini API 공통 호출 헬퍼 — 429(요청 과다) 응답 시 잠깐 대기 후 한 번만 재시도

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/api_config.dart';

class GeminiApiHelper {
  GeminiApiHelper._();

  // 재시도 전 대기 시간 — 순간적인 요청 과다(429)는 보통 짧게 풀린다
  static const _retryDelay = Duration(milliseconds: 1500);

  /// Gemini API에 POST 요청을 보낸다.
  /// 429 응답을 받으면 [_retryDelay]만큼 대기 후 단 한 번만 재시도한다.
  static Future<http.Response> post(Map<String, dynamic> body) async {
    final uri = Uri.parse(ApiConfig.apiUrl);
    final headers = {'Content-Type': 'application/json'};
    final encoded = jsonEncode(body);

    final first = await http.post(uri, headers: headers, body: encoded);
    if (first.statusCode != 429) return first;

    await Future.delayed(_retryDelay);
    return http.post(uri, headers: headers, body: encoded);
  }
}
