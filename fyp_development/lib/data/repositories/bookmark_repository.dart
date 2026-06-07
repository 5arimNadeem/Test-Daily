import '../../models/feed_item.dart';

/// Abstract contract for the bookmarks data source (Hive-backed).
abstract class BookmarkRepository {
  List<FeedItem> getAll();
  Future<void> save(FeedItem item);
  Future<void> remove(String id);
  bool contains(String id);
}
