import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ant_budget/core/values/debt_type.dart';
import 'package:ant_budget/core/values/money.dart';

/// An entry recording money owed to or by the user.
@immutable
final class DebtEntry extends Equatable {
  const DebtEntry({
    this.id,
    required this.person,
    required this.amount,
    required this.type,
    required this.dueDate,
    this.isSettled = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? dueDate;

  /// Database identity; `null` before first save.
  final int? id;

  /// The person associated with this debt/claim.
  final String person;

  /// The amount in minor units and currency.
  final Money amount;

  /// Whether this is a debt (user owes) or a claim (user is owed).
  final DebtType type;

  /// Date when the debt was recorded or due.
  final DateTime dueDate;

  /// Whether the balance has been paid/cleared.
  final bool isSettled;

  /// Creation timestamp.
  final DateTime createdAt;

  bool get isDebt => type == DebtType.debt;
  bool get isClaim => type == DebtType.claim;

  DebtEntry copyWith({
    int? id,
    String? person,
    Money? amount,
    DebtType? type,
    DateTime? dueDate,
    bool? isSettled,
    DateTime? createdAt,
  }) {
    return DebtEntry(
      id: id ?? this.id,
      person: person ?? this.person,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      dueDate: dueDate ?? this.dueDate,
      isSettled: isSettled ?? this.isSettled,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    person,
    amount,
    type,
    dueDate,
    isSettled,
    createdAt,
  ];
}
