import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ant_budget/app/router/app_routes.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// Scaffold hosting the bottom navigation of the four top level tabs.
///
/// The visible tab is derived from the current location, so the shell holds no
/// navigation state of its own; go_router remains the single source of truth.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.location, required this.child});

  /// Current router location, used to select the active destination.
  final String location;

  /// The screen of the active tab.
  final Widget child;

  static const List<String> _paths = [
    AppRoutes.dashboard,
    AppRoutes.transactions,
    AppRoutes.budget,
    AppRoutes.categories,
  ];

  int get _selectedIndex => switch (location) {
    AppRoutes.transactions => 1,
    AppRoutes.budget => 2,
    AppRoutes.categories => 3,
    _ => 0,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => context.go(_paths[index]),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: l10n.navOverview,
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: l10n.navTransactions,
          ),
          NavigationDestination(
            icon: const Icon(Icons.savings_outlined),
            selectedIcon: const Icon(Icons.savings),
            label: l10n.navBudget,
          ),
          NavigationDestination(
            icon: const Icon(Icons.category_outlined),
            selectedIcon: const Icon(Icons.category),
            label: l10n.navCategories,
          ),
        ],
      ),
    );
  }
}
