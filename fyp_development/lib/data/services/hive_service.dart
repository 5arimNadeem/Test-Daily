import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/hive_constants.dart';
import '../../models/feed_item.dart';
import '../../models/chat_message.dart';

const _kFeedCachedAtKey = 'feed_cached_at';

/// Centralized access layer for all Hive boxes.
/// Boxes must be opened before this service is used (done in main.dart).
class HiveService {
  Box<FeedItem> get _bookmarkBox => Hive.box<FeedItem>(kBookmarkBoxName);
  Box<ChatMessage> get _chatBox => Hive.box<ChatMessage>(kChatHistoryBoxName);
  Box<FeedItem> get _feedCacheBox => Hive.box<FeedItem>(kFeedCacheBoxName);
  Box<FeedItem> get _articlesCacheBox => Hive.box<FeedItem>(kArticlesCacheBoxName);
  Box<dynamic> get _metaBox => Hive.box<dynamic>(kMetaBoxName);

  // ─── Bookmarks ────────────────────────────────────────────────────────────

  List<FeedItem> getAllBookmarks() {
    final items = _bookmarkBox.values.toList();
    items.sort((a, b) => b.date.compareTo(a.date));
    return items;
  }

  Future<void> saveBookmark(FeedItem item) async =>
      _bookmarkBox.put(item.id, item);

  Future<void> deleteBookmark(String id) async => _bookmarkBox.delete(id);

  bool isBookmarked(String id) => _bookmarkBox.containsKey(id);

  // ─── Chat History ─────────────────────────────────────────────────────────

  List<ChatMessage> getAllChatMessages() {
    final messages = _chatBox.values.toList();
    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return messages;
  }

  Future<void> saveChatMessage(ChatMessage message) async =>
      _chatBox.put(message.id, message);

  Future<void> clearChatHistory() async => _chatBox.clear();

  // ─── Feed Cache ───────────────────────────────────────────────────────────

  /// Returns all cached feed items sorted newest-first.
  List<FeedItem> getCachedFeed() {
    final items = _feedCacheBox.values.toList();
    items.sort((a, b) => b.date.compareTo(a.date));
    return items;
  }

  /// Replaces the entire feed cache with [items] and records the timestamp.
  Future<void> cacheFeed(List<FeedItem> items) async {
    await _feedCacheBox.clear();
    await _feedCacheBox.putAll({for (final item in items) item.id: item});
    await _metaBox.put(_kFeedCachedAtKey, DateTime.now().toIso8601String());
  }

  /// True when at least one video has been cached previously.
  bool get hasCachedFeed => _feedCacheBox.isNotEmpty;

  /// True when the feed cache was populated within [ttl].
  bool isFeedCacheFresh(Duration ttl) {
    final raw = _metaBox.get(_kFeedCachedAtKey) as String?;
    if (raw == null || !hasCachedFeed) return false;
    final cachedAt = DateTime.tryParse(raw);
    if (cachedAt == null) return false;
    return DateTime.now().difference(cachedAt) < ttl;
  }

  // ─── Articles Cache (RSS) ─────────────────────────────────────────────────

  /// Returns all cached RSS articles sorted newest-first.
  List<FeedItem> getCachedArticles() {
    final items = _articlesCacheBox.values.toList();
    items.sort((a, b) => b.date.compareTo(a.date));
    return items;
  }

  /// Replaces the entire articles cache with [items].
  Future<void> cacheArticles(List<FeedItem> items) async {
    await _articlesCacheBox.clear();
    await _articlesCacheBox.putAll({for (final item in items) item.id: item});
  }

  /// True when at least one article has been cached previously.
  bool get hasCachedArticles => _articlesCacheBox.isNotEmpty;
}
