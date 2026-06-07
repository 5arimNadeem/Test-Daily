import '../../models/feed_item.dart';

/// Abstract contract for the feed data source.
/// Currently backed by mock data; will be replaced with RSS/YouTube API.
abstract class FeedRepository {
  /// Returns the current list of feed items.
  /// [forceRefresh] bypasses the cache TTL and always hits the API.
  Future<List<FeedItem>> getFeed({bool forceRefresh = false});
}
