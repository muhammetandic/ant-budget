import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/presentation/failure_message.dart';
import 'package:ant_budget/l10n/l10n.dart';

void main() {
  final en = lookupAppLocalizations(const Locale('en'));
  final tr = lookupAppLocalizations(const Locale('tr'));

  group('failureMessageFor', () {
    test('translates a validation reason instead of the developer message', () {
      const failure = ValidationFailure(
        message: 'Enter an amount greater than zero.',
        issue: ValidationIssue.amountNotPositive,
      );
      expect(
        failureMessageFor(en, failure),
        'Enter an amount greater than zero.',
      );
      expect(failureMessageFor(tr, failure), 'Sıfırdan büyük bir tutar girin.');
    });

    test('keeps the reporting currency in the budget currency message', () {
      const failure = ValidationFailure(
        message: 'Budgets are tracked in TRY.',
        issue: ValidationIssue.budgetCurrencyMismatch,
      );
      expect(failureMessageFor(tr, failure), 'Bütçeler TRY cinsinden tutulur.');
    });

    test('translates a missing transaction', () {
      const failure = NotFoundFailure(
        message: 'That transaction no longer exists.',
        entityType: 'transaction',
      );
      expect(failureMessageFor(tr, failure), 'Bu işlem artık mevcut değil.');
    });

    test('matches the entity type regardless of case', () {
      const failure = NotFoundFailure(
        message: 'That category no longer exists.',
        entityType: 'Category',
      );
      expect(failureMessageFor(tr, failure), 'Bu kategori artık mevcut değil.');
    });

    test('translates the in-use rule of a category', () {
      const failure = ValidationFailure(
        message: 'This category still has transactions.',
        issue: ValidationIssue.categoryInUse,
      );
      expect(
        failureMessageFor(tr, failure),
        'Bu kategori işlemlerde kullanıldığı için silinemez.',
      );
    });

    test('translates the OCR and camera codes', () {
      const noText = OcrFailure(
        message: 'No readable text was found on the receipt.',
        code: OcrFailureCode.noTextFound,
      );
      expect(failureMessageFor(tr, noText), 'Fişte okunabilir metin bulunamadı.');

      const noPermission = CameraFailure(
        message: 'Camera access is required to scan a receipt.',
        code: CameraFailureCode.permissionDenied,
      );
      expect(
        failureMessageFor(tr, noPermission),
        'Fiş taramak için kamera izni gerekli.',
      );
    });

    test('translates a parser failure', () {
      const failure = ParseFailure.amountNotFound(strategy: 'total');
      expect(
        failureMessageFor(tr, failure),
        'Fişte toplam tutar bulunamadı.',
      );
    });

    test('uses the generic message for anything unmodelled', () {
      expect(
        failureMessageFor(tr, StateError('boom')),
        'Bir şeyler ters gitti. Lütfen tekrar deneyin.',
      );
    });
  });
}
