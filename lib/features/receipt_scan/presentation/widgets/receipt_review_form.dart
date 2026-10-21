import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ant_budget/app/router/app_routes.dart';
import 'package:ant_budget/core/config/app_config.dart';
import 'package:ant_budget/core/presentation/failure_message.dart';
import 'package:ant_budget/core/utils/amount_input_parser.dart';
import 'package:ant_budget/core/utils/date_formatter.dart';
import 'package:ant_budget/core/utils/money_formatter.dart';
import 'package:ant_budget/core/values/transaction_kind.dart';
import 'package:ant_budget/core/values/transaction_source.dart';
import 'package:ant_budget/core/widgets/failure_view.dart';
import 'package:ant_budget/features/categories/domain/entities/category.dart';
import 'package:ant_budget/features/categories/presentation/category_label.dart';
import 'package:ant_budget/features/categories/presentation/providers/category_providers.dart';
import 'package:ant_budget/features/receipt_scan/domain/entities/scanned_receipt.dart';
import 'package:ant_budget/features/receipt_scan/presentation/providers/suggested_category.dart';
import 'package:ant_budget/features/transactions/domain/values/add_transaction_command.dart';
import 'package:ant_budget/features/transactions/presentation/providers/transaction_providers.dart';
import 'package:ant_budget/l10n/l10n.dart';

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
  bool _prefilledAmount = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final receipt = widget.receipt;
    _amount = TextEditingController();
    _merchant = TextEditingController(text: receipt.merchantName ?? '');
    _description = TextEditingController(text: receipt.merchantName ?? '');
    _date = receipt.purchasedAt;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The amount is rendered with the separators of the active language, which
    // is only known once the localizations are available (not in [initState]).
    if (_prefilledAmount) return;
    _prefilledAmount = true;
    _amount.text = MoneyFormatter.formatMinorUnits(
      widget.receipt.total.minorUnits,
      AppConfig.reportingCurrency,
      languageCode: context.l10n.localeName,
    );
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

  Future<void> _save(int? suggestion) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final currency = AppConfig.reportingCurrency;
    final amount = AmountInputParser.tryParse(_amount.text, currency: currency);
    // An untouched dropdown keeps the suggestion that filled it in.
    final categoryId = _categoryId ?? suggestion;
    if (amount == null || categoryId == null) {
      setState(() => _error = context.l10n.errorEnterAmountAndCategory);
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
        _error = failureMessageOf(context, failure);
        _saving = false;
      }),
      (_) => context.go(AppRoutes.dashboard),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    final history = ref.watch(receiptTransactionsProvider);
    // The suggestion becomes the *initial* value of the dropdown, and a form
    // field only reads that once, so both inputs have to be ready before the
    // form is built for the first time.
    if (categories.isLoading || history.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    // A history that failed to load is not worth blocking the review over; the
    // suggestion simply falls back to the shop catalogue.
    if (categories.hasError) return FailureView(error: categories.error!);
    final suggestion = ref.watch(
      suggestedCategoryProvider(widget.receipt.merchantName),
    );
    return _form(context, categories.requireValue, suggestion);
  }

  Widget _form(BuildContext context, List<Category> items, int? suggestion) {
    final l10n = context.l10n;
    final language = l10n.localeName;
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
            decoration: InputDecoration(labelText: l10n.fieldMerchant),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _amount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: l10n.fieldTotalWithSymbol(currency.symbol),
            ),
            validator: (value) =>
                AmountInputParser.tryParse(value ?? '', currency: currency) ==
                    null
                ? l10n.validationEnterAmount
                : null,
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
          DropdownButtonFormField<int>(
            initialValue: _categoryId ?? suggestion,
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
          const SizedBox(height: 16),
          TextFormField(
            controller: _description,
            maxLength: 160,
            decoration: InputDecoration(labelText: l10n.fieldDescriptionOptional),
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
            onPressed: _saving ? null : () => _save(suggestion),
            child: _saving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.actionSaveTransaction),
          ),
        ],
      ),
    );
  }
}
