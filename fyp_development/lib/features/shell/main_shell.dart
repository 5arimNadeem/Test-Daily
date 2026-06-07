import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'nav_destinations.dart';

/// Persistent shell widget that wraps all main tab screens.
/// Uses Material 3 NavigationBar with 4 destinations.
class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  int _activeIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    for (int i = 0; i < kNavDestinations.length; i++) {
      if (location.startsWith(kNavDestinations[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final activeIndex = _activeIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: activeIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        onDestinationSelected: (index) {
          context.go(kNavDestinations[index].path);
        },
        destinations: kNavDestinations
            .map(
              (dest) => NavigationDestination(
                icon: Icon(dest.icon),
                selectedIcon: Icon(dest.selectedIcon),
                label: '',
              ),
            )
            .toList(),
      ),
    );
  }
}
