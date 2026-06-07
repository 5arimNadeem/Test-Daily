import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../models/feed_item.dart';
import '../../../models/category.dart';
import '../../../providers/bookmark_providers.dart';

/// A card widget for a single feed item — article or YouTube video.
///
/// Tapping the card:
///   • YouTube video → opens YouTube app via deep link; falls back to browser.
///   • RSS article  → opens the article URL in the external browser.
class FeedCard extends ConsumerWidget {
  final FeedItem item;

  const FeedCard({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBookmarked = ref.watch(isBookmarkedProvider(item.id));
    final colorScheme = Theme.of(context).colorScheme;
    final catInfo = categoryInfoFromString(item.category);

    return Card(
      clipBehavior: Clip.antiAlias,
      color: colorScheme.surfaceContainerLow,
      child: InkWell(
        onTap: () => _open(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Thumbnail ──────────────────────────────────────────────────
            if (item.imageUrl != null) _Thumbnail(item: item),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Category chip + type badge + bookmark ───────────────
                  Row(
                    children: [
                      if (catInfo != null)
                        _CategoryChip(catInfo: catInfo),
                      const SizedBox(width: 6),
                      _TypeBadge(isVideo: item.isVideo),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => ref
                            .read(bookmarkNotifierProvider.notifier)
                            .toggleBookmark(item),
                        child: Icon(
                          isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_outline,
                          size: 22,
                          color: isBookmarked
                              ? const Color(0xFFFFB300)
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // ── Title ─────────────────────────────────────────────
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  // ── Description ───────────────────────────────────────
                  Text(
                    item.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 10),

                  // ── Source + Date ─────────────────────────────────────
                  Row(
                    children: [
                      Icon(
                        item.isVideo
                            ? Icons.smart_display_outlined
                            : Icons.source_outlined,
                        size: 13,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.source,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        DateFormatter.relative(item.date),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _open(BuildContext context) async {
    if (item.isVideo && item.videoId != null) {
      await _openYouTube(item.videoId!);
    } else if (item.externalUrl != null) {
      await _openUrl(item.externalUrl!);
    }
  }

  Future<void> _openYouTube(String videoId) async {
    final appUri = Uri.parse('youtube://watch?v=$videoId');
    final webUri = Uri.parse('https://www.youtube.com/watch?v=$videoId');

    if (await canLaunchUrl(appUri)) {
      await launchUrl(appUri);
    } else {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────────

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.item});
  final FeedItem item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final catInfo = categoryInfoFromString(item.category);

    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: item.imageUrl!,
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (_, __) => _placeholder(colorScheme, catInfo),
          errorWidget: (_, __, ___) => _placeholder(colorScheme, catInfo),
        ),
        // Play overlay for YouTube videos
        if (item.isVideo)
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_arrow, color: Colors.white, size: 16),
                  SizedBox(width: 3),
                  Text(
                    'YouTube',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _placeholder(ColorScheme cs, CategoryInfo? catInfo) => Container(
        height: 160,
        color: cs.surfaceContainerHigh,
        child: Center(
          child: Icon(
            catInfo?.icon ?? Icons.article_outlined,
            color: cs.onSurfaceVariant,
            size: 32,
          ),
        ),
      );
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.catInfo});
  final CategoryInfo catInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: catInfo.color.withAlpha(30),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        catInfo.label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: catInfo.color,
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.isVideo});
  final bool isVideo;

  @override
  Widget build(BuildContext context) {
    final color = isVideo ? Colors.red : Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(18),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withAlpha(80), width: 0.7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isVideo ? Icons.play_circle_outline : Icons.article_outlined,
            size: 10,
            color: color,
          ),
          const SizedBox(width: 3),
          Text(
            isVideo ? 'YouTube' : 'Blog',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
