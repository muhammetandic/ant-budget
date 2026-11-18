// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(watchDebtsUseCase)
final watchDebtsUseCaseProvider = WatchDebtsUseCaseProvider._();

final class WatchDebtsUseCaseProvider
    extends
        $FunctionalProvider<
          WatchDebtsUseCase,
          WatchDebtsUseCase,
          WatchDebtsUseCase
        >
    with $Provider<WatchDebtsUseCase> {
  WatchDebtsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchDebtsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchDebtsUseCaseHash();

  @$internal
  @override
  $ProviderElement<WatchDebtsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WatchDebtsUseCase create(Ref ref) {
    return watchDebtsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WatchDebtsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WatchDebtsUseCase>(value),
    );
  }
}

String _$watchDebtsUseCaseHash() => r'1c8c57635154f1f0026bef61bdd4e91740653809';

@ProviderFor(saveDebtUseCase)
final saveDebtUseCaseProvider = SaveDebtUseCaseProvider._();

final class SaveDebtUseCaseProvider
    extends
        $FunctionalProvider<SaveDebtUseCase, SaveDebtUseCase, SaveDebtUseCase>
    with $Provider<SaveDebtUseCase> {
  SaveDebtUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'saveDebtUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$saveDebtUseCaseHash();

  @$internal
  @override
  $ProviderElement<SaveDebtUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SaveDebtUseCase create(Ref ref) {
    return saveDebtUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SaveDebtUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SaveDebtUseCase>(value),
    );
  }
}

String _$saveDebtUseCaseHash() => r'cae53e1825e7d3f9669a92ef9eb5648d6fd0eb36';

@ProviderFor(deleteDebtUseCase)
final deleteDebtUseCaseProvider = DeleteDebtUseCaseProvider._();

final class DeleteDebtUseCaseProvider
    extends
        $FunctionalProvider<
          DeleteDebtUseCase,
          DeleteDebtUseCase,
          DeleteDebtUseCase
        >
    with $Provider<DeleteDebtUseCase> {
  DeleteDebtUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteDebtUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteDebtUseCaseHash();

  @$internal
  @override
  $ProviderElement<DeleteDebtUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeleteDebtUseCase create(Ref ref) {
    return deleteDebtUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteDebtUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteDebtUseCase>(value),
    );
  }
}

String _$deleteDebtUseCaseHash() => r'29ae74c9a12acb663624595edd29d5c3b54cccc0';

@ProviderFor(toggleDebtSettledUseCase)
final toggleDebtSettledUseCaseProvider = ToggleDebtSettledUseCaseProvider._();

final class ToggleDebtSettledUseCaseProvider
    extends
        $FunctionalProvider<
          ToggleDebtSettledUseCase,
          ToggleDebtSettledUseCase,
          ToggleDebtSettledUseCase
        >
    with $Provider<ToggleDebtSettledUseCase> {
  ToggleDebtSettledUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'toggleDebtSettledUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$toggleDebtSettledUseCaseHash();

  @$internal
  @override
  $ProviderElement<ToggleDebtSettledUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ToggleDebtSettledUseCase create(Ref ref) {
    return toggleDebtSettledUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ToggleDebtSettledUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ToggleDebtSettledUseCase>(value),
    );
  }
}

String _$toggleDebtSettledUseCaseHash() =>
    r'9a475d6199f826d443660bef421db352942121dd';

@ProviderFor(debtsList)
final debtsListProvider = DebtsListProvider._();

final class DebtsListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DebtEntry>>,
          List<DebtEntry>,
          Stream<List<DebtEntry>>
        >
    with $FutureModifier<List<DebtEntry>>, $StreamProvider<List<DebtEntry>> {
  DebtsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'debtsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$debtsListHash();

  @$internal
  @override
  $StreamProviderElement<List<DebtEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<DebtEntry>> create(Ref ref) {
    return debtsList(ref);
  }
}

String _$debtsListHash() => r'bb036867ecf02244a074ba66d8ea8f5407dfd921';

@ProviderFor(ActiveDebtFilter)
final activeDebtFilterProvider = ActiveDebtFilterProvider._();

final class ActiveDebtFilterProvider
    extends $NotifierProvider<ActiveDebtFilter, DebtFilter> {
  ActiveDebtFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeDebtFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeDebtFilterHash();

  @$internal
  @override
  ActiveDebtFilter create() => ActiveDebtFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DebtFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DebtFilter>(value),
    );
  }
}

String _$activeDebtFilterHash() => r'5304114d46d07982d7415398d7db8efd4bf662ca';

abstract class _$ActiveDebtFilter extends $Notifier<DebtFilter> {
  DebtFilter build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DebtFilter, DebtFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DebtFilter, DebtFilter>,
              DebtFilter,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(debtSummary)
final debtSummaryProvider = DebtSummaryProvider._();

final class DebtSummaryProvider
    extends $FunctionalProvider<DebtSummary, DebtSummary, DebtSummary>
    with $Provider<DebtSummary> {
  DebtSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'debtSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$debtSummaryHash();

  @$internal
  @override
  $ProviderElement<DebtSummary> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DebtSummary create(Ref ref) {
    return debtSummary(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DebtSummary value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DebtSummary>(value),
    );
  }
}

String _$debtSummaryHash() => r'2b741561ad40ba8603ee23a62b0e839c2fd7b700';

@ProviderFor(filteredDebts)
final filteredDebtsProvider = FilteredDebtsProvider._();

final class FilteredDebtsProvider
    extends
        $FunctionalProvider<List<DebtEntry>, List<DebtEntry>, List<DebtEntry>>
    with $Provider<List<DebtEntry>> {
  FilteredDebtsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredDebtsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredDebtsHash();

  @$internal
  @override
  $ProviderElement<List<DebtEntry>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<DebtEntry> create(Ref ref) {
    return filteredDebts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DebtEntry> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DebtEntry>>(value),
    );
  }
}

String _$filteredDebtsHash() => r'7110fc6a6d062d9ff6742fd576b46e442c10e291';
