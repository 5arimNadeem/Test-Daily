import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/errors/app_exception.dart';
import '../models/chat_message.dart';
import 'app_providers.dart';

// ─── AI Chat Notifier ───────────────────────────────────────────────────────

class AiChatNotifier extends Notifier<List<ChatMessage>> {
  @override
  List<ChatMessage> build() => []; // fresh session each app launch

  /// Sends a user message, calls the AI with fallback, appends the response.
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // 1. Add the user message immediately for instant UI feedback
    final userMsg = ChatMessage.fromUser(text.trim());
    state = [...state, userMsg];

    // 2. Signal loading
    ref.read(aiLoadingProvider.notifier).state = true;

    try {
      // Build conversation history for the API (role/content format)
      final history = state
          .where((m) => !m.isError)
          .map((m) => {
                'role': m.isUser ? 'user' : 'assistant',
                'content': m.content,
              })
          .toList();

      // Remove the last user message — AiService appends it itself
      if (history.isNotEmpty && history.last['role'] == 'user') {
        history.removeLast();
      }

      final reply = await ref.read(aiRepositoryProvider).sendMessage(
            history: history,
            userMessage: text.trim(),
          );

      state = [...state, ChatMessage.fromAI(reply)];
    } on AIException catch (e) {
      state = [...state, ChatMessage.error(e.message)];
    } on AppException catch (e) {
      state = [...state, ChatMessage.error(e.message)];
    } catch (_) {
      state = [
        ...state,
        ChatMessage.error(
          'Something went wrong. Please check your connection and try again.',
        ),
      ];
    } finally {
      ref.read(aiLoadingProvider.notifier).state = false;
    }
  }

  /// Clears all messages to start a new chat session.
  void clearChat() => state = [];
}

/// Provider for the AI chat message list.
final chatMessagesProvider =
    NotifierProvider<AiChatNotifier, List<ChatMessage>>(AiChatNotifier.new);

/// true while waiting for an AI response (drives the typing indicator).
final aiLoadingProvider = StateProvider<bool>((ref) => false);
