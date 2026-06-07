import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';

/// Singleton Dio instance configured with sensible defaults for Test Daily.
/// Used for all HTTP requests (AI API calls).
class DioClient {
  DioClient._();

  static final Dio _instance = _createDio();

  static Dio get instance => _instance;

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: kConnectTimeoutSeconds),
        receiveTimeout: const Duration(seconds: kReceiveTimeoutSeconds),
        // Content-Type is NOT set globally — only POST/PUT requests that send
        // a JSON body should include it (set per-request via Options.contentType).
      ),
    );

    // Add logging interceptor in debug mode
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: false, // Avoid flooding logs with large AI responses
        error: true,
        logPrint: (obj) => debugPrint('[DIO] $obj'),
      ),
    );

    return dio;
  }
}
