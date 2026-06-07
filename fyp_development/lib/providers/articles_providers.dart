import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/feed_item.dart';
import 'app_providers.dart';
import 'category_providers.dart';

// ─── Articles Notifier ─────────────────────────────────────────────────────

/// AsyncNotifier that loads and holds the RSS articles list.
/// Exposes a [refresh] method for pull-to-refresh.
class ArticlesNotifier extends AsyncNotifier<List<FeedItem>> {
  @override
  Future<List<FeedItem>> build() async {
    return ref.read(articlesRepositoryProvider).getArticles();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(articlesRepositoryProvider).getArticles(),
    );
  }
}

/// Provider for the full, unfiltered articles list.
final articlesProvider = AsyncNotifierProvider<ArticlesNotifier, List<FeedItem>>(
  ArticlesNotifier.new,
);

/// Derived provider: articles filtered by the selected category.
final filteredArticlesProvider = Provider<List<FeedItem>>((ref) {
  final articlesAsync = ref.watch(articlesProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  return articlesAsync.maybeWhen(
    data: (items) {
      if (selectedCategory == null) return items;
      return items
          .where((item) => item.category == selectedCategory.name)
          .toList();
    },
    orElse: () => [],
  );
});
