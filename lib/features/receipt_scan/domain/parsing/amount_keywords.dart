/// The vocabulary the amount parser understands.
///
/// Kept apart from the selection algorithm so the words a Turkish or English
/// receipt prints can grow without touching any logic.
abstract final class AmountKeywords {
  /// Labels marking the line that holds the amount actually paid.
  static const Set<String> total = {
    'total',
    'grand total',
    'total amount',
    'total due',
    'amount due',
    'balance due',
    'net total',
    'to pay',
    'to be paid',
    'toplam',
    'genel toplam',
    'toplam tutar',
    'net toplam',
    'hesap toplamı',
    'ödenecek',
    'ödenecek tutar',
  };

  /// Labels marking amounts that are *not* the payable total.
  ///
  /// Deliberately excludes anything that merely *summarises* money (subtotal,
  /// tax, discount, change, points) plus the identifier lines a receipt always
  /// carries, whose numbers must never be mistaken for a price.
  static const Set<String> excluded = {
    // Subtotals and taxes.
    'subtotal',
    'sub total',
    'ara toplam',
    'tax',
    'vat',
    'kdv',
    'vergi',
    // Discounts, refunds, gratuities.
    'discount',
    'indirim',
    'iskonto',
    'iade',
    'refund',
    'tip',
    'bahşiş',
    'service',
    'servis',
    // Loyalty and coupons.
    'loyalty',
    'points',
    'puan',
    'kupon',
    'bonus',
    // Non monetary bookkeeping printed on every receipt.
    'change',
    'para üstü',
    'komisyon',
    'commission',
    'adet',
    'quantity',
    'taksit',
    'installment',
    'fis no',
    'fiş no',
    'arsiv no',
    'arşiv no',
    'belge no',
    'irsaliye',
    'kasa',
    'z no',
    'eft',
    'pos',
    'terminal',
    'döviz',
    'kur',
  };
}
