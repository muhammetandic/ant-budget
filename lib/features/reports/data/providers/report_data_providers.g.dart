// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_data_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Dependency wiring of the reports data layer.

@ProviderFor(reportDao)
final reportDaoProvider = ReportDaoProvider._();

/// Dependency wiring of the reports data layer.

final class ReportDaoProvider
    extends $FunctionalProvider<ReportDao, ReportDao, ReportDao>
    with $Provider<ReportDao> {
  /// Dependency wiring of the reports data layer.
  ReportDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportDaoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportDaoHash();

  @$internal
  @override
  $ProviderElement<ReportDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ReportDao create(Ref ref) {
    return reportDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReportDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReportDao>(value),
    );
  }
}

String _$reportDaoHash() => r'c1fa15d95d56d308ee82b6d4f4ac492489f557c1';

/// The report repository abstraction injected into the domain use cases.

@ProviderFor(expenseReportRepository)
final expenseReportRepositoryProvider = ExpenseReportRepositoryProvider._();

/// The report repository abstraction injected into the domain use cases.

final class ExpenseReportRepositoryProvider
    extends
        $FunctionalProvider<
          ExpenseReportRepository,
          ExpenseReportRepository,
          ExpenseReportRepository
        >
    with $Provider<ExpenseReportRepository> {
  /// The report repository abstraction injected into the domain use cases.
  ExpenseReportRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expenseReportRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expenseReportRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExpenseReportRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExpenseReportRepository create(Ref ref) {
    return expenseReportRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExpenseReportRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExpenseReportRepository>(value),
    );
  }
}

String _$expenseReportRepositoryHash() =>
    r'4cb429146c32b2a0d2d6b2c803a46977f86069bf';
