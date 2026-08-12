import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../domain/entities/chat_message.dart';
import 'chat_bubble.dart';
import 'chat_date_chip.dart';
import 'typing_bubble.dart';

/// Scrollable chat history: a loading spinner while history is fetched,
/// otherwise a date chip followed by message bubbles and a trailing
/// typing indicator while a reply is in flight.
class ChatMessageList extends StatelessWidget {
  const ChatMessageList({
    super.key,
    required this.messages,
    required this.isLoading,
    required this.isAiTyping,
    required this.scrollController,
    required this.onRegenerate,
  });

  final List<ChatMessage> messages;
  final bool isLoading;
  final bool isAiTyping;
  final ScrollController scrollController;
  final VoidCallback onRegenerate;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: AppLoading());
    }

    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final int messageCount = messages.length;
    final int itemCount = messageCount + 1 + (isAiTyping ? 1 : 0); // +1 for date chip

    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.symmetric(
        horizontal: responsive.spacing(AppSpacing.lg),
        vertical: responsive.spacing(AppSpacing.sm),
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index == 0) return const ChatDateChip();

        final int msgIdx = index - 1;
        if (msgIdx >= messageCount) return const TypingBubble();

        return ChatBubble(
          message: messages[msgIdx],
          onRegenerate: onRegenerate,
        );
      },
    );
  }
}
