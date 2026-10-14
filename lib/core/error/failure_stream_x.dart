import 'dart:async';

import 'package:ant_budget/core/error/failure_mapper.dart';

/// Makes sure every error travelling through a stream is a modelled `Failure`.
///
/// Repositories expose reactive streams; without this helper a raw driver
/// exception (e.g. `SqliteException`) would surface in the presentation layer.
/// Adapters wrap their streams in [mapErrorsToFailures] so the UI can rely on
/// `AsyncValue.error` always containing a `Failure`.
extension FailureStreamX<T> on Stream<T> {
  /// Replaces thrown errors with the matching domain `Failure`.
  Stream<T> mapErrorsToFailures() => transform(
    StreamTransformer<T, T>.fromHandlers(
      handleError: (Object error, StackTrace stackTrace, EventSink<T> sink) {
        sink.addError(FailureMapper.map(error, stackTrace), stackTrace);
      },
    ),
  );
}
