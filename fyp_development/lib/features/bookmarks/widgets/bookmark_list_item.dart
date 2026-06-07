import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../models/feed_item.dart';
import '../../../models/category.dart';
import '../../../providers/bookmark_providers.dart';

/// A list tile for a bookmarked feed item.
/// Supports swipe-to-dismiss for removal.
class BookmarkListItem extends ConsumerWidget {
  final FeedItem item;

  const BookmarkListItem({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final catInfo = categoryInfoFromString(item.category);

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.delete_outline,
          color: colorScheme.onErrorContainer,
        ),
      ),
      onDismissed: (_) {
        ref.read(bookmarkNotifierProvider.notifier).removeBookmark(item.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Bookmark removed'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                ref
                    .read(bookmarkNotifierProvider.notifier)
                    .toggleBookmark(item);
              },
            ),
          ),
        );
      },
      child: Card(
        color: colorScheme.surfaceContainerLow,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 56,
              height: 56,
              color: catInfo != null
                  ? catInfo.color.withAlpha(30)
                  : colorScheme.surfaceContainerHigh,
              child: Icon(
                catInfo?.icon ?? Icons.article_outlined,
                color: catInfo?.color ?? colorScheme.onSurfaceVariant,
                size: 28,
              ),
            ),
          ),
          title: Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                if (catInfo != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: catInfo.color.withAlpha(25),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      catInfo.label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: catInfo.color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  DateFormatter.relative(item.date),
                  style: TextStyle(
                    fontSize: 11,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          trailing: Icon(
            Icons.bookmark,
            color: const Color(0xFFFFB300),
            size: 20,
          ),
        ),
      ),
    );
  }
}
