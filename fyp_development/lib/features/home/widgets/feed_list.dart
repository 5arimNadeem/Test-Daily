import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/feed_providers.dart';
import 'feed_card.dart';

/// Scrollable list of [FeedCard] widgets with loading / error / empty states.
///
/// Pass [emptyStateWidget] to override the default empty-state view — useful
/// when the caller needs context-specific messaging (e.g. "Set up YouTube").
class FeedList extends ConsumerWidget {
  final Future<void> Function() onRefresh;

  /// Shown when the filtered feed is empty. Defaults to a generic message.
  final Widget? emptyStateWidget;

  const FeedList({
    super.key,
    required this.onRefresh,
    this.emptyStateWidget,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(feedProvider);
    final filteredItems = ref.watch(filteredFeedProvider);

    return feedAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => _ErrorView(
        message: err.toString(),
        onRetry: () => ref.read(feedProvider.notifier).refresh(),
      ),
      data: (_) {
        if (filteredItems.isEmpty) {
          return emptyStateWidget ?? const _EmptyView();
        }
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: filteredItems.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                FeedCard(item: filteredItems[index]),
          ),
        );
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  String _friendlyMessage(String raw) {
    // Strip HTML tags from YouTube error messages (e.g. <a href=...>quota</a>)
    final clean = raw.replaceAll(RegExp(r'<[^>]*>'), '');
    if (clean.contains('quota') || clean.contains('exceeded')) {
      return 'YouTube API daily quota exceeded.\n\nWait 24 hours for it to reset (midnight US Pacific), '
          'or go to console.cloud.google.com and create a new project + API key.';
    }
    if (clean.contains('accessnotconfigured') || clean.contains('has not been used') || clean.contains('disabled')) {
      return 'YouTube Data API v3 is not enabled for this key\'s project.\n\n'
          'Go to: console.cloud.google.com → APIs & Services → Library → search "YouTube Data API v3" → Enable';
    }
    if (clean.contains('api key not valid') || clean.contains('invalid')) {
      return 'The API key is invalid. Copy it again from Google Cloud Console → Credentials.';
    }
    if (clean.contains('403') || clean.contains('forbidden') || clean.contains('caller does not have permission')) {
      return 'Access denied (403). In Google Cloud Console → Credentials → click your key:\n'
          '• "API restrictions" → must be "Don\'t restrict" or include YouTube Data API v3\n'
          '• "Application restrictions" → set to "None"';
    }
    if (clean.contains('400') || clean.contains('bad request')) {
      return 'Bad request (400). The API key format may be invalid.';
    }
    if (clean.contains('socketexception') || clean.contains('network')) {
      return 'No internet connection. Check your network and retry.';
    }
    return clean;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_outlined,
                size: 56,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text('Could not load videos',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(_friendlyMessage(message.toLowerCase()),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.video_library_outlined,
              size: 56,
              color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(height: 16),
          Text('No videos in this category',
              style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
