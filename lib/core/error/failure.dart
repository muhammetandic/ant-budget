import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Base class for every *expected* error in the application.
///
/// Anything the app can meaningfully react to (invalid input, a missing record,
/// an unreadable receipt, a database error, ...) is expressed as a [Failure].
/// Failures travel through the domain as the error side of a `Result` instead of
/// being thrown, which removes deep `try/catch` pyramids from the call chain.
///
/// Failures are immutable value objects, which makes them trivial to compare in
/// tests and safe to store inside Riverpod state.
@immutable
sealed class Failure extends Equatable {
  const Failure({required this.message, this.cause, this.stackTrace});

  /// Human readable, already user-safe message.
  final String message;

  /// The original error, kept for logging/diagnostics only.
  final Object? cause;

  /// Stack trace of the original error, kept for logging/diagnostics only.
  final StackTrace? stackTrace;

  @override
  List<Object?> get props => [runtimeType, message, cause];
}

/// The user input (or an adapter result) violates a domain invariant.
final class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    this.field,
    super.cause,
    super.stackTrace,
  });

  /// Optional identifier of the offending field, so forms can highlight it.
  final String? field;

  @override
  List<Object?> get props => [...super.props, field];
}

/// A requested entity does not exist (or no longer exists).
final class NotFoundFailure extends Failure {
  const NotFoundFailure({
    required super.message,
    required this.entityType,
    this.entityId,
    super.cause,
    super.stackTrace,
  });

  final String entityType;
  final Object? entityId;

  @override
  List<Object?> get props => [...super.props, entityType, entityId];
}

/// The persistence layer (Drift/SQLite) could not fulfill the request.
final class StorageFailure extends Failure {
  const StorageFailure({required super.message, super.cause, super.stackTrace});
}

/// On-device text recognition (ML Kit) failed or returned nothing usable.
final class OcrFailure extends Failure {
  const OcrFailure({
    required super.message,
    this.code = OcrFailureCode.processingFailed,
    super.cause,
    super.stackTrace,
  });

  final OcrFailureCode code;

  @override
  List<Object?> get props => [...super.props, code];
}

/// Machine readable reason behind an [OcrFailure].
enum OcrFailureCode {
  /// The user did not grant camera access (or revoked it).
  permissionDenied,

  /// ML Kit is not available on this device / could not be initialised.
  engineUnavailable,

  /// Recognition succeeded, but there was no readable text on the image.
  noTextFound,

  /// Recognition itself failed while processing the image.
  processingFailed,
}

/// The receipt camera could not be opened or used.
///
/// Separate from [OcrFailure] because "the camera is blocked/unavailable" and
/// "the text could not be understood" are different problems with different
/// remedies (grant permission vs. retake the photo).
final class CameraFailure extends Failure {
  const CameraFailure({
    required super.message,
    this.code = CameraFailureCode.unavailable,
    super.cause,
    super.stackTrace,
  });

  final CameraFailureCode code;

  @override
  List<Object?> get props => [...super.props, code];
}

/// Machine readable reason behind a [CameraFailure].
enum CameraFailureCode {
  /// The user denied (or permanently blocked) camera access.
  permissionDenied,

  /// No usable camera exists on this device.
  unavailable,

  /// The shutter could not produce a photo.
  captureFailed,
}

/// A parsing strategy of the receipt pipeline could not interpret the OCR text.
final class ParseFailure extends Failure {
  const ParseFailure({
    required super.message,
    required this.issue,
    this.strategy,
    super.cause,
    super.stackTrace,
  });

  /// No monetary total could be located anywhere on the receipt.
  const ParseFailure.amountNotFound({String? strategy})
    : this(
        message: 'No total amount could be found on the receipt.',
        issue: ParseIssue.amountNotFound,
        strategy: strategy,
      );

  /// The OCR text was empty, so there is nothing to parse.
  const ParseFailure.emptyInput()
    : this(
        message: 'The scanned receipt does not contain any readable text.',
        issue: ParseIssue.emptyInput,
      );

  final ParseIssue issue;

  /// Name of the strategy that raised the failure, when known.
  final String? strategy;

  @override
  List<Object?> get props => [...super.props, issue, strategy];
}

/// Machine readable reason behind a [ParseFailure].
enum ParseIssue { emptyInput, amountNotFound }

/// Catch-all for errors that are not part of the modelled domain.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'Something went wrong. Please try again.',
    super.cause,
    super.stackTrace,
  });
}
