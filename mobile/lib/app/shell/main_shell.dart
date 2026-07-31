import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/app_providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Bottom-navigation shell hosting the four main tabs, with a live
/// connectivity banner so offline state is visible everywhere.
class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final online =
        ref.watch(connectivityStatusProvider).value ?? true;

    return Scaffold(
      body: Column(
        children: [
          AnimatedSwitcher(
            duration: AppDurations.normal,
            child: online
                ? const SizedBox.shrink()
                : Container(
                    key: const ValueKey('offline-banner'),
                    width: double.infinity,
                    color: AppColors.danger,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 4,
                      bottom: 6,
                    ),
                    // Nothing is cached locally yet, so this must not promise
                    // that stale data is being shown.
                    child: const Text(
                      'You are offline — some data may be unavailable',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
          ),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_rounded),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_rounded),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
