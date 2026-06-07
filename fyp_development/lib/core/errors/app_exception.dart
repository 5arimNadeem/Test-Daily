// Sealed exception hierarchy for Test Daily

/// Base exception for all app-level errors.
sealed class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

/// Thrown when a network request fails (timeout, no internet, etc.)
final class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error. Please check your connection.']);
}

/// Thrown when the AI API fails or both providers are exhausted.
final class AIException extends AppException {
  final String code;
  const AIException(this.code, [String message = 'AI service unavailable.'])
      : super(message);

  /// Both DeepSeek and Groq returned errors.
  factory AIException.bothFailed() => const AIException(
        'both_failed',
        'Both AI services are unavailable right now. '
            'Please check your API keys or try again later.',
      );

  /// No API keys have been configured.
  factory AIException.noKeys() => const AIException(
        'no_keys',
        'No API keys configured. '
            'Please add your DeepSeek or Groq API key in the AI Assistant settings.',
      );

  /// Rate limit hit on a specific provider.
  factory AIException.rateLimited(String provider) => AIException(
        'rate_limited',
        '$provider rate limit reached. Trying fallback...',
      );
}

/// Thrown when a Hive storage operation fails.
final class StorageException extends AppException {
  const StorageException([super.message = 'Storage operation failed.']);
}
