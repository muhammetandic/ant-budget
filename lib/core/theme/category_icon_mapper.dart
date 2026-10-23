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
    CategoryIcon.home => Icons.home_outlined,
    CategoryIcon.education => Icons.school_outlined,
    CategoryIcon.travel => Icons.flight_outlined,
    CategoryIcon.pets => Icons.pets_outlined,
    CategoryIcon.gifts => Icons.card_giftcard_outlined,
    CategoryIcon.sports => Icons.sports_soccer_outlined,
    CategoryIcon.coffee => Icons.coffee_outlined,
    CategoryIcon.car => Icons.directions_car_outlined,
    CategoryIcon.phone => Icons.phone_iphone_outlined,
    CategoryIcon.clothes => Icons.checkroom_outlined,
    CategoryIcon.beauty => Icons.spa_outlined,
    CategoryIcon.childcare => Icons.child_care_outlined,
    CategoryIcon.insurance => Icons.verified_user_outlined,
    CategoryIcon.investments => Icons.trending_up_outlined,
    CategoryIcon.donations => Icons.volunteer_activism_outlined,
    CategoryIcon.cash => Icons.payments_outlined,
    CategoryIcon.other => Icons.category_outlined,
  };
}
