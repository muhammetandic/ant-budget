/// The vocabulary the merchant parser understands.
///
/// Kept apart from the scoring algorithm so the words a Turkish receipt prints
/// can grow without touching any logic (the same split `AmountKeywords` uses).
abstract final class MerchantKeywords {
  /// Words that disqualify a line: totals, taxes, payment and footer labels.
  ///
  /// Matched against the raw lowercase text, so Turkish spellings are kept.
  static const Set<String> noise = {
    'total',
    'subtotal',
    'tax',
    'vat',
    'kdv',
    'topkdv',
    'change',
    'cash',
    'card',
    'visa',
    'mastercard',
    'credit',
    'debit',
    'receipt',
    'invoice',
    'invoice no',
    'date',
    'time',
    'tel',
    'phone',
    'fax',
    'www',
    'thank you',
    'welcome',
    'fiş',
    'fatura',
    'arsiv',
    'e-arsiv',
    'tarih',
    'saat',
    'toplam',
    'nakit',
    'kart',
    'kredi',
    'müşteri',
    'kasiyer',
    'teşekkür',
    'unvan',
    'belge',
    'mağ',
    'mag',
    'kasa',
    'z no',
    'ekü no',
    'adres',
    'eposta',
    'e-posta',
  };

  /// Corporate words a shop's legal name is almost never without.
  ///
  /// Folded to ASCII, because OCR regularly turns `TİC` into `TÍC`. A product
  /// line rarely carries one, which is what lifts the merchant above them.
  static const Set<String> company = {
    'ticaret',
    'tic',
    'a.s',
    'ltd',
    'limited',
    'sti',
    'market',
    'marketler',
    'supermarket',
    'magaza',
    'magazacilik',
    'magazalar',
    'pazarlama',
    'gida',
    'sanayi',
    'spot',
    'koop',
    'kooperatif',
    'insaat',
    'turizm',
    'tekstil',
    'petrol',
    'otel',
    'lokanta',
    'restoran',
  };

  /// Words that mark a line as an address or a tax registration, not a name.
  static const Set<String> address = {
    'mah',
    'mh',
    'mahalle',
    'sok',
    'sk',
    'sokak',
    'cad',
    'cadde',
    'vkn',
    'tckn',
    'mersis',
    'vd',
    'v.d',
  };
}
