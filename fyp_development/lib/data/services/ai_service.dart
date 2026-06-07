import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/app_exception.dart';

/// Low-level HTTP service for making chat completion requests to AI APIs.
/// Used by [AiRepositoryImpl] which adds fallback orchestration on top.
class AiService {
  final Dio _dio;

  AiService(this._dio);

  /// Sends a chat completion request to the specified endpoint.
  ///
  /// [baseUrl] — the provider's base URL
  /// [path] — the chat completions path
  /// [model] — the model identifier
  /// [apiKey] — the Bearer token
  /// [messages] — full conversation history including system prompt
  ///
  /// Returns the assistant's reply text.
  /// Throws [AIException] or [NetworkException] on failure.
  Future<String> sendChatCompletion({
    required String baseUrl,
    required String path,
    required String model,
    required String apiKey,
    required List<Map<String, String>> messages,
  }) async {
    try {
      final response = await _dio.post(
        '$baseUrl$path',
        data: {
          'model': model,
          'messages': messages,
          'temperature': kAiTemperature,
          'max_tokens': kAiMaxTokens,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ),
      );

      final data = response.data as Map<String, dynamic>;

      // Some providers return HTTP 200 with an error body
      if (data.containsKey('error')) {
        throw AIException('provider_error', data['error']['message'] as String);
      }

      final choices = data['choices'] as List<dynamic>;
      if (choices.isEmpty) throw const AIException('empty_response');

      final content = choices[0]['message']['content'] as String;
      return content.trim();
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        throw AIException.rateLimited(baseUrl);
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw const NetworkException();
      }
      throw AIException('dio_error', e.message ?? 'Request failed');
    }
  }

  /// Builds the messages array for the API request from conversation history.
  static List<Map<String, String>> buildMessages(
    List<Map<String, String>> history,
    String userMessage,
  ) {
    // Always inject the system prompt as the first message
    final messages = <Map<String, String>>[
      {'role': 'system', 'content': kAiSystemPrompt},
    ];

    // Include only the last N exchanges to stay within token limits
    final recentHistory = history.length > kMaxChatHistoryForApi
        ? history.sublist(history.length - kMaxChatHistoryForApi)
        : history;

    messages.addAll(recentHistory);
    messages.add({'role': 'user', 'content': userMessage});

    return messages;
  }
}
