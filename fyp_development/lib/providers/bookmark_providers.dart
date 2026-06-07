import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/feed_item.dart';
import 'app_providers.dart';

// ─── Bookmark Notifier ──────────────────────────────────────────────────────

class BookmarkNotifier extends Notifier<List<FeedItem>> {
  @override
  List<FeedItem> build() {
    // Load all saved bookmarks from Hive on first access
    return ref.read(bookmarkRepositoryProvider).getAll();
  }

  /// Adds or removes a bookmark (toggle behaviour).
  Future<void> toggleBookmark(FeedItem item) async {
    final repo = ref.read(bookmarkRepositoryProvider);
    if (repo.contains(item.id)) {
      await repo.remove(item.id);
      state = state.where((b) => b.id != item.id).toList();
    } else {
      await repo.save(item);
      state = [item, ...state];
    }
  }

  /// Removes a bookmark by ID (e.g., swipe-to-dismiss).
  Future<void> removeBookmark(String id) async {
    await ref.read(bookmarkRepositoryProvider).remove(id);
    state = state.where((b) => b.id != id).toList();
  }
}

/// Provider for the current list of bookmarked feed items.
final bookmarkNotifierProvider =
    NotifierProvider<BookmarkNotifier, List<FeedItem>>(BookmarkNotifier.new);

/// The current search query text in the Bookmarks screen.
final bookmarkSearchQueryProvider = StateProvider<String>((ref) => '');

/// Derived provider: bookmarks filtered by the search query.
final filteredBookmarksProvider = Provider<List<FeedItem>>((ref) {
  final bookmarks = ref.watch(bookmarkNotifierProvider);
  final query = ref.watch(bookmarkSearchQueryProvider).toLowerCase().trim();

  if (query.isEmpty) return bookmarks;

  return bookmarks.where((item) {
    return item.title.toLowerCase().contains(query) ||
        item.source.toLowerCase().contains(query) ||
        item.category.toLowerCase().contains(query) ||
        item.description.toLowerCase().contains(query);
  }).toList();
});

/// Family provider — fast O(n) lookup for whether a specific item is bookmarked.
/// Used by FeedCard to show the correct bookmark icon state.
final isBookmarkedProvider = Provider.family<bool, String>((ref, id) {
  return ref.watch(bookmarkNotifierProvider).any((b) => b.id == id);
});
