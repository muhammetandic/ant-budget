import 'package:ant_budget/features/receipt_scan/domain/parsing/ascii_folding.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/merchant_brands.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/shop_name_selector.dart';

/// The identity of a shop, reduced to one comparable token.
///
/// The same chain reaches the app in many spellings: the thermal print says
/// `LS SOK MARKETLER TÍC.A.Ş`, the parser keeps `ŞOK`, and a user may have typed
/// `sok market`. Folding the trade name to ASCII gives all of them one key,
/// which is what lets a category chosen for a shop yesterday be found again
/// today.
///
/// The token is the one `MerchantParserStrategy` keeps as the merchant name, so
/// a key computed here and a merchant stored on a transaction agree by
/// construction.
abstract final class MerchantKey {
  static const ShopNameSelector _names = ShopNameSelector();

  /// The folded trade name of [merchantName], or `''` when it holds none.
  static String of(String merchantName) => AsciiFolding.fold(
    MerchantBrands.correct(_names.firstToken(merchantName) ?? ''),
  );
}
