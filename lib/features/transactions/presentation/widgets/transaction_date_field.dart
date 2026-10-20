import 'package:flutter/material.dart';
import 'package:ant_budget/core/utils/date_formatter.dart';
import 'package:ant_budget/features/transactions/domain/usecases/transaction_rules.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// Date row of the transaction form: shows the picked day and opens the
/// calendar.
///
/// Purely presentational; the form owns the value and reacts via [onChanged].
class TransactionDateField extends StatelessWidget {
  const TransactionDateField({
    super.key,
    required this.date,
    required this.onChanged,
  });

  final DateTime date;

  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(l10n.fieldDate),
      subtitle: Text(DateFormatter.short(date, languageCode: l10n.localeName)),
      trailing: const Icon(Icons.calendar_today_outlined),
      onTap: () => _pick(context),
    );
  }

  Future<void> _pick(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: TransactionRules.earliestDate,
      lastDate: DateTime(2100),
    );
    if (picked != null && context.mounted) onChanged(picked);
  }
}
