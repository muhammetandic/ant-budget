import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A type with exactly one value, used as the success type of `Result` for
/// operations that do not produce a meaningful value (`delete`, `update`, ...).
@immutable
final class Unit extends Equatable {
  const Unit._();

  /// The single instance of [Unit].
  static const Unit instance = Unit._();

  @override
  List<Object?> get props => const [];

  @override
  String toString() => 'Unit';
}
