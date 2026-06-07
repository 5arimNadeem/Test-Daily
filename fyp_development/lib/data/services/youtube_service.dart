import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/feed_sources.dart';
import '../../core/utils/category_inferrer.dart';
import '../../models/feed_item.dart';
import 'secure_storage_service.dart';

/// Fetches the latest videos from all configured [kYoutubeChannels] using
/// the YouTube Data API v3.
///
/// Returns an empty list when no API key is configured.
/// Throws a descriptive exception when the API key is set but all channels fail.
class YoutubeService {
  final Dio _dio;
  final SecureStorageService _secureStorage;

  YoutubeService(this._dio, this._secureStorage);

  /// Fetches latest videos from every configured channel concurrently.
  /// Throws if the key is set but every channel request fails.
  Future<List<FeedItem>> fetchAllChannelVideos() async {
    final apiKey = await _secureStorage.getYoutubeKey();
    debugPrint('[YoutubeService] API key found: ${apiKey != null && apiKey.isNotEmpty}');
    if (apiKey == null || apiKey.isEmpty) return [];

    String? lastError;
    final futures = kYoutubeChannels
        .map((ch) => _fetchChannel(ch, apiKey).catchError((Object e) {
              if (e is DioException) {
                final body = e.response?.data;
                lastError = (body is Map)
                    ? ((body['error'] as Map?)?['message'] as String? ?? e.message ?? e.toString())
                    : (e.message ?? e.toString());
              } else {
                lastError = e.toString();
              }
              debugPrint('[YoutubeService] channel ${ch.channelName} failed: $lastError');
              return <FeedItem>[];
            }));
    final results = await Future.wait(futures, eagerError: false);
    final items = results.expand((list) => list).toList();

    debugPrint('[YoutubeService] total items fetched: ${items.length}, lastError: $lastError');

    if (items.isEmpty) {
      throw Exception(
        lastError != null
            ? 'YouTube API error: $lastError'
            : 'No videos returned. Check the YouTube Data API v3 is enabled and the channel IDs are correct.',
      );
    }
    return items;
  }

  Future<List<FeedItem>> _fetchChannel(
    YoutubeChannelConfig channel,
    String apiKey,
  ) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$kYoutubeBaseUrl$kYoutubeSearchPath',
      queryParameters: {
        'part': 'snippet',
        'channelId': channel.channelId,
        'maxResults': kYoutubeMaxResultsPerChannel,
        'order': 'date',
        'type': 'video',
        'key': apiKey,
      },
      options: Options(
        sendTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
      ),
    );

    final rawItems = (response.data?['items'] as List?) ?? [];
    return rawItems.map((raw) => _toFeedItem(raw, channel)).toList();
  }

  FeedItem _toFeedItem(dynamic raw, YoutubeChannelConfig channel) {
    final id = (raw['id'] as Map<String, dynamic>)['videoId'] as String? ?? '';
    final snippet = raw['snippet'] as Map<String, dynamic>? ?? {};

    final title = snippet['title'] as String? ?? '';
    final rawDesc = snippet['description'] as String? ?? '';
    final description = rawDesc.length > 220
        ? '${rawDesc.substring(0, 220)}…'
        : rawDesc;
    final thumbnailUrl =
        ((snippet['thumbnails'] as Map?)?.entries.lastOrNull?.value
                as Map?)?['url'] as String? ??
            'https://img.youtube.com/vi/$id/hqdefault.jpg';
    final publishedAt = snippet['publishedAt'] as String? ?? '';
    final channelTitle =
        snippet['channelTitle'] as String? ?? channel.channelName;

    final category = inferCategory(title, rawDesc, channel.defaultCategory);

    return FeedItem(
      id: 'yt_$id',
      title: title,
      description: description,
      imageUrl: thumbnailUrl.isNotEmpty ? thumbnailUrl : null,
      source: channelTitle,
      category: category,
      date: DateTime.tryParse(publishedAt) ?? DateTime.now(),
      content: rawDesc,
      externalUrl: 'https://www.youtube.com/watch?v=$id',
      type: 'video',
      videoId: id.isNotEmpty ? id : null,
    );
  }
}
