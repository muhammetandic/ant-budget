import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ant_budget/app/router/app_routes.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// Scaffold hosting the bottom navigation of the four top level tabs plus a
/// "More" drawer for secondary screens.
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.location, required this.child});

  /// Current router location, used to select the active destination.
  final String location;

  /// The screen of the active tab.
  final Widget child;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const List<String> _paths = [
    AppRoutes.dashboard,
    AppRoutes.transactions,
    AppRoutes.budget,
    AppRoutes.reports,
    AppRoutes.more,
  ];

  int get _selectedIndex => switch (widget.location) {
    AppRoutes.transactions => 1,
    AppRoutes.budget => 2,
    AppRoutes.reports => 3,
    AppRoutes.more => 4,
    AppRoutes.categories => 4,
    AppRoutes.debts => 4,
    AppRoutes.settings => 4,
    _ => 0,
  };

  void _onDestinationSelected(int index) {
    final path = _paths[index];
    if (path == AppRoutes.more) {
      // Open the end drawer instead of navigating
      _scaffoldKey.currentState?.openEndDrawer();
    } else {
      context.go(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      key: _scaffoldKey,
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
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
            icon: const Icon(Icons.pie_chart_outline),
            selectedIcon: const Icon(Icons.pie_chart),
            label: l10n.navReports,
          ),
          NavigationDestination(
            icon: const Icon(Icons.more_horiz_outlined),
            selectedIcon: const Icon(Icons.more_horiz),
            label: l10n.navMore,
          ),
        ],
      ),
      endDrawer: _MoreDrawer(currentLocation: widget.location),
    );
  }
}

/// Drawer shown when "More" tab is selected.
class _MoreDrawer extends StatelessWidget {
  const _MoreDrawer({required this.currentLocation});

  final String currentLocation;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    l10n.navMore,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Scaffold.of(context).closeEndDrawer(),
                  ),
                ],
              ),
            ),
            const Divider(),
            _MoreDrawerTile(
              icon: Icons.category_outlined,
              label: l10n.navCategories,
              selected: currentLocation == AppRoutes.categories,
              onTap: () {
                Scaffold.of(context).closeEndDrawer();
                context.push(AppRoutes.categories);
              },
            ),
            _MoreDrawerTile(
              icon: Icons.account_balance_wallet_outlined,
              label: l10n.navDebts,
              selected: currentLocation == AppRoutes.debts,
              onTap: () {
                Scaffold.of(context).closeEndDrawer();
                context.push(AppRoutes.debts);
              },
            ),
            _MoreDrawerTile(
              icon: Icons.settings_outlined,
              label: l10n.navSettings,
              selected: currentLocation == AppRoutes.settings,
              onTap: () {
                Scaffold.of(context).closeEndDrawer();
                context.push(AppRoutes.settings);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MoreDrawerTile extends StatelessWidget {
  const _MoreDrawerTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: selected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          color: selected ? Theme.of(context).colorScheme.primary : null,
        ),
      ),
      selected: selected,
      selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
      onTap: onTap,
    );
  }
}