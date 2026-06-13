// 채팅 화면 — 시나리오 기반 AI와 실시간 대화 진행

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../models/conversation_session.dart';
import '../../models/scenario.dart';
import '../../providers/conversation_provider.dart';
import '../../providers/history_provider.dart';
import '../../router/app_router.dart';
import '../../widgets/chat_bubble.dart';
import '../../widgets/loading_overlay.dart';

class ConversationScreen extends ConsumerStatefulWidget {
  final Scenario scenario;

  const ConversationScreen({super.key, required this.scenario});

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 새 대화 시작 시 이전 세션의 메시지가 남아있지 않도록 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(conversationProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// 메시지 전송 처리
  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    ref.read(conversationLoadingProvider.notifier).state = true;

    try {
      await ref.read(conversationProvider.notifier).sendMessage(
            scenario: widget.scenario,
            userMessage: text,
          );
      // 새 메시지 도착 시 스크롤 맨 아래로
      _scrollToBottom();
    } finally {
      ref.read(conversationLoadingProvider.notifier).state = false;
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// 대화 종료 → 히스토리 저장 후 피드백 화면으로 이동
  void _endConversation() {
    final messages = ref.read(conversationProvider);

    // 대화 기록 저장
    ref.read(historyProvider.notifier).addSession(
          ConversationSession(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            scenario: widget.scenario,
            messages: messages,
            createdAt: DateTime.now(),
          ),
        );

    context.go(AppRoutes.feedback, extra: {
      'messages': messages,
      'scenario': widget.scenario,
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(conversationProvider);
    final isLoading = ref.watch(conversationLoadingProvider);

    return LoadingOverlay(
      isLoading: isLoading,
      message: 'AI가 응답 중...',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('대화 중'),
          actions: [
            TextButton(
              onPressed: _endConversation,
              child: const Text(
                AppStrings.endConversation,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // 시나리오 요약 카드 (상단)
            _ScenarioCard(scenario: widget.scenario),

            // 메시지 목록
            Expanded(
              child: messages.isEmpty
                  ? const Center(
                      child: Text(
                        '첫 메시지를 보내보세요!',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return ChatBubble(
                          message: message.content,
                          isUser: message.isUser,
                        );
                      },
                    ),
            ),

            // 입력창
            _InputBar(
              controller: _textController,
              isLoading: isLoading,
              onSend: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}

/// 시나리오 요약 카드
class _ScenarioCard extends StatelessWidget {
  final Scenario scenario;

  const _ScenarioCard({required this.scenario});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: AppColors.primary.withValues(alpha: 0.1),
      child: Text(
        scenario.background,
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.textSecondary,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

/// 메시지 입력창 + 전송 버튼
class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSend;

  const _InputBar({
    required this.controller,
    required this.isLoading,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.bubbleAI)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: AppStrings.messagePlaceholder,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onSubmitted: (_) => onSend(),
              enabled: !isLoading,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: isLoading ? null : onSend,
            icon: const Icon(Icons.send),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
