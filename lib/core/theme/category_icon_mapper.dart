import 'package:flutter/material.dart';
import 'package:ant_budget/core/values/category_icon.dart';

/// Resolves a persisted [CategoryIcon] into a Material icon.
///
/// The database stores the semantic enum, never a code point, so the mapping
/// lives here as a `const`-friendly switch and icon-font tree shaking keeps
/// working in release builds.
abstract final class CategoryIconMapper {
  /// The [IconData] representing [icon].
  static IconData resolve(CategoryIcon icon) => switch (icon) {
    CategoryIcon.groceries => Icons.local_grocery_store_outlined,
    CategoryIcon.transport => Icons.directions_bus_outlined,
    CategoryIcon.dining => Icons.restaurant_outlined,
    CategoryIcon.shopping => Icons.shopping_bag_outlined,
    CategoryIcon.bills => Icons.receipt_long_outlined,
    CategoryIcon.health => Icons.local_hospital_outlined,
    CategoryIcon.entertainment => Icons.movie_outlined,
    CategoryIcon.salary => Icons.account_balance_wallet_outlined,
    CategoryIcon.other => Icons.category_outlined,
  };
}
