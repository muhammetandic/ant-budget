import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ant_budget/app/router/app_routes.dart';
import 'package:ant_budget/core/widgets/empty_state.dart';
import 'package:ant_budget/core/widgets/failure_view.dart';
import 'package:ant_budget/features/debts/presentation/providers/debt_providers.dart';
import 'package:ant_budget/features/debts/presentation/widgets/debt_form_sheet.dart';
import 'package:ant_budget/features/debts/presentation/widgets/debt_list_tile.dart';
import 'package:ant_budget/features/debts/presentation/widgets/debt_summary_card.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// Screen listing debts and claims, grouped/filtered by type with summaries.
class DebtsScreen extends ConsumerWidget {
  const DebtsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final debtsAsync = ref.watch(debtsListProvider);
    final activeFilter = ref.watch(activeDebtFilterProvider);
    final filtered = ref.watch(filteredDebtsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.debtsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.dashboard);
            }
          },
        ),
      ),
      body: debtsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => FailureView(
          error: err,
          onRetry: () => ref.invalidate(debtsListProvider),
        ),
        data: (allDebts) {
          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: DebtSummaryCard(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: SegmentedButton<DebtFilter>(
                    segments: [
                      ButtonSegment(
                        value: DebtFilter.all,
                        label: Text(l10n.debtsAll),
                      ),
                      ButtonSegment(
                        value: DebtFilter.claims,
                        label: Text(l10n.debtsClaims),
                      ),
                      ButtonSegment(
                        value: DebtFilter.debts,
                        label: Text(l10n.debtsDebts),
                      ),
                    ],
                    selected: {activeFilter},
                    onSelectionChanged: (selected) {
                      ref
                          .read(activeDebtFilterProvider.notifier)
                          .select(selected.first);
                    },
                  ),
                ),
              ),
              if (filtered.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyState(
                    icon: Icons.handshake_outlined,
                    message: l10n.debtsEmpty,
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 96),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final entry = filtered[index];
                      return DebtListTile(
                        key: ValueKey(entry.id ?? index),
                        entry: entry,
                      );
                    }, childCount: filtered.length),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => DebtFormSheet.show(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.actionAdd),
      ),
    );
  }
}
