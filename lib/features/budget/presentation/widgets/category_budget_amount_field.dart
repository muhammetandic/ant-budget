import 'package:flutter/material.dart';
import 'package:ant_budget/core/config/app_config.dart';
import 'package:ant_budget/core/utils/amount_input_parser.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// Amount field collecting a category's budget limit.
///
/// It only checks that the text parses as money; whether the amount is usable
/// as a budget (positive, in the reporting currency) is decided by
/// `SetCategoryBudgetUseCase`, like every other limit in the app.
class CategoryBudgetAmountField extends StatelessWidget {
  const CategoryBudgetAmountField({
    super.key,
    required this.controller,
    this.enabled = true,
  });

  final TextEditingController controller;

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final currency = AppConfig.reportingCurrency;
    final l10n = context.l10n;
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: l10n.budgetLimitWithSymbol(currency.symbol),
      ),
      validator: (value) =>
          AmountInputParser.tryParse(value ?? '', currency: currency) == null
          ? l10n.validationEnterAmount
          : null,
    );
  }
}
