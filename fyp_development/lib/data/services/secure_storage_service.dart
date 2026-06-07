import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants/app_constants.dart';

/// Wraps flutter_secure_storage for reading and writing API keys.
/// Keys are stored in Android Keystore / iOS Keychain.
class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  // ── DeepSeek ──────────────────────────────────────────────────────────────

  Future<String?> getDeepSeekKey() async =>
      _storage.read(key: kDeepSeekKeyStorageKey);

  Future<void> saveDeepSeekKey(String key) async =>
      _storage.write(key: kDeepSeekKeyStorageKey, value: key);

  // ── Groq ──────────────────────────────────────────────────────────────────

  Future<String?> getGroqKey() async =>
      _storage.read(key: kGroqKeyStorageKey);

  Future<void> saveGroqKey(String key) async =>
      _storage.write(key: kGroqKeyStorageKey, value: key);

  // ── YouTube Data API ──────────────────────────────────────────────────────

  Future<String?> getYoutubeKey() async =>
      _storage.read(key: kYoutubeKeyStorageKey);

  Future<void> saveYoutubeKey(String key) async =>
      _storage.write(key: kYoutubeKeyStorageKey, value: key);

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Returns true if at least one AI API key is configured.
  Future<bool> hasAnyKey() async {
    final deepSeek = await getDeepSeekKey();
    final groq = await getGroqKey();
    return (deepSeek != null && deepSeek.isNotEmpty) ||
        (groq != null && groq.isNotEmpty);
  }

  /// Clears all stored keys (useful for testing or sign-out).
  Future<void> clearAll() async => _storage.deleteAll();
}
