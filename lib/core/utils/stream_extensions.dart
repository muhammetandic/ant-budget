import 'dart:async';

/// A minimal `combineLatest` for two streams.
///
/// The app combines independent reactive sources (a budget limit and the sum of
/// its transactions) that must be re-evaluated whenever *either* side changes.
/// `dart:async` has no such operator and pulling in RxDart for one function is
/// not worth the dependency, so this small, tested extension covers it.
extension StreamCombineX<T> on Stream<T> {
  /// Emits `combine(latestSelf, latestOther)` whenever one of the two streams
  /// produces a value, once both have produced at least one.
  ///
  /// Errors are forwarded as-is. The returned stream completes when both
  /// sources complete. Pausing is not propagated, which is fine for the
  /// in-memory Drift streams this is used with.
  Stream<R> combineLatest<U, R>(
    Stream<U> other,
    R Function(T self, U other) combine,
  ) {
    StreamSubscription<T>? selfSubscription;
    StreamSubscription<U>? otherSubscription;
    late final StreamController<R> controller;
    T? latestSelf;
    U? latestOther;
    var hasSelf = false;
    var hasOther = false;
    var selfDone = false;
    var otherDone = false;

    void emitIfReady() {
      if (!hasSelf || !hasOther || controller.isClosed) return;
      controller.add(combine(latestSelf as T, latestOther as U));
    }

    void closeIfDone() {
      if (selfDone && otherDone && !controller.isClosed) {
        unawaited(controller.close());
      }
    }

    controller = StreamController<R>(
      onListen: () {
        selfSubscription = listen(
          (value) {
            latestSelf = value;
            hasSelf = true;
            emitIfReady();
          },
          onError: controller.addError,
          onDone: () {
            selfDone = true;
            closeIfDone();
          },
        );
        otherSubscription = other.listen(
          (value) {
            latestOther = value;
            hasOther = true;
            emitIfReady();
          },
          onError: controller.addError,
          onDone: () {
            otherDone = true;
            closeIfDone();
          },
        );
      },
      onCancel: () async {
        await selfSubscription?.cancel();
        await otherSubscription?.cancel();
      },
    );

    return controller.stream;
  }
}
