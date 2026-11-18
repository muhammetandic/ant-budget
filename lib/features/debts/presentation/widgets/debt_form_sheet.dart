import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ant_budget/core/config/app_config.dart';
import 'package:ant_budget/core/presentation/failure_message.dart';
import 'package:ant_budget/core/utils/amount_input_parser.dart';
import 'package:ant_budget/core/utils/date_formatter.dart';
import 'package:ant_budget/core/utils/money_formatter.dart';
import 'package:ant_budget/core/values/debt_type.dart';
import 'package:ant_budget/features/debts/domain/entities/debt_entry.dart';
import 'package:ant_budget/features/debts/presentation/providers/debt_providers.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// Modal bottom sheet for creating or editing a debt/claim.
class DebtFormSheet extends ConsumerStatefulWidget {
  const DebtFormSheet({super.key, this.entry});

  final DebtEntry? entry;

  static Future<void> show(BuildContext context, {DebtEntry? entry}) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => DebtFormSheet(entry: entry),
      );

  @override
  ConsumerState<DebtFormSheet> createState() => _DebtFormSheetState();
}

class _DebtFormSheetState extends ConsumerState<DebtFormSheet> {
  late final TextEditingController _personController;
  late final TextEditingController _amountController;
  late DebtType _type;
  late DateTime _date;
  late bool _isSettled;
  String? _error;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;
    _personController = TextEditingController(text: entry?.person ?? '');
    _amountController = TextEditingController(
      text: entry != null
          ? MoneyFormatter.formatMinorUnits(
              entry.amount.minorUnits,
              entry.amount.currency,
            )
          : '',
    );
    _type = entry?.type ?? DebtType.claim;
    _date = entry?.dueDate ?? DateTime.now();
    _isSettled = entry?.isSettled ?? false;
  }

  @override
  void dispose() {
    _personController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      setState(() => _date = picked);
    }
  }

  Future<void> _save() async {
    final person = _personController.text.trim();
    final amount = AmountInputParser.tryParse(
      _amountController.text,
      currency: AppConfig.reportingCurrency,
    );

    if (person.isEmpty) {
      setState(() => _error = context.l10n.errorPersonEmpty);
      return;
    }
    if (amount == null || !amount.isPositive) {
      setState(() => _error = context.l10n.errorAmountNotPositive);
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    final entry = DebtEntry(
      id: widget.entry?.id,
      person: person,
      amount: amount,
      type: _type,
      dueDate: _date,
      isSettled: _isSettled,
      createdAt: widget.entry?.createdAt,
    );

    final result = await ref.read(saveDebtUseCaseProvider)(entry);
    if (!mounted) return;

    result.fold((failure) {
      setState(() {
        _saving = false;
        _error = failureMessageOf(context, failure);
      });
    }, (id) => Navigator.of(context).pop());
  }

  Future<void> _delete() async {
    final id = widget.entry?.id;
    if (id == null) return;

    final result = await ref.read(deleteDebtUseCaseProvider)(id);
    if (!mounted) return;

    result.fold((failure) {
      setState(() {
        _error = failureMessageOf(context, failure);
      });
    }, (_) => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isEditing = widget.entry != null;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  isEditing ? l10n.debtsEditTitle : l10n.debtsAddTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (isEditing)
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: l10n.actionDelete,
                    onPressed: _saving ? null : _delete,
                  ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SegmentedButton<DebtType>(
              segments: [
                ButtonSegment(
                  value: DebtType.claim,
                  label: Text(l10n.debtTypeClaim),
                  icon: const Icon(Icons.call_received),
                ),
                ButtonSegment(
                  value: DebtType.debt,
                  label: Text(l10n.debtTypeDebt),
                  icon: const Icon(Icons.call_made),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (selected) {
                setState(() => _type = selected.first);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _personController,
              decoration: InputDecoration(
                labelText: l10n.fieldPerson,
                prefixIcon: const Icon(Icons.person_outline),
                border: const OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: l10n.fieldAmountWithSymbol(
                  AppConfig.reportingCurrency.symbol,
                ),
                prefixIcon: const Icon(Icons.attach_money),
                border: const OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today_outlined),
              title: Text(l10n.fieldDate),
              subtitle: Text(
                DateFormatter.short(_date, languageCode: l10n.localeName),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickDate,
            ),
            if (isEditing) ...[
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.debtSettled),
                value: _isSettled,
                onChanged: (val) => setState(() => _isSettled = val),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.actionSave),
            ),
          ],
        ),
      ),
    );
  }
}
