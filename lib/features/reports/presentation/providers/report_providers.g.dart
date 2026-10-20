// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Use case provider: the UI asks for *behaviour*, never for the repository.

@ProviderFor(watchExpenseBreakdownUseCase)
final watchExpenseBreakdownUseCaseProvider =
    WatchExpenseBreakdownUseCaseProvider._();

/// Use case provider: the UI asks for *behaviour*, never for the repository.

final class WatchExpenseBreakdownUseCaseProvider
    extends
        $FunctionalProvider<
          WatchExpenseBreakdownUseCase,
          WatchExpenseBreakdownUseCase,
          WatchExpenseBreakdownUseCase
        >
    with $Provider<WatchExpenseBreakdownUseCase> {
  /// Use case provider: the UI asks for *behaviour*, never for the repository.
  WatchExpenseBreakdownUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchExpenseBreakdownUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchExpenseBreakdownUseCaseHash();

  @$internal
  @override
  $ProviderElement<WatchExpenseBreakdownUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WatchExpenseBreakdownUseCase create(Ref ref) {
    return watchExpenseBreakdownUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WatchExpenseBreakdownUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WatchExpenseBreakdownUseCase>(value),
    );
  }
}

String _$watchExpenseBreakdownUseCaseHash() =>
    r'5c85f2a3c09791c74213340f6b6b22f68a4b1ff9';

/// Category and shop report of [period], reactively and auto-disposed per month.
///
/// The same [YearMonth] moves the overview, the transaction list and the report,
/// so one month switcher drives all three.

@ProviderFor(expenseBreakdown)
final expenseBreakdownProvider = ExpenseBreakdownFamily._();

/// Category and shop report of [period], reactively and auto-disposed per month.
///
/// The same [YearMonth] moves the overview, the transaction list and the report,
/// so one month switcher drives all three.

final class ExpenseBreakdownProvider
    extends
        $FunctionalProvider<
          AsyncValue<ExpenseBreakdown>,
          ExpenseBreakdown,
          Stream<ExpenseBreakdown>
        >
    with $FutureModifier<ExpenseBreakdown>, $StreamProvider<ExpenseBreakdown> {
  /// Category and shop report of [period], reactively and auto-disposed per month.
  ///
  /// The same [YearMonth] moves the overview, the transaction list and the report,
  /// so one month switcher drives all three.
  ExpenseBreakdownProvider._({
    required ExpenseBreakdownFamily super.from,
    required YearMonth super.argument,
  }) : super(
         retry: null,
         name: r'expenseBreakdownProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$expenseBreakdownHash();

  @override
  String toString() {
    return r'expenseBreakdownProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<ExpenseBreakdown> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<ExpenseBreakdown> create(Ref ref) {
    final argument = this.argument as YearMonth;
    return expenseBreakdown(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpenseBreakdownProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$expenseBreakdownHash() => r'8974bfb4a52ccd426bf9928b113203c29b92f376';

/// Category and shop report of [period], reactively and auto-disposed per month.
///
/// The same [YearMonth] moves the overview, the transaction list and the report,
/// so one month switcher drives all three.

final class ExpenseBreakdownFamily extends $Family
    with $FunctionalFamilyOverride<Stream<ExpenseBreakdown>, YearMonth> {
  ExpenseBreakdownFamily._()
    : super(
        retry: null,
        name: r'expenseBreakdownProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Category and shop report of [period], reactively and auto-disposed per month.
  ///
  /// The same [YearMonth] moves the overview, the transaction list and the report,
  /// so one month switcher drives all three.

  ExpenseBreakdownProvider call(YearMonth period) =>
      ExpenseBreakdownProvider._(argument: period, from: this);

  @override
  String toString() => r'expenseBreakdownProvider';
}
