import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_budget_tracker/core/config/app_config.dart';
import 'package:smart_budget_tracker/core/utils/amount_input_parser.dart';
import 'package:smart_budget_tracker/features/budget/presentation/providers/budget_providers.dart';
import 'package:smart_budget_tracker/features/budget/presentation/widgets/budget_progress_card.dart';
import 'package:smart_budget_tracker/features/transactions/presentation/providers/transaction_providers.dart';
import 'package:smart_budget_tracker/features/transactions/presentation/widgets/month_switcher.dart';

/// Budget health of the selected month plus the form that sets its limit.
class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(selectedMonthProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Budget')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(child: MonthSwitcher()),
          const SizedBox(height: 12),
          BudgetProgressCard(period: month),
          const SizedBox(height: 24),
          Text(
            'Set monthly limit',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          const SetBudgetForm(),
        ],
      ),
    );
  }
}

/// Collects an amount and forwards it to `SetBudgetLimitUseCase`.
///
/// The only rule enforced here is "it must parse as money"; the business rules
/// (positive, reporting currency) live in the use case.
class SetBudgetForm extends ConsumerStatefulWidget {
  const SetBudgetForm({super.key});

  @override
  ConsumerState<SetBudgetForm> createState() => _SetBudgetFormState();
}

class _SetBudgetFormState extends ConsumerState<SetBudgetForm> {
  final _controller = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final currency = AppConfig.reportingCurrency;
    final amount = AmountInputParser.tryParse(
      _controller.text,
      currency: currency,
    );
    if (amount == null) {
      _notify('Enter a valid amount.');
      return;
    }

    setState(() => _submitting = true);
    final result = await ref.read(setBudgetLimitUseCaseProvider)(
      period: ref.read(selectedMonthProvider),
      limit: amount,
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    result.fold(
      (failure) => _notify(failure.message),
      (_) {
        _controller.clear();
        _notify('Budget updated.');
      },
    );
  }

  void _notify(String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    final currency = AppConfig.reportingCurrency;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Limit (${currency.symbol})',
            ),
          ),
        ),
        const SizedBox(width: 12),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: FilledButton(
            onPressed: _submitting ? null : _save,
            child: _submitting
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ),
      ],
    );
  }
}
