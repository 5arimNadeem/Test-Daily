import 'package:flutter/material.dart';

/// The text input bar at the bottom of the AI Assistant screen.
/// Contains a text field and a send button.
class ChatInputBar extends StatefulWidget {
  final bool isLoading;
  final ValueChanged<String> onSend;

  const ChatInputBar({
    super.key,
    required this.isLoading,
    required this.onSend,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.isLoading) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: !widget.isLoading,
              maxLines: 5,
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: widget.isLoading
                    ? 'AI is thinking...'
                    : 'Ask about testing, tools, roadmaps...',
                filled: true,
                fillColor: colorScheme.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              onSubmitted: (_) => _submit(),
            ),
          ),

          const SizedBox(width: 8),

          // ── Send Button ───────────────────────────────────────────────
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: widget.isLoading
                ? SizedBox(
                    width: 44,
                    height: 44,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: colorScheme.primary,
                      ),
                    ),
                  )
                : FilledButton(
                    onPressed: _submit,
                    style: FilledButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                      minimumSize: const Size(44, 44),
                    ),
                    child: const Icon(Icons.send_rounded, size: 20),
                  ),
          ),
        ],
      ),
    );
  }
}
