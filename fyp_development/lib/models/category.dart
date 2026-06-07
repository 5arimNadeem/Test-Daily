import 'package:flutter/material.dart';

/// All supported testing categories in Test Daily.
enum TestingCategory {
  automation,
  apiTesting,
  performance,
  security,
  mobileTesting,
  interviewPrep,
  aiTesting,
  accessibility,
}

/// Display metadata for each category (label, icon, color).
class CategoryInfo {
  final TestingCategory category;
  final String label;
  final IconData icon;
  final Color color;

  const CategoryInfo({
    required this.category,
    required this.label,
    required this.icon,
    required this.color,
  });

  /// Matches the string stored in FeedItem.category to a TestingCategory.
  static TestingCategory? fromString(String value) {
    for (final cat in TestingCategory.values) {
      if (cat.name == value) return cat;
    }
    return null;
  }
}

/// Static list of all category display metadata.
const List<CategoryInfo> kCategories = [
  CategoryInfo(
    category: TestingCategory.automation,
    label: 'Automation',
    icon: Icons.precision_manufacturing_outlined,
    color: Color(0xFF1565C0), // deep blue
  ),
  CategoryInfo(
    category: TestingCategory.apiTesting,
    label: 'API Testing',
    icon: Icons.api_outlined,
    color: Color(0xFF00695C), // teal
  ),
  CategoryInfo(
    category: TestingCategory.performance,
    label: 'Performance',
    icon: Icons.speed_outlined,
    color: Color(0xFFE65100), // deep orange
  ),
  CategoryInfo(
    category: TestingCategory.security,
    label: 'Security',
    icon: Icons.security_outlined,
    color: Color(0xFF6A1B9A), // purple
  ),
  CategoryInfo(
    category: TestingCategory.mobileTesting,
    label: 'Mobile Testing',
    icon: Icons.phone_android_outlined,
    color: Color(0xFF2E7D32), // green
  ),
  CategoryInfo(
    category: TestingCategory.interviewPrep,
    label: 'Interview Prep',
    icon: Icons.work_outline,
    color: Color(0xFFC62828), // red
  ),
  CategoryInfo(
    category: TestingCategory.aiTesting,
    label: 'AI Testing',
    icon: Icons.psychology_outlined,
    color: Color(0xFF0277BD), // light blue
  ),
  CategoryInfo(
    category: TestingCategory.accessibility,
    label: 'Accessibility',
    icon: Icons.accessibility_new_outlined,
    color: Color(0xFF558B2F), // light green
  ),
];

/// Helper to get a [CategoryInfo] by [TestingCategory].
CategoryInfo categoryInfoFor(TestingCategory cat) =>
    kCategories.firstWhere((c) => c.category == cat);

/// Helper to get a [CategoryInfo] by string name.
CategoryInfo? categoryInfoFromString(String name) {
  try {
    return kCategories.firstWhere((c) => c.category.name == name);
  } catch (_) {
    return null;
  }
}
