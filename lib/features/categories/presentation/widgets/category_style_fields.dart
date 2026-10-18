import 'package:flutter/material.dart';
import 'package:ant_budget/core/theme/category_icon_mapper.dart';
import 'package:ant_budget/core/values/category_icon.dart';

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
];

/// Picks the icon of a category.
class CategoryIconField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final candidate in CategoryIcon.values)
          _Choice(
            selected: candidate == icon,
            accent: color,
            onTap: () => onChanged(candidate),
            child: Icon(
              CategoryIconMapper.resolve(candidate),
              color: candidate == icon
                  ? Color(color)
                  : scheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}

/// Picks the colour of a category.
class CategoryColorField extends StatelessWidget {
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
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      for (final candidate in _palette)
        _Choice(
          selected: candidate == color,
          accent: candidate,
          onTap: () => onChanged(candidate),
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
