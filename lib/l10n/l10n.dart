import 'package:ant_budget/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';

export 'package:ant_budget/l10n/generated/app_localizations.dart';

/// Shortcut for the app's own translations.
///
/// Widgets read copy through `context.l10n.navBudget` instead of
/// `AppLocalizations.of(context)!`, which keeps call sites short and makes the
/// dependency on the localisation layer obvious at a glance.
extension AppLocalizationsX on BuildContext {
  /// Localised strings of the current locale.
  AppLocalizations get l10n => AppLocalizations.of(this);
}
