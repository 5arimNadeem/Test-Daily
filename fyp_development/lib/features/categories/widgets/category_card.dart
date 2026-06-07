import 'package:flutter/material.dart';
import '../../../models/category.dart';

/// A grid card for a single testing category.
/// Uses the category's tonal colour for a distinct look.
class CategoryCard extends StatelessWidget {
  final CategoryInfo info;
  final VoidCallback onTap;

  const CategoryCard({super.key, required this.info, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: info.color.withAlpha(20),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: info.color.withAlpha(50),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: info.color.withAlpha(40),
                shape: BoxShape.circle,
              ),
              child: Icon(
                info.icon,
                color: info.color,
                size: 26,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              info.label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: info.color,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
