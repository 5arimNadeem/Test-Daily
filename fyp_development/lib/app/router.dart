import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/shell/main_shell.dart';
import '../features/splash/splash_screen.dart';
import '../features/home/home_screen.dart';
import '../features/articles/articles_screen.dart';
import '../features/categories/categories_screen.dart';
import '../features/categories/category_detail_screen.dart';
import '../features/bookmarks/bookmarks_screen.dart';
import '../features/ai_assistant/ai_assistant_screen.dart';

/// GoRouter configuration with a ShellRoute for persistent BottomNavigationBar.
///
/// Route tree:
///   /splash              → SplashScreen (initial, no nav bar)
///   /home                → HomeScreen   (YouTube videos)
///   /articles            → ArticlesScreen (RSS articles)
///   /categories          → CategoriesScreen
///   /categories/:category → CategoryDetailScreen
///   /bookmarks           → BookmarksScreen
///   /ai                  → AiAssistantScreen
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/articles',
            name: 'articles',
            builder: (context, state) => const ArticlesScreen(),
          ),
          GoRoute(
            path: '/categories',
            name: 'categories',
            builder: (context, state) => const CategoriesScreen(),
            routes: [
              GoRoute(
                path: ':category',
                name: 'category-detail',
                builder: (context, state) {
                  final categoryName = state.pathParameters['category']!;
                  return CategoryDetailScreen(categoryName: categoryName);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/bookmarks',
            name: 'bookmarks',
            builder: (context, state) => const BookmarksScreen(),
          ),
          GoRoute(
            path: '/ai',
            name: 'ai-assistant',
            builder: (context, state) => const AiAssistantScreen(),
          ),
        ],
      ),
    ],
  );
});
