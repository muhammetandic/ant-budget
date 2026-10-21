import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ant_budget/core/config/app_config.dart';
import 'package:ant_budget/core/presentation/failure_message.dart';
import 'package:ant_budget/core/utils/amount_input_parser.dart';
import 'package:ant_budget/core/utils/money_formatter.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/budget/domain/values/category_budget_summary.dart';
import 'package:ant_budget/features/budget/presentation/providers/budget_providers.dart';
import 'package:ant_budget/features/budget/presentation/widgets/category_budget_actions.dart';
import 'package:ant_budget/features/budget/presentation/widgets/category_budget_amount_field.dart';
import 'package:ant_budget/features/budget/presentation/widgets/category_budget_field.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// Collects a category and an amount and stores them as that category's budget
/// for the selected month.
///
/// The only rule enforced here is "both fields parse"; the business rules
/// (positive, reporting currency) live in `SetCategoryBudgetUseCase`.
class CategoryBudgetForm extends ConsumerStatefulWidget {
  const CategoryBudgetForm({super.key, required this.period, this.initial});

  /// The month the budget belongs to.
  final YearMonth period;

  /// The budget being edited; `null` creates one for the chosen category.
  final CategoryBudgetSummary? initial;

  @override
  ConsumerState<CategoryBudgetForm> createState() => _CategoryBudgetFormState();
}

class _CategoryBudgetFormState extends ConsumerState<CategoryBudgetForm> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  int? _categoryId;
  bool _submitting = false;
  bool _prefilled = false;

  @override
  void initState() {
    super.initState();
    _categoryId = widget.initial?.categoryId;
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The stored limit is written in once the localizations are available;
    // from then on the field only changes on a user action.
    if (_prefilled) return;
    _prefilled = true;
    final limit = widget.initial?.progress.limit;
    if (limit != null) _amount.text = _plain(limit);
  }

  String _plain(Money limit) => MoneyFormatter.format(
    limit,
    withSymbol: false,
    languageCode: context.l10n.localeName,
  );

  /// Picking a category also loads its stored limit, so setting a budget over
  /// one that already exists reads as an edit instead of a silent overwrite.
  void _selectCategory(int? categoryId) {
    final summaries =
        ref.read(categoryBudgetsProvider(widget.period)).value ??
        const <CategoryBudgetSummary>[];
    Money? limit;
    for (final summary in summaries) {
      if (summary.categoryId == categoryId) limit = summary.progress.limit;
    }
    setState(() {
      _categoryId = categoryId;
      _amount.text = limit == null ? '' : _plain(limit);
    });
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final categoryId = _categoryId;
    final amount = AmountInputParser.tryParse(
      _amount.text,
      currency: AppConfig.reportingCurrency,
    );
    if (amount == null || categoryId == null) return; // The validators said no.

    setState(() => _submitting = true);
    final result = await ref.read(setCategoryBudgetUseCaseProvider)(
      period: widget.period,
      categoryId: categoryId,
      limit: amount,
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    result.fold(
      (failure) => _notify(failureMessageOf(context, failure)),
      (_) => Navigator.of(context).pop(),
    );
  }

  void _notify(String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.budgetCategoryAdd,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          CategoryBudgetField(
            value: _categoryId,
            onChanged: _selectCategory,
            enabled: !_submitting,
          ),
          const SizedBox(height: 16),
          CategoryBudgetAmountField(controller: _amount, enabled: !_submitting),
          const SizedBox(height: 8),
          CategoryBudgetActions(
            period: widget.period,
            categoryId: _categoryId,
            submitting: _submitting,
            onSave: _save,
            onDeleted: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
