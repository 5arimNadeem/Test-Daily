import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/category.dart';
import '../../../providers/category_providers.dart';

/// Horizontal scrolling chip bar for filtering the feed by category.
/// "All" chip resets the filter; category chips set it.
class CategoryChipBar extends ConsumerWidget {
  const CategoryChipBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedCategoryProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // "All" chip
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: const Text('All'),
              selected: selected == null,
              onSelected: (_) {
                ref.read(selectedCategoryProvider.notifier).state = null;
              },
              selectedColor: colorScheme.primaryContainer,
              checkmarkColor: colorScheme.onPrimaryContainer,
            ),
          ),

          // Category chips
          ...kCategories.map((catInfo) {
            final isSelected = selected == catInfo.category;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(catInfo.label),
                avatar: Icon(catInfo.icon, size: 16),
                selected: isSelected,
                onSelected: (_) {
                  ref.read(selectedCategoryProvider.notifier).state =
                      isSelected ? null : catInfo.category;
                },
                selectedColor: colorScheme.primaryContainer,
                checkmarkColor: colorScheme.onPrimaryContainer,
              ),
            );
          }),
        ],
      ),
    );
  }
}
