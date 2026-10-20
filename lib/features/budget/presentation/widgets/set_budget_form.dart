import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ant_budget/core/config/app_config.dart';
import 'package:ant_budget/core/presentation/failure_message.dart';
import 'package:ant_budget/core/utils/amount_input_parser.dart';
import 'package:ant_budget/features/budget/presentation/providers/budget_providers.dart';
import 'package:ant_budget/features/transactions/presentation/providers/transaction_providers.dart';
import 'package:ant_budget/l10n/l10n.dart';

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
      _notify(context.l10n.errorEnterValidAmount);
      return;
    }

    setState(() => _submitting = true);
    final result = await ref.read(setBudgetLimitUseCaseProvider)(
      period: ref.read(selectedMonthProvider),
      limit: amount,
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    result.fold((failure) => _notify(failureMessageOf(context, failure)), (_) {
      _controller.clear();
      _notify(context.l10n.budgetUpdated);
    });
  }

  void _notify(String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    final currency = AppConfig.reportingCurrency;
    final l10n = context.l10n;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: l10n.budgetLimitWithSymbol(currency.symbol),
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
                : Text(context.l10n.actionSave),
          ),
        ),
      ],
    );
  }
}
