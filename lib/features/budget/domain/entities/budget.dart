import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:smart_budget_tracker/core/values/money.dart';
import 'package:smart_budget_tracker/core/values/year_month.dart';

/// The spending limit of one civil month.
@immutable
final class Budget extends Equatable {
  const Budget({this.id, required this.period, required this.limit});

  /// Database identity; `null` for a budget that was not saved yet.
  final int? id;

  /// The month this limit applies to.
  final YearMonth period;

  /// How much the user is willing to spend in [period].
  final Money limit;

  @override
  List<Object?> get props => [id, period, limit];
}
