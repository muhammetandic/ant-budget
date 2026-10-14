import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ant_budget/app/router/app_routes.dart';
import 'package:ant_budget/core/config/app_config.dart';
import 'package:ant_budget/core/utils/amount_input_parser.dart';
import 'package:ant_budget/core/utils/date_formatter.dart';
import 'package:ant_budget/core/utils/money_formatter.dart';
import 'package:ant_budget/core/values/transaction_kind.dart';
import 'package:ant_budget/core/values/transaction_source.dart';
import 'package:ant_budget/core/widgets/failure_view.dart';
import 'package:ant_budget/features/categories/domain/entities/category.dart';
import 'package:ant_budget/features/categories/presentation/providers/category_providers.dart';
import 'package:ant_budget/features/receipt_scan/domain/entities/scanned_receipt.dart';
import 'package:ant_budget/features/transactions/domain/values/add_transaction_command.dart';
import 'package:ant_budget/features/transactions/presentation/providers/transaction_providers.dart';

/// Lets the user correct the parsed values and persists the receipt as a
/// transaction.
///
/// The parsed receipt is only a *proposal*: every field is editable, and saving
/// goes through the same `AddTransactionUseCase` (with
/// [TransactionSource.receiptScan]) as a hand typed entry.
class ReceiptReviewForm extends ConsumerStatefulWidget {
  const ReceiptReviewForm({
    super.key,
    required this.receipt,
    required this.imagePath,
  });

  final ScannedReceipt receipt;
  final String imagePath;

  @override
  ConsumerState<ReceiptReviewForm> createState() => _ReceiptReviewFormState();
}

class _ReceiptReviewFormState extends ConsumerState<ReceiptReviewForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amount;
  late final TextEditingController _merchant;
  late final TextEditingController _description;

  late DateTime _date;
  int? _categoryId;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final currency = AppConfig.reportingCurrency;
    final receipt = widget.receipt;
    _amount = TextEditingController(
      text: MoneyFormatter.formatMinorUnits(receipt.total.minorUnits, currency),
    );
    _merchant = TextEditingController(text: receipt.merchantName ?? '');
    _description = TextEditingController(text: receipt.displayName);
    _date = receipt.purchasedAt;
  }

  @override
  void dispose() {
    _amount.dispose();
    _merchant.dispose();
    _description.dispose();
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

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final currency = AppConfig.reportingCurrency;
    final amount = AmountInputParser.tryParse(_amount.text, currency: currency);
    final categoryId = _categoryId;
    if (amount == null || categoryId == null) {
      setState(() => _error = 'Enter an amount and choose a category.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });
    final merchant = _merchant.text.trim();
    final result = await ref.read(addTransactionUseCaseProvider)(
      AddTransactionCommand(
        amount: amount,
        categoryId: categoryId,
        occurredAt: _date,
        kind: TransactionKind.expense,
        description: _description.text,
        source: TransactionSource.receiptScan,
        receiptMerchant: merchant.isEmpty ? null : merchant,
        receiptImagePath: widget.imagePath,
      ),
    );
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _error = failure.message;
        _saving = false;
      }),
      (_) => context.go(AppRoutes.dashboard),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    return categories.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => FailureView(error: error),
      data: (items) => _form(context, items),
    );
  }

  Widget _form(BuildContext context, List<Category> items) {
    final currency = AppConfig.reportingCurrency;
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(widget.imagePath),
              height: 160,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _merchant,
            decoration: const InputDecoration(labelText: 'Merchant'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _amount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Total (${currency.symbol})',
            ),
            validator: (value) =>
                AmountInputParser.tryParse(value ?? '', currency: currency) ==
                    null
                ? 'Enter a valid amount'
                : null,
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Date'),
            subtitle: Text(DateFormatter.short(_date)),
            trailing: const Icon(Icons.calendar_today_outlined),
            onTap: _pickDate,
          ),
          DropdownButtonFormField<int>(
            initialValue: _categoryId,
            decoration: const InputDecoration(labelText: 'Category'),
            items: [
              for (final category in items)
                DropdownMenuItem<int>(
                  value: category.id,
                  child: Text(category.name),
                ),
            ],
            onChanged: (id) => setState(() => _categoryId = id),
            validator: (value) => value == null ? 'Choose a category' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _description,
            maxLength: 160,
            decoration: const InputDecoration(labelText: 'Description'),
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
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save transaction'),
          ),
        ],
      ),
    );
  }
}
