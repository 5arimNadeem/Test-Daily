import '../../core/utils/connectivity_service.dart';
import '../../models/feed_item.dart';
import '../services/hive_service.dart';
import '../services/youtube_service.dart';
import 'feed_repository.dart';

/// Fetches YouTube videos for the Home feed.
///
/// Fetch strategy (cache-first to protect the free API quota):
///   1. Offline                → return Hive cache
///   2. Cache is fresh (<1 h)  → return Hive cache without hitting the API
///   3. Cache is stale / empty → fetch from YouTube API, cache result
///   4. API fails              → throw so the UI can show an actionable error
///   5. No API key             → return [] so the onboarding screen is shown
class FeedRepositoryImpl implements FeedRepository {
  static const _cacheTtl = Duration(hours: 1);

  final YoutubeService _youtubeService;
  final HiveService _hiveService;
  final ConnectivityService _connectivityService;

  FeedRepositoryImpl({
    required YoutubeService youtubeService,
    required HiveService hiveService,
    required ConnectivityService connectivityService,
  })  : _youtubeService = youtubeService,
        _hiveService = hiveService,
        _connectivityService = connectivityService;

  @override
  Future<List<FeedItem>> getFeed({bool forceRefresh = false}) async {
    final isOnline = await _connectivityService.hasConnection();

    if (!isOnline) return _hiveService.getCachedFeed();

    // Serve from cache when fresh, unless the caller explicitly wants new data.
    if (!forceRefresh && _hiveService.isFeedCacheFresh(_cacheTtl)) {
      return _hiveService.getCachedFeed();
    }

    final videos = await _youtubeService.fetchAllChannelVideos();

    if (videos.isEmpty) {
      // No API key configured — clear stale data and show onboarding.
      await _hiveService.cacheFeed([]);
      return [];
    }

    await _hiveService.cacheFeed(videos);
    return videos;
  }
}
