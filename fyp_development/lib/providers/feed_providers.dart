import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/feed_item.dart';
import 'app_providers.dart';
import 'category_providers.dart';

// ─── Feed Notifier ─────────────────────────────────────────────────────────

/// AsyncNotifier that loads and holds the full feed list.
/// Exposes a [refresh] method for pull-to-refresh.
class FeedNotifier extends AsyncNotifier<List<FeedItem>> {
  @override
  Future<List<FeedItem>> build() async {
    return ref.read(feedRepositoryProvider).getFeed();
  }

  /// Re-fetches the feed, bypassing the cache TTL.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(feedRepositoryProvider).getFeed(forceRefresh: true),
    );
  }
}

/// Provider for the full, unfiltered feed.
final feedProvider = AsyncNotifierProvider<FeedNotifier, List<FeedItem>>(
  FeedNotifier.new,
);

/// Derived provider: feed items filtered by the selected category.
/// Returns all items when no category is selected.
final filteredFeedProvider = Provider<List<FeedItem>>((ref) {
  final feedAsync = ref.watch(feedProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  return feedAsync.maybeWhen(
    data: (items) {
      if (selectedCategory == null) return items;
      return items
          .where((item) => item.category == selectedCategory.name)
          .toList();
    },
    orElse: () => [],
  );
});
