import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ant_budget/core/config/app_config.dart';
import 'package:ant_budget/core/presentation/failure_message.dart';
import 'package:ant_budget/core/utils/amount_input_parser.dart';
import 'package:ant_budget/core/utils/date_formatter.dart';
import 'package:ant_budget/core/values/transaction_kind.dart';
import 'package:ant_budget/core/widgets/failure_view.dart';
import 'package:ant_budget/features/categories/domain/entities/category.dart';
import 'package:ant_budget/features/categories/presentation/category_label.dart';
import 'package:ant_budget/features/categories/presentation/providers/category_providers.dart';
import 'package:ant_budget/features/transactions/domain/values/add_transaction_command.dart';
import 'package:ant_budget/features/transactions/presentation/providers/transaction_providers.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// Form that collects a manual transaction.
///
/// The screen only collects strings; all validation that matters (positive
/// amount, known category, sane date) happens in `AddTransactionUseCase`.
class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  TransactionKind _kind = TransactionKind.expense;
  int? _categoryId;
  DateTime _date = DateTime.now();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final amount = AmountInputParser.tryParse(
      _amountController.text,
      currency: AppConfig.reportingCurrency,
    );
    final categoryId = _categoryId;
    if (amount == null || categoryId == null) {
      setState(() => _error = context.l10n.errorEnterAmountAndCategory);
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    final result = await ref.read(addTransactionUseCaseProvider)(
      AddTransactionCommand(
        amount: amount,
        categoryId: categoryId,
        occurredAt: _date,
        kind: _kind,
        description: _descriptionController.text,
      ),
    );
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _error = failureMessageOf(context, failure);
        _submitting = false;
      }),
      (_) => Navigator.of(context).pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.addTransactionTitle)),
      body: categories.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => FailureView(error: error),
        data: (items) => _form(context, items),
      ),
    );
  }

  Widget _form(BuildContext context, List<Category> items) {
    final l10n = context.l10n;
    final language = l10n.localeName;
    final currency = AppConfig.reportingCurrency;
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<TransactionKind>(
            segments: [
              ButtonSegment(
                value: TransactionKind.expense,
                label: Text(l10n.transactionKindExpense),
                icon: const Icon(Icons.arrow_downward),
              ),
              ButtonSegment(
                value: TransactionKind.income,
                label: Text(l10n.transactionKindIncome),
                icon: const Icon(Icons.arrow_upward),
              ),
            ],
            selected: {_kind},
            onSelectionChanged: (selection) =>
                setState(() => _kind = selection.first),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: l10n.fieldAmountWithSymbol(currency.symbol),
            ),
            validator: (value) =>
                AmountInputParser.tryParse(value ?? '', currency: currency) ==
                    null
                ? l10n.validationEnterAmount
                : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            initialValue: _categoryId,
            decoration: InputDecoration(labelText: l10n.fieldCategory),
            items: [
              for (final category in items)
                DropdownMenuItem<int>(
                  value: category.id,
                  child: Text(categoryLabel(l10n, category)),
                ),
            ],
            onChanged: (id) => setState(() => _categoryId = id),
            validator: (value) =>
                value == null ? l10n.validationChooseCategory : null,
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.fieldDate),
            subtitle: Text(
              DateFormatter.short(_date, languageCode: language),
            ),
            trailing: const Icon(Icons.calendar_today_outlined),
            onTap: _pickDate,
          ),
          TextFormField(
            controller: _descriptionController,
            maxLength: 160,
            decoration: InputDecoration(
              labelText: l10n.fieldDescriptionOptional,
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          FilledButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.actionSave),
          ),
        ],
      ),
    );
  }
}
