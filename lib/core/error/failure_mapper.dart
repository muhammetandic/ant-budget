import 'package:drift/isolate.dart' show DriftRemoteException;
import 'package:flutter/services.dart' show PlatformException;
import 'package:sqlite3/sqlite3.dart' show SqliteException;
import 'package:smart_budget_tracker/core/error/failure.dart';

/// Translates arbitrary thrown objects into modelled [Failure]s.
///
/// This is the *only* place in the code base that knows about infrastructure
/// exceptions. Boundary adapters (data sources, platform services) delegate
/// their `catch` clauses to [map], everything above the data layer only ever
/// sees domain [Failure]s.
abstract final class FailureMapper {
  /// Maps [error] onto the closest matching [Failure].
  ///
  /// A [Failure] is returned untouched, which makes the mapper safe to call
  /// more than once for the same error.
  static Failure map(Object error, [StackTrace? stackTrace]) {
    if (error is Failure) return error;
    if (error is DriftRemoteException || error is SqliteException) {
      return StorageFailure(
        message: 'The local database could not complete the operation.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
    if (error is PlatformException) {
      return UnexpectedFailure(
        message: 'The device could not complete the operation.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
    return UnexpectedFailure(
      message: 'Something went wrong. Please try again.',
      cause: error,
      stackTrace: stackTrace,
    );
  }
}
