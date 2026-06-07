import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/shared/api_key_dialog.dart';
import '../../providers/app_providers.dart';
import '../../providers/feed_providers.dart';
import '../../providers/theme_providers.dart';
import 'widgets/category_chip_bar.dart';
import 'widgets/feed_list.dart';

/// Home screen — shows the latest YouTube videos from all configured channels.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.play_circle_outline,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Test Daily',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                ),
                Text(
                  'Latest Videos',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Key configuration shortcut
          IconButton(
            icon: const Icon(Icons.key_outlined),
            tooltip: 'Configure API Keys',
            onPressed: () => showApiKeyDialog(
              context,
              ref.read(secureStorageProvider),
              onSaved: () => ref.read(feedProvider.notifier).refresh(),
            ),
          ),
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            tooltip: 'Toggle theme',
            onPressed: () {
              ref.read(themeModeProvider.notifier).state =
                  themeMode == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          const CategoryChipBar(),
          const SizedBox(height: 8),
          Expanded(
            child: FeedList(
              onRefresh: () => ref.read(feedProvider.notifier).refresh(),
              emptyStateWidget: _YouTubeSetupView(
                onConfigure: () => showApiKeyDialog(
                  context,
                  ref.read(secureStorageProvider),
                  onSaved: () => ref.read(feedProvider.notifier).refresh(),
                ),
                onRefresh: () => ref.read(feedProvider.notifier).refresh(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── YouTube setup / onboarding empty state ─────────────────────────────────

class _YouTubeSetupView extends StatelessWidget {
  final VoidCallback onConfigure;
  final Future<void> Function() onRefresh;

  const _YouTubeSetupView({
    required this.onConfigure,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // YouTube play icon
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 44,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Connect YouTube',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            Text(
              'Add a free YouTube Data API v3 key to watch the latest '
              'testing videos from channels like Automation Step by Step, '
              'Naveen AutomationLabs, Rahul Shetty Academy, and LambdaTest.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // How to get a key
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How to get a free key:',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  _Step(
                      n: '1',
                      text: 'Go to console.cloud.google.com'),
                  _Step(n: '2', text: 'Create a project (free)'),
                  _Step(
                      n: '3',
                      text:
                          'Enable "YouTube Data API v3" under APIs & Services'),
                  _Step(
                      n: '4',
                      text: 'Create an API Key under Credentials'),
                  _Step(n: '5', text: 'Paste it below'),
                ],
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onConfigure,
                icon: const Icon(Icons.key_outlined),
                label: const Text('Configure YouTube API Key'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.red,
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String n;
  final String text;
  const _Step({required this.n, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(right: 8, top: 1),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                n,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
