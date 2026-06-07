import 'package:flutter/material.dart';

/// Defines a single bottom navigation destination.
class NavDestination {
  final IconData icon;
  final IconData selectedIcon;
  final String path;

  const NavDestination({
    required this.icon,
    required this.selectedIcon,
    required this.path,
  });
}

/// The 5 bottom navigation destinations for Test Daily.
///
/// Order: Home (Videos) → Articles (RSS) → Categories → Bookmarks → AI
const List<NavDestination> kNavDestinations = [
  NavDestination(
    icon: Icons.play_circle_outline,
    selectedIcon: Icons.play_circle,
    path: '/home',
  ),
  NavDestination(
    icon: Icons.article_outlined,
    selectedIcon: Icons.article,
    path: '/articles',
  ),
  NavDestination(
    icon: Icons.grid_view_outlined,
    selectedIcon: Icons.grid_view,
    path: '/categories',
  ),
  NavDestination(
    icon: Icons.bookmark_outline,
    selectedIcon: Icons.bookmark,
    path: '/bookmarks',
  ),
  NavDestination(
    icon: Icons.smart_toy_outlined,
    selectedIcon: Icons.smart_toy,
    path: '/ai',
  ),
];
