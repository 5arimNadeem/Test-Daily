import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/category.dart';
import 'widgets/category_card.dart';

/// Displays all 8 testing categories in a 2-column grid.
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Browse by topic',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemCount: kCategories.length,
                itemBuilder: (context, index) {
                  final info = kCategories[index];
                  return CategoryCard(
                    info: info,
                    onTap: () {
                      context.go('/categories/${info.category.name}');
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
