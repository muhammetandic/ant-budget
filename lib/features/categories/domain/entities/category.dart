import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:smart_budget_tracker/core/values/category_icon.dart';

/// A spending category transactions can be assigned to.
@immutable
final class Category extends Equatable {
  const Category({
    this.id,
    required this.name,
    required this.icon,
    required this.colorValue,
    this.isDefault = false,
  });

  /// Database identity; `null` for a category that was not saved yet.
  final int? id;

  final String name;

  /// Semantic icon, resolved to an `IconData` by the presentation layer.
  final CategoryIcon icon;

  /// ARGB colour stored as an int so the entity stays Flutter-free.
  final int colorValue;

  /// Whether the category ships with the app.
  final bool isDefault;

  @override
  List<Object?> get props => [id, name, icon, colorValue, isDefault];
}
