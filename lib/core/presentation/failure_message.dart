import 'package:smart_budget_tracker/core/error/failure.dart';

/// Extracts a user-safe message from an arbitrary error object.
///
/// `AsyncValue.error` carries `Object` so it can hold anything; in this app it
/// is always a modelled [Failure], but the fallback keeps a stray platform
/// exception from showing `Instance of '...'` to the user.
String failureMessageOf(Object? error) => error is Failure
    ? error.message
    : 'Something went wrong. Please try again.';
