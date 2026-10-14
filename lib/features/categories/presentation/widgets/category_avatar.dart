import 'package:flutter/material.dart';
import 'package:ant_budget/core/theme/category_icon_mapper.dart';
import 'package:ant_budget/features/categories/domain/entities/category.dart';

/// Circular, category-coloured avatar showing the category icon.
class CategoryAvatar extends StatelessWidget {
  const CategoryAvatar({super.key, required this.category, this.radius = 20});

  final Category category;

  /// Radius of the circle.
  final double radius;

  @override
  Widget build(BuildContext context) {
    final color = Color(category.colorValue);
    return CircleAvatar(
      radius: radius,
      backgroundColor: color.withValues(alpha: 0.16),
      child: Icon(
        CategoryIconMapper.resolve(category.icon),
        size: radius,
        color: color,
      ),
    );
  }
}

/// Fallback avatar used when a transaction references a category that has not
/// been loaded yet.
class UnknownCategoryAvatar extends StatelessWidget {
  const UnknownCategoryAvatar({super.key, this.radius = 20});

  final double radius;

  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: radius,
    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    child: Icon(
      Icons.help_outline,
      size: radius,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    ),
  );
}
