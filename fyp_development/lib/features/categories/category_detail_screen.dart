import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/category.dart';
import '../../models/feed_item.dart';
import '../../providers/articles_providers.dart';
import '../../providers/feed_providers.dart';
import '../home/widgets/feed_card.dart';

/// Shows all content (YouTube videos + RSS articles) for a specific category.
/// Navigated to from [CategoriesScreen] via /categories/:category.
class CategoryDetailScreen extends ConsumerWidget {
  final String categoryName;

  const CategoryDetailScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catInfo = categoryInfoFromString(categoryName);
    final feedAsync = ref.watch(feedProvider);
    final articlesAsync = ref.watch(articlesProvider);

    final isLoading =
        feedAsync is AsyncLoading || articlesAsync is AsyncLoading;
    final hasBothErrors =
        feedAsync is AsyncError && articlesAsync is AsyncError;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            if (catInfo != null) ...[
              Icon(catInfo.icon, color: catInfo.color, size: 22),
              const SizedBox(width: 8),
            ],
            Text(
              catInfo?.label ?? categoryName,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      body: Builder(builder: (context) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (hasBothErrors) {
          return Center(
            child: Text(
              'Could not load content',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }

        final videos = feedAsync.valueOrNull ?? [];
        final articles = articlesAsync.valueOrNull ?? [];

        final items = <FeedItem>[...videos, ...articles]
            .where((item) => item.category == categoryName)
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));

        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  catInfo?.icon ?? Icons.inbox_outlined,
                  size: 56,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  'No content yet',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Check back soon for ${catInfo?.label ?? categoryName} content.',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) => FeedCard(item: items[index]),
        );
      }),
    );
  }
}
