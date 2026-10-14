import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ant_budget/app/router/app_routes.dart';

/// Scaffold hosting the bottom navigation of the three top level tabs.
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
  ];

  int get _selectedIndex => switch (location) {
    AppRoutes.transactions => 1,
    AppRoutes.budget => 2,
    _ => 0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => context.go(_paths[index]),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Overview',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Transactions',
          ),
          NavigationDestination(
            icon: Icon(Icons.savings_outlined),
            selectedIcon: Icon(Icons.savings),
            label: 'Budget',
          ),
        ],
      ),
    );
  }
}
