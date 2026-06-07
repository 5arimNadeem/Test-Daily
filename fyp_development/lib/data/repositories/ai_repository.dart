/// Abstract contract for the AI chat service.
abstract class AiRepository {
  /// Sends a user message with conversation history and returns the AI reply.
  ///
  /// [history] — previous messages as role/content maps (for context)
  /// [userMessage] — the new message text from the user
  Future<String> sendMessage({
    required List<Map<String, String>> history,
    required String userMessage,
  });
}
