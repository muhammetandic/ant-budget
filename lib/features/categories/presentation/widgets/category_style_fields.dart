import 'package:flutter/material.dart';
import 'package:ant_budget/core/theme/category_icon_mapper.dart';
import 'package:ant_budget/core/values/category_icon.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// Colours a category can be given, matching the palette of the seeded ones.
const List<int> _palette = [
  0xFF2E7D32,
  0xFFEF6C00,
  0xFF1565C0,
  0xFF6A1B9A,
  0xFF00838F,
  0xFFC62828,
  0xFF4527A0,
  0xFF00796B,
  0xFF455A64,
  0xFFD81B60,
  0xFF8E24AA,
  0xFF5E35B1,
  0xFF3949AB,
  0xFF1E88E5,
  0xFF039BE5,
  0xFF00ACC1,
  0xFF00897B,
  0xFF43A047,
  0xFF7CB342,
  0xFFC0CA33,
  0xFFFDD835,
  0xFFFFB300,
  0xFFFB8C00,
  0xFFF4511E,
  0xFF6D4C41,
  0xFF757575,
];

/// Picks the icon of a category.
class CategoryIconField extends StatefulWidget {
  const CategoryIconField({
    super.key,
    required this.icon,
    required this.color,
    required this.onChanged,
  });

  /// Icon a brand new category starts with.
  static const CategoryIcon initialIcon = CategoryIcon.other;

  /// Currently picked icon.
  final CategoryIcon icon;

  /// Colour currently picked, used to highlight the selection.
  final int color;

  /// Invoked with the icon the user tapped.
  final ValueChanged<CategoryIcon> onChanged;

  @override
  State<CategoryIconField> createState() => _CategoryIconFieldState();
}

class _CategoryIconFieldState extends State<CategoryIconField> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final candidates = _showAll
        ? CategoryIcon.values
        : _visibleChoices(CategoryIcon.values, widget.icon);
    return Column(
      children: [
        GridView.count(
          crossAxisCount: 6,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1,
          children: [
            for (final candidate in candidates)
              _Choice(
                selected: candidate == widget.icon,
                accent: widget.color,
                onTap: () => widget.onChanged(candidate),
                child: Icon(
                  CategoryIconMapper.resolve(candidate),
                  color: candidate == widget.icon
                      ? Color(widget.color)
                      : scheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
        _MoreLessButton(
          showAll: _showAll,
          onPressed: () => setState(() => _showAll = !_showAll),
        ),
      ],
    );
  }
}

/// Picks the colour of a category.
class CategoryColorField extends StatefulWidget {
  const CategoryColorField({
    super.key,
    required this.color,
    required this.onChanged,
  });

  /// Colour a brand new category is created with.
  static const int initialColor = 0xFF2E7D32;

  /// Currently picked colour.
  final int color;

  /// Invoked with the colour the user tapped.
  final ValueChanged<int> onChanged;

  @override
  State<CategoryColorField> createState() => _CategoryColorFieldState();
}

class _CategoryColorFieldState extends State<CategoryColorField> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final candidates = _showAll
        ? _palette
        : _visibleChoices(_palette, widget.color);
    return Column(
      children: [
        GridView.count(
          crossAxisCount: 6,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1,
          children: [
            for (final candidate in candidates)
              _Choice(
                selected: candidate == widget.color,
                accent: candidate,
                onTap: () => widget.onChanged(candidate),
                child: SizedBox.square(
                  dimension: 26,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(candidate),
                    ),
                  ),
                ),
              ),
          ],
        ),
        _MoreLessButton(
          showAll: _showAll,
          onPressed: () => setState(() => _showAll = !_showAll),
        ),
      ],
    );
  }
}

List<T> _visibleChoices<T>(List<T> choices, T selected) {
  final visible = choices.take(8).toList();
  if (!visible.contains(selected)) visible.add(selected);
  return visible;
}

class _MoreLessButton extends StatelessWidget {
  const _MoreLessButton({required this.showAll, required this.onPressed});

  final bool showAll;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: TextButton.icon(
      onPressed: onPressed,
      icon: Icon(showAll ? Icons.expand_less : Icons.expand_more),
      label: Text(showAll ? context.l10n.actionLess : context.l10n.actionMore),
    ),
  );
}

/// Circular tap target of both pickers; only the ring highlights [selected].
class _Choice extends StatelessWidget {
  const _Choice({
    required this.selected,
    required this.accent,
    required this.onTap,
    required this.child,
  });

  final bool selected;
  final int accent;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? Color(accent).withValues(alpha: 0.16) : null,
          border: Border.all(
            color: selected ? Color(accent) : scheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: Center(child: child),
      ),
    );
  }
}
