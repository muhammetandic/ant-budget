import 'package:flutter/material.dart';
import 'package:ant_budget/core/config/app_config.dart';
import 'package:ant_budget/core/utils/amount_input_parser.dart';
import 'package:ant_budget/core/values/transaction_kind.dart';
import 'package:ant_budget/features/categories/domain/entities/category.dart';
import 'package:ant_budget/features/categories/presentation/category_label.dart';
import 'package:ant_budget/features/transactions/domain/usecases/transaction_rules.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// The text and choice rows of the transaction form: kind, amount, category
/// and description.
///
/// Dumb rendering: the form owns the state (and what a save means); this
/// widget reports changes and checks that the amount parses.
class TransactionFormFields extends StatelessWidget {
  const TransactionFormFields({
    super.key,
    required this.amountController,
    required this.descriptionController,
    required this.kind,
    required this.categoryId,
    required this.categories,
    required this.onKindChanged,
    required this.onCategoryChanged,
  });

  final TextEditingController amountController;
  final TextEditingController descriptionController;
  final TransactionKind kind;
  final int? categoryId;
  final List<Category> categories;
  final ValueChanged<TransactionKind> onKindChanged;
  final ValueChanged<int?> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currency = AppConfig.reportingCurrency;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
          selected: {kind},
          onSelectionChanged: (selection) => onKindChanged(selection.first),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: amountController,
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
          initialValue: categoryId,
          decoration: InputDecoration(labelText: l10n.fieldCategory),
          items: [
            for (final category in categories)
              DropdownMenuItem<int>(
                value: category.id,
                child: Text(categoryLabel(l10n, category)),
              ),
          ],
          onChanged: onCategoryChanged,
          validator: (value) =>
              value == null ? l10n.validationChooseCategory : null,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: descriptionController,
          maxLength: TransactionRules.maxDescriptionLength,
          decoration: InputDecoration(labelText: l10n.fieldDescriptionOptional),
        ),
      ],
    );
  }
}
