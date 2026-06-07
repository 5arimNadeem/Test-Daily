import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/bookmark_providers.dart';
import 'widgets/bookmark_list_item.dart';

/// Bookmarks screen — shows all saved items with search support.
/// All data is loaded from Hive (works fully offline).
class BookmarksScreen extends ConsumerStatefulWidget {
  const BookmarksScreen({super.key});

  @override
  ConsumerState<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends ConsumerState<BookmarksScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = ref.watch(filteredBookmarksProvider);
    final allBookmarks = ref.watch(bookmarkNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bookmarks',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          if (allBookmarks.isNotEmpty)
            TextButton.icon(
              onPressed: () => _confirmClearAll(context, ref),
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Clear all'),
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.error,
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // ── Search Bar ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search bookmarks...',
              leading: const Icon(Icons.search),
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      ref.read(bookmarkSearchQueryProvider.notifier).state = '';
                    },
                  ),
              ],
              onChanged: (value) {
                ref.read(bookmarkSearchQueryProvider.notifier).state = value;
              },
            ),
          ),

          const SizedBox(height: 8),

          // ── Bookmark Count ───────────────────────────────────────────────
          if (allBookmarks.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Text(
                    '${filteredItems.length} '
                    '${filteredItems.length == 1 ? 'item' : 'items'}',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.offline_bolt_outlined,
                    size: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Available offline',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),

          // ── List or Empty State ──────────────────────────────────────────
          Expanded(
            child: allBookmarks.isEmpty
                ? _EmptyBookmarksView()
                : filteredItems.isEmpty
                    ? _NoResultsView(query: _searchController.text)
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: filteredItems.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) =>
                            BookmarkListItem(item: filteredItems[index]),
                      ),
          ),
        ],
      ),
    );
  }

  void _confirmClearAll(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear all bookmarks?'),
        content: const Text('This will remove all your saved articles. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              final all = ref.read(bookmarkNotifierProvider);
              for (final item in all) {
                ref.read(bookmarkNotifierProvider.notifier).removeBookmark(item.id);
              }
            },
            child: const Text('Clear all'),
          ),
        ],
      ),
    );
  }
}

class _EmptyBookmarksView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bookmark_outline,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No bookmarks yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the bookmark icon on any article\nto save it for offline reading.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _NoResultsView extends StatelessWidget {
  final String query;
  const _NoResultsView({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_outlined,
            size: 56,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No results for "$query"',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
