import 'package:ant_budget/features/receipt_scan/domain/values/merchant_key.dart';

/// The category the shops of a receipt usually belong to.
///
/// This is only a starting point. A category the user filed the same shop under
/// before wins over this table (`SuggestCategoryUseCase`), and the review screen
/// shows the result in an editable dropdown, so the catalogue stays deliberately
/// short: a shop worth guessing, not every shop in the country.
///
/// Keys are the folded trade names [MerchantKey] produces, which is why `ŞOK`,
/// `SOK` and `SSUK` all arrive here as `sok`: the chain spelling is restored by
/// `MerchantBrands` before the key is computed. The values are the names of the
/// seeded categories, so a category the user renamed or deleted simply stops
/// being suggested.
abstract final class MerchantCategoryRules {
  /// Seeded category name by [MerchantKey] of the shop.
  static const Map<String, String> _categoryByMerchant = {
    // Grocery chains, plus the vocabulary of a neighbourhood grocer.
    'bim': 'Groceries',
    'sok': 'Groceries',
    'a101': 'Groceries',
    'migros': 'Groceries',
    'carrefour': 'Groceries',
    'metro': 'Groceries',
    'hakmar': 'Groceries',
    'tarim': 'Groceries',
    'market': 'Groceries',
    'bakkal': 'Groceries',
    'manav': 'Groceries',
    'kasap': 'Groceries',
    'sarkuteri': 'Groceries',
    'firin': 'Groceries',

    // Eating and drinking out.
    'starbucks': 'Dining out',
    'kahveci': 'Groceries',
    'kafe': 'Dining out',
    'cafe': 'Dining out',
    'restoran': 'Dining out',
    'lokanta': 'Dining out',
    'kebapci': 'Dining out',
    'donerci': 'Dining out',
    'pizzaci': 'Dining out',
    'burger': 'Dining out',
    'mcdonalds': 'Dining out',
    'popeyes': 'Dining out',
    'kfc': 'Dining out',
    'simit': 'Dining out',
    'borek': 'Dining out',
    'pastane': 'Dining out',
    'tatlici': 'Dining out',

    // Fuel, fares and parking.
    'opet': 'Transport',
    'shell': 'Transport',
    'petrol': 'Transport',
    'petrolofisi': 'Transport',
    'aytemiz': 'Transport',
    'akaryakit': 'Transport',
    'istasyon': 'Transport',
    'otopark': 'Transport',
    'taksi': 'Transport',
    'uber': 'Transport',
    'iett': 'Transport',
    'ulasim': 'Transport',
    'metrobus': 'Transport',
    'havaalani': 'Transport',

    // Clothes, electronics and everything else a shop sells.
    'avm': 'Shopping',
    'magaza': 'Shopping',
    'tekstil': 'Shopping',
    'giyim': 'Shopping',
    'ayakkabi': 'Shopping',
    'lcwaikiki': 'Shopping',
    'koton': 'Shopping',
    'defacto': 'Shopping',
    'zara': 'Shopping',
    'decathlon': 'Shopping',
    'ikea': 'Shopping',
    'teknosa': 'Shopping',
    'mediamarkt': 'Shopping',

    // Utilities and telecom bills.
    'elektrik': 'Bills & utilities',
    'dogalgaz': 'Bills & utilities',
    'igdas': 'Bills & utilities',
    'asat': 'Bills & utilities',
    'turkcell': 'Bills & utilities',
    'vodafone': 'Bills & utilities',
    'turktelekom': 'Bills & utilities',
    'ttnet': 'Bills & utilities',
    'superonline': 'Bills & utilities',
    'internet': 'Bills & utilities',

    // Pharmacies, clinics and opticians.
    'eczane': 'Health',
    'eczanesi': 'Health',
    'hastane': 'Health',
    'poliklinik': 'Health',
    'klinik': 'Health',
    'medikal': 'Health',
    'laboratuvar': 'Health',
    'dis': 'Health',
    'optik': 'Health',
    'saglik': 'Health',

    // Cinema, theatre and streaming.
    'sinema': 'Entertainment',
    'cinemaximum': 'Entertainment',
    'tiyatro': 'Entertainment',
    'konser': 'Entertainment',
    'biletix': 'Entertainment',
    'lunapark': 'Entertainment',
    'netflix': 'Entertainment',
    'spotify': 'Entertainment',
    'digiturk': 'Entertainment',
  };

  /// The seeded category name for [merchantName], or `null` when the shop is not
  /// in the catalogue.
  static String? categoryNameFor(String merchantName) =>
      _categoryByMerchant[MerchantKey.of(merchantName)];
}
