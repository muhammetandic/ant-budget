// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get actionAdd => 'Ekle';

  @override
  String get actionCancel => 'Vazgeç';

  @override
  String get actionDelete => 'Sil';

  @override
  String get actionEdit => 'Düzenle';

  @override
  String get actionSave => 'Kaydet';

  @override
  String get actionSeeAll => 'Tümünü gör';

  @override
  String get actionSet => 'Belirle';

  @override
  String get actionTryAgain => 'Tekrar dene';

  @override
  String get navOverview => 'Genel Bakış';

  @override
  String get navTransactions => 'İşlemler';

  @override
  String get navBudget => 'Bütçe';

  @override
  String get navCategories => 'Kategoriler';

  @override
  String get navReports => 'Raporlar';

  @override
  String get dashboardScanTooltip => 'Fiş tara';

  @override
  String get dashboardRecentTransactions => 'Son işlemler';

  @override
  String get summaryIncome => 'Gelir';

  @override
  String get summaryExpenses => 'Gider';

  @override
  String get summaryBalance => 'Bakiye';

  @override
  String get transactionsTitle => 'İşlemler';

  @override
  String get transactionsAddTooltip => 'İşlem ekle';

  @override
  String get transactionsEmpty => 'Bu ay için henüz işlem yok.';

  @override
  String get monthPrevious => 'Önceki ay';

  @override
  String get monthNext => 'Sonraki ay';

  @override
  String get addTransactionTitle => 'İşlem ekle';

  @override
  String get transactionKindExpense => 'Gider';

  @override
  String get transactionKindIncome => 'Gelir';

  @override
  String fieldAmountWithSymbol(String symbol) {
    return 'Tutar ($symbol)';
  }

  @override
  String fieldTotalWithSymbol(String symbol) {
    return 'Toplam ($symbol)';
  }

  @override
  String get fieldCategory => 'Kategori';

  @override
  String get fieldDate => 'Tarih';

  @override
  String get fieldDescriptionOptional => 'Açıklama (isteğe bağlı)';

  @override
  String get fieldMerchant => 'İşyeri';

  @override
  String get validationEnterAmount => 'Geçerli bir tutar girin';

  @override
  String get validationChooseCategory => 'Bir kategori seçin';

  @override
  String get actionSaveTransaction => 'İşlemi kaydet';

  @override
  String get errorEnterAmountAndCategory =>
      'Bir tutar girip bir kategori seçin.';

  @override
  String get errorEnterValidAmount => 'Geçerli bir tutar girin.';

  @override
  String get budgetTitle => 'Bütçe';

  @override
  String get budgetSetMonthlyLimit => 'Aylık limit belirle';

  @override
  String get budgetMonthlyBudget => 'Aylık bütçe';

  @override
  String get budgetNoneSet => 'Bu ay için bütçe belirlenmedi.';

  @override
  String get budgetUpdated => 'Bütçe güncellendi.';

  @override
  String budgetLimitWithSymbol(String symbol) {
    return 'Limit ($symbol)';
  }

  @override
  String budgetOfLimit(String amount) {
    return '$amount limit';
  }

  @override
  String budgetOverBudget(String amount) {
    return 'Bütçe $amount aşıldı';
  }

  @override
  String budgetLeftNearLimit(String amount) {
    return '$amount kaldı — limite yakın';
  }

  @override
  String budgetLeft(String amount) {
    return '$amount kaldı';
  }

  @override
  String get scanTitle => 'Fiş tara';

  @override
  String get scanInstruction =>
      'Fişin tamamı çerçeveye sığsın, sonra deklanşöre dokunun.';

  @override
  String get scanReviewTitle => 'Fişi incele';

  @override
  String get scanReading => 'Fiş okunuyor…';

  @override
  String get transactionUntitled => 'Adsız işlem';

  @override
  String get categoriesTitle => 'Kategoriler';

  @override
  String get categoriesEmpty => 'Henüz kategori yok.';

  @override
  String get categoriesAddTooltip => 'Kategori ekle';

  @override
  String get categoryNewTitle => 'Yeni kategori';

  @override
  String get categoryEditTitle => 'Kategoriyi düzenle';

  @override
  String get categorySaved => 'Kategori kaydedildi.';

  @override
  String get categoryDeleted => 'Kategori silindi.';

  @override
  String get fieldCategoryName => 'Ad';

  @override
  String get fieldCategoryIcon => 'Simge';

  @override
  String get fieldCategoryColor => 'Renk';

  @override
  String categoryUsage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count işlem',
      zero: 'İşlem yok',
    );
    return '$_temp0';
  }

  @override
  String get categoryDeleteTitle => 'Kategori silinsin mi?';

  @override
  String categoryDeleteConfirm(String name) {
    return '$name silinsin mi? Bu işlem geri alınamaz.';
  }

  @override
  String get categoryGroceries => 'Market';

  @override
  String get categoryDining => 'Yemek';

  @override
  String get categoryTransport => 'Ulaşım';

  @override
  String get categoryShopping => 'Alışveriş';

  @override
  String get categoryBills => 'Faturalar';

  @override
  String get categoryHealth => 'Sağlık';

  @override
  String get categoryEntertainment => 'Eğlence';

  @override
  String get categorySalary => 'Maaş';

  @override
  String get categoryOther => 'Diğer';

  @override
  String get reportsTitle => 'Raporlar';

  @override
  String get reportsTotalExpenses => 'Toplam gider';

  @override
  String get reportsByCategory => 'Kategoriye göre giderler';

  @override
  String get reportsByMerchant => 'İşyerine göre giderler';

  @override
  String get reportsNoExpenses => 'Bu ay için gider kaydı yok.';

  @override
  String get reportsNoMerchants => 'İşyeri bilgisi olan gider kaydı yok.';

  @override
  String get reportsUnknownCategory => 'Bilinmeyen kategori';

  @override
  String get reportsOther => 'Diğer';

  @override
  String reportsShare(int value) {
    return '%$value';
  }

  @override
  String reportsTransactions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count işlem',
      zero: 'İşlem yok',
    );
    return '$_temp0';
  }

  @override
  String get errorUnknown => 'Bir şeyler ters gitti. Lütfen tekrar deneyin.';

  @override
  String get errorStorage => 'Yerel veritabanı işlemi tamamlayamadı.';

  @override
  String get errorDevice => 'Cihaz işlemi tamamlayamadı.';

  @override
  String get errorCameraPermission => 'Fiş taramak için kamera izni gerekli.';

  @override
  String get errorCameraUnavailable =>
      'Bu cihazda kullanılabilir bir kamera yok.';

  @override
  String get errorCameraCaptureFailed =>
      'Fotoğraf çekilemedi. Lütfen tekrar deneyin.';

  @override
  String get errorOcrEngineUnavailable => 'Metin tanıma artık kullanılamıyor.';

  @override
  String get errorOcrNoText => 'Fişte okunabilir metin bulunamadı.';

  @override
  String get errorOcrFailed => 'Fiş okunamadı. Lütfen tekrar deneyin.';

  @override
  String get errorParseNoAmount => 'Fişte toplam tutar bulunamadı.';

  @override
  String get errorParseEmpty => 'Taranan fişte okunabilir metin yok.';

  @override
  String get errorTransactionNotFound => 'Bu işlem artık mevcut değil.';

  @override
  String get errorCategoryNotFound => 'Bu kategori artık mevcut değil.';

  @override
  String get errorNotFound => 'İstenen kayıt bulunamadı.';

  @override
  String get errorAmountNotPositive => 'Sıfırdan büyük bir tutar girin.';

  @override
  String get errorCategoryMissing => 'Bu işlem için bir kategori seçin.';

  @override
  String get errorDescriptionTooLong => 'Açıklama çok uzun.';

  @override
  String get errorDateOutOfRange => 'Bu yüzyıla ait bir tarih seçin.';

  @override
  String get errorBudgetNotPositive => 'Aylık bütçe sıfırdan büyük olmalı.';

  @override
  String errorBudgetCurrency(String code) {
    return 'Bütçeler $code cinsinden tutulur.';
  }

  @override
  String get errorCategoryNameEmpty => 'Kategoriye bir ad verin.';

  @override
  String get errorCategoryNameTooLong => 'Ad en fazla 60 karakter olabilir.';

  @override
  String get errorCategoryInUse =>
      'Bu kategori işlemlerde kullanıldığı için silinemez.';
}
