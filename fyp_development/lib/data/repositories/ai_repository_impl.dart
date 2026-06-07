import 'package:flutter/foundation.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/errors/app_exception.dart';
import '../services/ai_service.dart';
import '../services/secure_storage_service.dart';
import 'ai_repository.dart';

/// Implements [AiRepository] with DeepSeek → Groq fallback logic.
///
/// Fallback sequence:
/// 1. Try DeepSeek (if key is configured)
/// 2. If DeepSeek fails → try Groq (if key is configured)
/// 3. If both fail → throw [AIException.bothFailed()]
/// 4. If no keys at all → throw [AIException.noKeys()]
class AiRepositoryImpl implements AiRepository {
  final AiService _aiService;
  final SecureStorageService _storage;

  AiRepositoryImpl(this._aiService, this._storage);

  @override
  Future<String> sendMessage({
    required List<Map<String, String>> history,
    required String userMessage,
  }) async {
    final messages = AiService.buildMessages(history, userMessage);

    final deepSeekKey = await _storage.getDeepSeekKey();
    final groqKey = await _storage.getGroqKey();

    // Track whether any key was configured at all
    bool hasAnyKey = false;

    // ── Step 1: Try DeepSeek ──────────────────────────────────────────────
    if (deepSeekKey != null && deepSeekKey.isNotEmpty) {
      hasAnyKey = true;
      try {
        return await _aiService.sendChatCompletion(
          baseUrl: kDeepSeekBaseUrl,
          path: kDeepSeekChatPath,
          model: kDeepSeekModel,
          apiKey: deepSeekKey,
          messages: messages,
        );
      } on AIException catch (e) {
        debugPrint('[AI] DeepSeek failed (${e.code}): ${e.message}');
      } on NetworkException catch (e) {
        debugPrint('[AI] DeepSeek network error: ${e.message}');
      }
    }

    // ── Step 2: Try Groq ──────────────────────────────────────────────────
    if (groqKey != null && groqKey.isNotEmpty) {
      hasAnyKey = true;
      try {
        return await _aiService.sendChatCompletion(
          baseUrl: kGroqBaseUrl,
          path: kGroqChatPath,
          model: kGroqModel,
          apiKey: groqKey,
          messages: messages,
        );
      } on AIException catch (e) {
        debugPrint('[AI] Groq failed (${e.code}): ${e.message}');
      } on NetworkException catch (e) {
        debugPrint('[AI] Groq network error: ${e.message}');
      }
    }

    // ── Step 3: Handle failure ────────────────────────────────────────────
    if (!hasAnyKey) throw AIException.noKeys();
    throw AIException.bothFailed();
  }
}
