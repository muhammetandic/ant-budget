/// Semantic icon of a category.
///
/// Only the *meaning* is persisted. The presentation layer maps it onto a
/// `const` `IconData`, which keeps icon-font tree shaking working (storing raw
/// code points in the database would break the release build).
///
/// Enums are immutable by construction, so no `@immutable` annotation is needed.
enum CategoryIcon {
  groceries,
  transport,
  dining,
  shopping,
  bills,
  health,
  entertainment,
  salary,
  other,
}
