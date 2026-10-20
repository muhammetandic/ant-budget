import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ant_budget/core/config/app_config.dart';
import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/core/presentation/failure_message.dart';
import 'package:ant_budget/core/utils/amount_input_parser.dart';
import 'package:ant_budget/core/utils/money_formatter.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/transaction_kind.dart';
import 'package:ant_budget/core/widgets/failure_view.dart';
import 'package:ant_budget/features/categories/domain/entities/category.dart';
import 'package:ant_budget/features/categories/presentation/providers/category_providers.dart';
import 'package:ant_budget/features/transactions/domain/entities/transaction.dart';
import 'package:ant_budget/features/transactions/domain/values/add_transaction_command.dart';
import 'package:ant_budget/features/transactions/presentation/providers/transaction_providers.dart';
import 'package:ant_budget/features/transactions/presentation/widgets/transaction_date_field.dart';
import 'package:ant_budget/features/transactions/presentation/widgets/transaction_form_fields.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// Form that records a transaction, or edits a stored one.
///
/// [initial] is the transaction being edited; without it a new one is created.
/// The screen only collects strings; validation and persistence happen in
/// `AddTransactionUseCase` / `UpdateTransactionUseCase`.
class TransactionFormScreen extends ConsumerStatefulWidget {
  const TransactionFormScreen({super.key, this.initial});

  /// Transaction to edit; `null` records a new one.
  final Transaction? initial;

  @override
  ConsumerState<TransactionFormScreen> createState() =>
      _TransactionFormScreenState();
}

class _TransactionFormScreenState extends ConsumerState<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  TransactionKind _kind = TransactionKind.expense;
  int? _categoryId;
  DateTime _date = DateTime.now();
  bool _submitting = false;
  bool _prefilled = false;
  String? _error;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The stored values are written in once the localizations are available
    // (the amount needs them for its separators); from then on the fields
    // only change on a user action.
    if (_prefilled) return;
    _prefilled = true;
    final initial = widget.initial;
    if (initial == null) return;
    _kind = initial.kind;
    _categoryId = initial.categoryId;
    _date = initial.occurredAt;
    _descriptionController.text = initial.description;
    _amountController.text = MoneyFormatter.format(
      initial.amount,
      withSymbol: false,
      languageCode: context.l10n.localeName,
    );
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

    final result = await _save(amount, categoryId);
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _error = failureMessageOf(context, failure);
        _submitting = false;
      }),
      (_) => Navigator.of(context).pop(),
    );
  }

  /// Creates or replaces the transaction, depending on the opened mode.
  ///
  /// An edit keeps what the form does not collect (provenance of a scanned
  /// receipt), so updating a scanned transaction never loses its origin.
  Future<Result<int, Failure>> _save(Money amount, int categoryId) {
    final description = _descriptionController.text;
    final initial = widget.initial;
    if (initial == null) {
      return ref.read(addTransactionUseCaseProvider)(
        AddTransactionCommand(
          amount: amount,
          categoryId: categoryId,
          occurredAt: _date,
          kind: _kind,
          description: description,
        ),
      );
    }
    return ref.read(updateTransactionUseCaseProvider)(
      Transaction(
        id: initial.id,
        amount: amount,
        categoryId: categoryId,
        occurredAt: _date,
        kind: _kind,
        description: description,
        source: initial.source,
        receiptMerchant: initial.receiptMerchant,
        receiptImagePath: initial.receiptImagePath,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initial == null
              ? l10n.addTransactionTitle
              : l10n.editTransactionTitle,
        ),
      ),
      body: categories.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => FailureView(error: error),
        data: (items) => _form(context, items),
      ),
    );
  }

  Widget _form(BuildContext context, List<Category> items) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TransactionFormFields(
            amountController: _amountController,
            descriptionController: _descriptionController,
            kind: _kind,
            categoryId: _categoryId,
            categories: items,
            onKindChanged: (kind) => setState(() => _kind = kind),
            onCategoryChanged: (id) => setState(() => _categoryId = id),
          ),
          TransactionDateField(
            date: _date,
            onChanged: (date) => setState(() => _date = date),
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
                : Text(context.l10n.actionSave),
          ),
        ],
      ),
    );
  }
}
