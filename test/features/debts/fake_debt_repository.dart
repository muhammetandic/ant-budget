import 'dart:async';
import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/core/values/unit.dart';
import 'package:ant_budget/features/debts/domain/entities/debt_entry.dart';
import 'package:ant_budget/features/debts/domain/repositories/debt_repository.dart';

class FakeDebtRepository implements DebtRepository {
  final List<DebtEntry> _items = [];
  final StreamController<List<DebtEntry>> _controller =
      StreamController<List<DebtEntry>>.broadcast();

  int _nextId = 1;

  List<DebtEntry> get saved => List.unmodifiable(_items);

  @override
  Stream<List<DebtEntry>> watchAll() => _controller.stream;

  void emit(List<DebtEntry> items) {
    _items
      ..clear()
      ..addAll(items);
    _controller.add(List.unmodifiable(_items));
  }

  @override
  Future<Result<int, Failure>> save(DebtEntry entry) async {
    final id = entry.id ?? _nextId++;
    final stored = entry.copyWith(id: id);
    final index = _items.indexWhere((e) => e.id == id);
    if (index >= 0) {
      _items[index] = stored;
    } else {
      _items.add(stored);
    }
    _controller.add(List.unmodifiable(_items));
    return Result.ok(id);
  }

  @override
  Future<Result<Unit, Failure>> deleteById(int id) async {
    _items.removeWhere((e) => e.id == id);
    _controller.add(List.unmodifiable(_items));
    return const Result.ok(Unit.instance);
  }

  @override
  Future<Result<Unit, Failure>> toggleSettled(int id, bool isSettled) async {
    final index = _items.indexWhere((e) => e.id == id);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(isSettled: isSettled);
      _controller.add(List.unmodifiable(_items));
    }
    return const Result.ok(Unit.instance);
  }

  void dispose() {
    _controller.close();
  }
}
