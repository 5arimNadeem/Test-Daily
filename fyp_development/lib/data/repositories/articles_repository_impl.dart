import '../../core/utils/connectivity_service.dart';
import '../../models/feed_item.dart';
import '../mock/mock_feed_data.dart';
import '../services/hive_service.dart';
import '../services/rss_service.dart';
import 'articles_repository.dart';

/// Real implementation of [ArticlesRepository].
///
/// Fetches RSS articles from all configured feed sources and caches them in Hive.
/// YouTube videos are handled separately by [FeedRepositoryImpl].
///
/// Fallback chain: RSS feeds → Hive cache → mock data (dev only)
class ArticlesRepositoryImpl implements ArticlesRepository {
  final RssService _rssService;
  final HiveService _hiveService;
  final ConnectivityService _connectivityService;

  ArticlesRepositoryImpl({
    required RssService rssService,
    required HiveService hiveService,
    required ConnectivityService connectivityService,
  })  : _rssService = rssService,
        _hiveService = hiveService,
        _connectivityService = connectivityService;

  @override
  Future<List<FeedItem>> getArticles() async {
    final isOnline = await _connectivityService.hasConnection();

    if (!isOnline) return _cachedOrMock();

    try {
      final articles = await _rssService.fetchAllFeeds();

      if (articles.isNotEmpty) {
        await _hiveService.cacheArticles(articles);
        return articles;
      }

      return _cachedOrMock();
    } catch (_) {
      return _cachedOrMock();
    }
  }

  List<FeedItem> _cachedOrMock() {
    final cached = _hiveService.getCachedArticles();
    return cached.isNotEmpty ? cached : MockFeedData.items;
  }
}
