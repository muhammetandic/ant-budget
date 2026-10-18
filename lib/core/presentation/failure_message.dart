import 'package:flutter/widgets.dart';
import 'package:ant_budget/core/config/app_config.dart';
import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// Renders [error] as user facing copy in the current language.
///
/// Failures carry an English developer message plus a machine readable code;
/// this is the single place that turns those codes into localized copy, so no
/// feature has to know how an error is worded. `AsyncValue.error` carries
/// `Object` so it can hold anything, hence the catch-all branch: a stray
/// platform exception must never surface as `Instance of '...'`.
String failureMessageOf(BuildContext context, Object? error) =>
    failureMessageFor(context.l10n, error);

/// Language-independent core of [failureMessageOf].
String failureMessageFor(AppLocalizations l10n, Object? error) {
  return switch (error) {
    ValidationFailure(:final issue) => _validation(l10n, issue),
    NotFoundFailure(:final entityType) => _notFound(l10n, entityType),
    StorageFailure() => l10n.errorStorage,
    OcrFailure(:final code) => _ocr(l10n, code),
    CameraFailure(:final code) => _camera(l10n, code),
    ParseFailure(:final issue) => _parse(l10n, issue),
    UnexpectedFailure(:final code) => _unexpected(l10n, code),
    _ => l10n.errorUnknown,
  };
}

String _validation(AppLocalizations l10n, ValidationIssue issue) =>
    switch (issue) {
      ValidationIssue.amountNotPositive => l10n.errorAmountNotPositive,
      ValidationIssue.categoryMissing => l10n.errorCategoryMissing,
      ValidationIssue.descriptionTooLong => l10n.errorDescriptionTooLong,
      ValidationIssue.dateOutOfRange => l10n.errorDateOutOfRange,
      ValidationIssue.budgetNotPositive => l10n.errorBudgetNotPositive,
      ValidationIssue.budgetCurrencyMismatch => l10n.errorBudgetCurrency(
        AppConfig.reportingCurrency.code,
      ),
      ValidationIssue.categoryNameEmpty => l10n.errorCategoryNameEmpty,
      ValidationIssue.categoryNameTooLong => l10n.errorCategoryNameTooLong,
      ValidationIssue.categoryInUse => l10n.errorCategoryInUse,
    };

String _notFound(AppLocalizations l10n, String entityType) =>
    switch (entityType.toLowerCase()) {
      'transaction' => l10n.errorTransactionNotFound,
      'category' => l10n.errorCategoryNotFound,
      _ => l10n.errorNotFound,
    };

String _ocr(AppLocalizations l10n, OcrFailureCode code) => switch (code) {
  OcrFailureCode.permissionDenied => l10n.errorCameraPermission,
  OcrFailureCode.engineUnavailable => l10n.errorOcrEngineUnavailable,
  OcrFailureCode.noTextFound => l10n.errorOcrNoText,
  OcrFailureCode.processingFailed => l10n.errorOcrFailed,
};

String _camera(AppLocalizations l10n, CameraFailureCode code) => switch (code) {
  CameraFailureCode.permissionDenied => l10n.errorCameraPermission,
  CameraFailureCode.unavailable => l10n.errorCameraUnavailable,
  CameraFailureCode.captureFailed => l10n.errorCameraCaptureFailed,
};

String _parse(AppLocalizations l10n, ParseIssue issue) => switch (issue) {
  ParseIssue.emptyInput => l10n.errorParseEmpty,
  ParseIssue.amountNotFound => l10n.errorParseNoAmount,
};

String _unexpected(AppLocalizations l10n, UnexpectedFailureCode code) =>
    switch (code) {
      UnexpectedFailureCode.platform => l10n.errorDevice,
      UnexpectedFailureCode.unknown => l10n.errorUnknown,
    };
