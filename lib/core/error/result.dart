import 'package:meta/meta.dart';
import 'package:smart_budget_tracker/core/error/failure.dart';
import 'package:smart_budget_tracker/core/error/failure_mapper.dart';

/// A lightweight, immutable `Either` implementation used across every layer.
///
/// The domain deliberately does not depend on a functional-programming package:
/// Dart 3 sealed classes + exhaustive pattern matching give the same safety with
/// zero external dependencies. Use [Result.ok] / [Result.err] to build values,
/// [fold] to consume them and [map] / [flatMap] to build pipelines instead of
/// writing nested `if`/`try` blocks.
@immutable
sealed class Result<S, F extends Failure> {
  const Result();

  /// Creates a successful result carrying [value].
  const factory Result.ok(S value) = Ok<S, F>;

  /// Creates a failed result carrying [failure].
  const factory Result.err(F failure) = Err<S, F>;

  /// Shorthand for `Result<S, F>.ok(value)`.
  static Result<S, F> success<S, F extends Failure>(S value) => Ok<S, F>(value);

  /// Shorthand for `Result<S, F>.err(failure)`.
  static Result<S, F> failure<S, F extends Failure>(F failure) =>
      Err<S, F>(failure);

  /// Runs [body], converting any thrown object into a modelled [Failure].
  ///
  /// Intended for boundary code (data sources, platform adapters) so that the
  /// rest of the app never has to handle exceptions.
  static Result<S, Failure> attempt<S>(
    S Function() body, {
    Failure Function(Object error, StackTrace stackTrace)? onError,
  }) {
    try {
      return Result.success(body());
    } catch (error, stackTrace) {
      return Result.failure(
        onError?.call(error, stackTrace) ?? FailureMapper.map(error, stackTrace),
      );
    }
  }

  /// Asynchronous variant of [attempt].
  static Future<Result<S, Failure>> attemptAsync<S>(
    Future<S> Function() body, {
    Failure Function(Object error, StackTrace stackTrace)? onError,
  }) async {
    try {
      return Result.success(await body());
    } catch (error, stackTrace) {
      return Result.failure(
        onError?.call(error, stackTrace) ?? FailureMapper.map(error, stackTrace),
      );
    }
  }

  /// Whether this result carries a value.
  bool get isOk => this is Ok<S, F>;

  /// Whether this result carries a failure.
  bool get isErr => this is Err<S, F>;

  /// The success value or `null`.
  S? get valueOrNull => switch (this) {
    Ok<S, F>(value: final value) => value,
    Err<S, F>() => null,
  };

  /// The failure or `null`.
  F? get failureOrNull => switch (this) {
    Ok<S, F>() => null,
    Err<S, F>(failure: final failure) => failure,
  };

  /// Returns the success value, or the result of [orElse] when this is an error.
  S getOrElse(S Function() orElse) => switch (this) {
    Ok<S, F>(value: final value) => value,
    Err<S, F>() => orElse(),
  };

  /// Collapses both branches into a single value of type [R].
  R fold<R>(R Function(F failure) onFailure, R Function(S value) onSuccess) =>
      switch (this) {
        Ok<S, F>(value: final value) => onSuccess(value),
        Err<S, F>(failure: final failure) => onFailure(failure),
      };

  /// Transforms the success value, propagating the failure untouched.
  Result<T, F> map<T>(T Function(S value) transform) => switch (this) {
    Ok<S, F>(value: final value) => Ok<T, F>(transform(value)),
    Err<S, F>(failure: final failure) => Err<T, F>(failure),
  };

  /// Chains another fallible operation, short-circuiting on failure.
  Result<T, F> flatMap<T>(Result<T, F> Function(S value) transform) =>
      switch (this) {
        Ok<S, F>(value: final value) => transform(value),
        Err<S, F>(failure: final failure) => Err<T, F>(failure),
      };

  /// Transforms the failure, keeping the success value untouched.
  Result<S, G> mapFailure<G extends Failure>(G Function(F failure) transform) =>
      switch (this) {
        Ok<S, F>(value: final value) => Ok<S, G>(value),
        Err<S, F>(failure: final failure) => Err<S, G>(transform(failure)),
      };

  /// Side effect executed only for successful results.
  Result<S, F> onOk(void Function(S value) action) {
    if (this case Ok<S, F>(value: final value)) action(value);
    return this;
  }

  /// Side effect executed only for failed results.
  Result<S, F> onErr(void Function(F failure) action) {
    if (this case Err<S, F>(failure: final failure)) action(failure);
    return this;
  }
}

/// Successful [Result] carrying [value].
final class Ok<S, F extends Failure> extends Result<S, F> {
  const Ok(this.value);

  final S value;

  @override
  String toString() => 'Ok($value)';
}

/// Failed [Result] carrying [failure].
final class Err<S, F extends Failure> extends Result<S, F> {
  const Err(this.failure);

  final F failure;

  @override
  String toString() => 'Err($failure)';
}

/// Ergonomic [map]/[flatMap] for asynchronous results.
extension FutureResultX<S, F extends Failure> on Future<Result<S, F>> {
  /// [Result.map] for a future result.
  Future<Result<T, F>> mapResult<T>(T Function(S value) transform) async =>
      (await this).map(transform);

  /// [Result.flatMap] for a future result.
  Future<Result<T, F>> flatMapResult<T>(
    Future<Result<T, F>> Function(S value) transform,
  ) async {
    final result = await this;
    return result.fold<Future<Result<T, F>>>(
      (failure) async => Err<T, F>(failure),
      transform,
    );
  }
}
