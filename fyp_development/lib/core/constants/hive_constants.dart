// Hive box names and type adapter IDs

/// Box name for bookmarked feed items (persisted offline)
const String kBookmarkBoxName = 'bookmarks';

/// Box name for chat message history
const String kChatHistoryBoxName = 'chat_history';

/// Box name for cached YouTube videos (Home feed)
const String kFeedCacheBoxName = 'feed_cache';

/// Box name for cached RSS articles (Articles feed)
const String kArticlesCacheBoxName = 'articles_cache';

/// Box name for app metadata (cache timestamps, etc.)
const String kMetaBoxName = 'meta';

/// TypeAdapter IDs — must be unique across the entire app
const int kFeedItemTypeId = 0;
const int kChatMessageTypeId = 1;
