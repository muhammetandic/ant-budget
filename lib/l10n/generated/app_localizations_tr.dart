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
  String get actionMore => 'Daha fazla';

  @override
  String get actionLess => 'Daha az';

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
  String get navMore => 'Daha fazla';

  @override
  String get navDebts => 'Borç & Alacak';

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
  String get editTransactionTitle => 'İşlemi düzenle';

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
  String get validationEnterMerchant => 'Bir işyeri girin';

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
  String get budgetByCategory => 'Kategoriye göre bütçe';

  @override
  String get budgetCategoryAdd => 'Kategori bütçesi ekle';

  @override
  String get budgetCategoryNoneSet =>
      'Bu ay için kategori bütçesi belirlenmedi.';

  @override
  String get budgetCategoryDeleteTitle => 'Bütçe silinsin mi?';

  @override
  String budgetCategoryDeleteConfirm(String name) {
    return '$name kategorisi için bu ayın bütçesi silinsin mi?';
  }

  @override
  String get budgetCategoryDeleted => 'Kategori bütçesi silindi.';

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
  String get transactionDeleteTitle => 'İşlem silinsin mi?';

  @override
  String transactionDeleteConfirm(String title) {
    return '$title silinsin mi? Bu işlem geri alınamaz.';
  }

  @override
  String get transactionDeleted => 'İşlem silindi.';

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

  @override
  String get errorPersonEmpty => 'Bir kişi adı girin.';

  @override
  String get errorDebtNotFound => 'Bu borç kaydı artık mevcut değil.';

  @override
  String get debtsTitle => 'Borç & Alacak';

  @override
  String get debtsTooltip => 'Borç & Alacak';

  @override
  String get debtsAddTooltip => 'Borç veya alacak ekle';

  @override
  String get debtsEmpty => 'Henüz borç veya alacak kaydı yok.';

  @override
  String get debtsAll => 'Tümü';

  @override
  String get debtsClaims => 'Alacaklar';

  @override
  String get debtsDebts => 'Borçlar';

  @override
  String get debtsTotalClaims => 'Toplam Alacak';

  @override
  String get debtsTotalDebts => 'Toplam Borç';

  @override
  String get debtsNetBalance => 'Net Durum';

  @override
  String get debtsAddTitle => 'Yeni Borç / Alacak';

  @override
  String get debtsEditTitle => 'Borç / Alacağı Düzenle';

  @override
  String get fieldPerson => 'Kişi';

  @override
  String get debtTypeDebt => 'Borcum (Borç)';

  @override
  String get debtTypeClaim => 'Alacağım (Alacak)';

  @override
  String get debtSettled => 'Ödendi / Kapandı';

  @override
  String get debtPending => 'Bekliyor';

  @override
  String get debtMarkSettled => 'Ödendi olarak işaretle';

  @override
  String get debtMarkPending => 'Bekliyor olarak işaretle';

  @override
  String get validationEnterPerson => 'Bir kişi adı girin';

  @override
  String get navSettings => 'Ayarlar';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsAccountSection => 'Google Hesabı';

  @override
  String settingsAccountSignedIn(Object email) {
    return '$email olarak oturum açık';
  }

  @override
  String get settingsAccountNotSignedIn => 'Oturum açılmamış';

  @override
  String get settingsAccountSignIn => 'Google\'da oturum aç';

  @override
  String get settingsAccountSignOut => 'Çıkış yap';

  @override
  String get settingsAccountSignedInSuccess => 'Başarıyla oturum açıldı';

  @override
  String get settingsAccountSignInFailed =>
      'Oturum açma başarısız. Lütfen tekrar deneyin.';

  @override
  String get settingsBackupSection => 'Google Drive\'a Yedekle';

  @override
  String get settingsBackupSignInRequired =>
      'Yedek alma ve geri yükleme için Google\'da oturum açın.';

  @override
  String get settingsBackupSignInToBackup => 'Yedekleme için oturum aç';

  @override
  String get settingsBackupCreate => 'Şimdi yedek oluştur';

  @override
  String get settingsBackupCreating => 'Yedek oluşturuluyor…';

  @override
  String settingsBackupCreated(Object fileName) {
    return 'Yedek oluşturuldu: $fileName';
  }

  @override
  String get settingsBackupNoBackups =>
      'Henüz yedek yok. İlk yedeğinizi oluşturun.';

  @override
  String get settingsBackupRestore => 'Geri yükle';

  @override
  String get settingsBackupRestoreConfirmTitle => 'Yedek geri yüklensin mi?';

  @override
  String settingsBackupRestoreConfirmMessage(Object fileName) {
    return 'Bu işlem mevcut tüm verilerinizi $fileName yedeğiyle değiştirecek. Bu işlem geri alınamaz.';
  }

  @override
  String get settingsBackupRestored =>
      'Yedek başarıyla geri yüklendi. Lütfen uygulamayı yeniden başlatın.';

  @override
  String get settingsBackupRestoreFailed => 'Geri yükleme başarısız';

  @override
  String get settingsBackupDeleteConfirmTitle => 'Yedek silinsin mi?';

  @override
  String settingsBackupDeleteConfirmMessage(Object fileName) {
    return '$fileName silinsin mi? Bu işlem geri alınamaz.';
  }

  @override
  String get settingsBackupDeleted => 'Yedek silindi.';

  @override
  String get settingsBackupDeleteFailed => 'Yedek silinemedi.';

  @override
  String get settingsAboutSection => 'Hakkında';

  @override
  String get settingsAboutVersion => 'Sürüm';

  @override
  String get settingsAboutPackageName => 'Paket adı';

  @override
  String get settingsAboutDescription =>
      'Ant Budget - Cihaz üzerinde fiş OCR ile AI destekli gider takibi.';
}
