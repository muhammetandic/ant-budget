import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ant_budget/core/presentation/failure_message.dart';
import 'package:ant_budget/core/values/category_icon.dart';
import 'package:ant_budget/features/categories/domain/entities/category.dart';
import 'package:ant_budget/features/categories/domain/usecases/save_category_usecase.dart';
import 'package:ant_budget/features/categories/presentation/category_label.dart';
import 'package:ant_budget/features/categories/presentation/providers/category_providers.dart';
import 'package:ant_budget/features/categories/presentation/widgets/category_style_fields.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// The category form: name, icon and colour, saved through a use case.
///
/// Only "did the form produce a value" is decided here; whether the name is
/// usable is decided by `SaveCategoryUseCase`, whose failure is rendered below.
class CategoryForm extends ConsumerStatefulWidget {
  const CategoryForm({super.key, this.category});

  /// Category being edited; `null` creates a new one.
  final Category? category;

  @override
  ConsumerState<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends ConsumerState<CategoryForm> {
  late final TextEditingController _name;
  late CategoryIcon _icon;
  late int _color;
  bool _prefilled = false;
  String? _error;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final category = widget.category;
    _name = TextEditingController();
    _icon = category?.icon ?? CategoryIconField.initialIcon;
    _color = category?.colorValue ?? CategoryColorField.initialColor;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ships-with-the-app categories start from their translated label; `_save`
    // keeps the stored English name unless the user actually edits it.
    if (!_prefilled && widget.category != null) {
      _name.text = categoryLabel(context.l10n, widget.category!);
      _prefilled = true;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final existing = widget.category;
    final keptName =
        existing != null && _name.text == categoryLabel(context.l10n, existing);

    setState(() {
      _saving = true;
      _error = null;
    });

    final result = await ref.read(saveCategoryUseCaseProvider)(
      Category(
        id: existing?.id,
        name: keptName ? existing.name : _name.text,
        icon: _icon,
        colorValue: _color,
        isDefault: existing?.isDefault ?? false,
      ),
    );
    if (!mounted) return;

    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    result.fold(
      (failure) => setState(() {
        _saving = false;
        _error = failureMessageOf(context, failure);
      }),
      (_) {
        Navigator.of(context).pop();
        messenger.showSnackBar(SnackBar(content: Text(l10n.categorySaved)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labelStyle = Theme.of(context).textTheme.titleSmall;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.category == null
                      ? l10n.categoryNewTitle
                      : l10n.categoryEditTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _name,
                  autofocus: widget.category == null,
                  maxLength: SaveCategoryUseCase.maxNameLength,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _save(),
                  decoration: InputDecoration(
                    labelText: l10n.fieldCategoryName,
                    errorText: _error,
                  ),
                ),
                const SizedBox(height: 8),
                Text(l10n.fieldCategoryIcon, style: labelStyle),
                const SizedBox(height: 8),
                CategoryIconField(
                  icon: _icon,
                  color: _color,
                  onChanged: (icon) => setState(() => _icon = icon),
                ),
                const SizedBox(height: 20),
                Text(l10n.fieldCategoryColor, style: labelStyle),
                const SizedBox(height: 8),
                CategoryColorField(
                  color: _color,
                  onChanged: (color) => setState(() => _color = color),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _saving ? null : _save,
            child: Text(l10n.actionSave),
          ),
        ),
      ],
    );
  }
}
