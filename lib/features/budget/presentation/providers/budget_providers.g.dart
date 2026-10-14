// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Use case providers of the budget feature.

@ProviderFor(setBudgetLimitUseCase)
final setBudgetLimitUseCaseProvider = SetBudgetLimitUseCaseProvider._();

/// Use case providers of the budget feature.

final class SetBudgetLimitUseCaseProvider
    extends
        $FunctionalProvider<
          SetBudgetLimitUseCase,
          SetBudgetLimitUseCase,
          SetBudgetLimitUseCase
        >
    with $Provider<SetBudgetLimitUseCase> {
  /// Use case providers of the budget feature.
  SetBudgetLimitUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setBudgetLimitUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setBudgetLimitUseCaseHash();

  @$internal
  @override
  $ProviderElement<SetBudgetLimitUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SetBudgetLimitUseCase create(Ref ref) {
    return setBudgetLimitUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SetBudgetLimitUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SetBudgetLimitUseCase>(value),
    );
  }
}

String _$setBudgetLimitUseCaseHash() =>
    r'b4e5caa456946650c4c5d604c68178f5964d1af7';

@ProviderFor(watchBudgetSummaryUseCase)
final watchBudgetSummaryUseCaseProvider = WatchBudgetSummaryUseCaseProvider._();

final class WatchBudgetSummaryUseCaseProvider
    extends
        $FunctionalProvider<
          WatchBudgetSummaryUseCase,
          WatchBudgetSummaryUseCase,
          WatchBudgetSummaryUseCase
        >
    with $Provider<WatchBudgetSummaryUseCase> {
  WatchBudgetSummaryUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchBudgetSummaryUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchBudgetSummaryUseCaseHash();

  @$internal
  @override
  $ProviderElement<WatchBudgetSummaryUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WatchBudgetSummaryUseCase create(Ref ref) {
    return watchBudgetSummaryUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WatchBudgetSummaryUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WatchBudgetSummaryUseCase>(value),
    );
  }
}

String _$watchBudgetSummaryUseCaseHash() =>
    r'959d63663a768455a004ba0ea89aa177db808ea9';

/// The budget health of [period], reactively and auto-disposed per month.
///
/// The read model is assembled by the use case from two reactive sources
/// (budget + transaction totals), so a new expense updates this stream without
/// any manual invalidation.

@ProviderFor(budgetSummary)
final budgetSummaryProvider = BudgetSummaryFamily._();

/// The budget health of [period], reactively and auto-disposed per month.
///
/// The read model is assembled by the use case from two reactive sources
/// (budget + transaction totals), so a new expense updates this stream without
/// any manual invalidation.

final class BudgetSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<BudgetSummary>,
          BudgetSummary,
          Stream<BudgetSummary>
        >
    with $FutureModifier<BudgetSummary>, $StreamProvider<BudgetSummary> {
  /// The budget health of [period], reactively and auto-disposed per month.
  ///
  /// The read model is assembled by the use case from two reactive sources
  /// (budget + transaction totals), so a new expense updates this stream without
  /// any manual invalidation.
  BudgetSummaryProvider._({
    required BudgetSummaryFamily super.from,
    required YearMonth super.argument,
  }) : super(
         retry: null,
         name: r'budgetSummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$budgetSummaryHash();

  @override
  String toString() {
    return r'budgetSummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<BudgetSummary> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<BudgetSummary> create(Ref ref) {
    final argument = this.argument as YearMonth;
    return budgetSummary(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BudgetSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$budgetSummaryHash() => r'caf8408855f727c0f2764ffd426dddfed8d185de';

/// The budget health of [period], reactively and auto-disposed per month.
///
/// The read model is assembled by the use case from two reactive sources
/// (budget + transaction totals), so a new expense updates this stream without
/// any manual invalidation.

final class BudgetSummaryFamily extends $Family
    with $FunctionalFamilyOverride<Stream<BudgetSummary>, YearMonth> {
  BudgetSummaryFamily._()
    : super(
        retry: null,
        name: r'budgetSummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The budget health of [period], reactively and auto-disposed per month.
  ///
  /// The read model is assembled by the use case from two reactive sources
  /// (budget + transaction totals), so a new expense updates this stream without
  /// any manual invalidation.

  BudgetSummaryProvider call(YearMonth period) =>
      BudgetSummaryProvider._(argument: period, from: this);

  @override
  String toString() => r'budgetSummaryProvider';
}
