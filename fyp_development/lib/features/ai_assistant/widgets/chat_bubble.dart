import 'package:flutter/material.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../models/chat_message.dart';
import 'typing_indicator.dart';

/// A chat bubble widget for both user and AI messages.
///
/// User messages: aligned right, uses primary colour.
/// AI messages: aligned left, uses surface colour.
/// Error messages: aligned left, uses error colour with icon.
class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isTyping; // shows the typing indicator instead of content

  const ChatBubble({
    super.key,
    required this.message,
    this.isTyping = false,
  });

  /// Convenience constructor for the typing indicator placeholder.
  ChatBubble.typing({super.key})
      : message = _FakeChatMessage(),
        isTyping = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isUser = message.isUser;
    final isError = message.isError;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ── AI Avatar ──────────────────────────────────────────────────
          if (!isUser) ...[
            CircleAvatar(
              radius: 14,
              backgroundColor: isError
                  ? colorScheme.errorContainer
                  : colorScheme.primaryContainer,
              child: Icon(
                isError ? Icons.warning_amber_rounded : Icons.smart_toy_outlined,
                size: 16,
                color: isError
                    ? colorScheme.onErrorContainer
                    : colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 6),
          ],

          // ── Bubble ─────────────────────────────────────────────────────
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser
                    ? colorScheme.primary
                    : isError
                        ? colorScheme.errorContainer
                        : colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isUser
                      ? const Radius.circular(16)
                      : const Radius.circular(4),
                  bottomRight: isUser
                      ? const Radius.circular(4)
                      : const Radius.circular(16),
                ),
              ),
              child: isTyping
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: TypingIndicator(),
                    )
                  : Column(
                      crossAxisAlignment: isUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        SelectableText(
                          message.content,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: isUser
                                ? colorScheme.onPrimary
                                : isError
                                    ? colorScheme.onErrorContainer
                                    : colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormatter.relative(message.timestamp),
                          style: TextStyle(
                            fontSize: 10,
                            color: isUser
                                ? colorScheme.onPrimary.withAlpha(160)
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          // ── User Avatar ────────────────────────────────────────────────
          if (isUser) ...[
            const SizedBox(width: 6),
            CircleAvatar(
              radius: 14,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(
                Icons.person_outline,
                size: 16,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Internal dummy message for the typing bubble constructor.
class _FakeChatMessage extends ChatMessage {
  _FakeChatMessage()
      : super(
          id: '',
          content: '',
          isUser: false,
          timestamp: DateTime.now(),
        );
}
