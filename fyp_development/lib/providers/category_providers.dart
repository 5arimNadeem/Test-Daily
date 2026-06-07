import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';

/// The currently selected category filter on the Home screen.
/// null = show all categories.
final selectedCategoryProvider = StateProvider<TestingCategory?>(
  (ref) => null,
);
