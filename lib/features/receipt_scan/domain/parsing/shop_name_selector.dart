import 'package:ant_budget/features/receipt_scan/domain/parsing/merchant_brands.dart';

/// Picks the shop name out of the line the merchant parser selected.
///
/// A receipt prints the trade name first and the legal tail after it
/// (`TAHTAKALE SPOT Mağazacilik san . Tic.A.5`), while OCR adds stray fragments
/// lifted from the logo before it (`LS SOK MARKETLER`). The name is therefore
/// built from the tokens that can actually *be* a name: at least three
/// characters and containing a letter, which drops logo junk like `LS`, bare
/// labels like `NO`, and store numbers like `8718`.
///
/// How many of those tokens the name keeps depends on the shop:
///
/// * A chain the catalogue knows (`MerchantBrands`) collapses to its single
///   brand word — `LS SOK MARKETLER TIC.A.S` is just `ŞOK`, because the rest of
///   the line is the branch or a legal tail.
/// * Any other shop keeps up to [maxWords] name-worthy words. Its trade name is
///   usually spread over several (`TAHTAKALE SPOT Mağazacilik`) and one token on
///   its own is not enough for the user to recognise the shop.
final class ShopNameSelector {
  const ShopNameSelector();

  /// How many words the name of an unrecognised shop may contain.
  static const int maxWords = 3;

  static final RegExp _separator = RegExp(r'[^0-9A-Za-zÇĞİÖŞÜçğıöşü]+');
  static final RegExp _letter = RegExp(r'[A-Za-zÇĞİÖŞÜçğıöşü]');

  /// The shop name printed on [line], or `null` when it holds none.
  ///
  /// Known chains win over the surrounding words: a token may match the
  /// catalogue anywhere among the kept words, so `ANTALYA SOK MARKET` still
  /// becomes `ŞOK`.
  String? nameFor(String line) {
    final tokens = _nameTokens(line);
    if (tokens.isEmpty) return null;
    for (final token in tokens) {
      final brand = MerchantBrands.canonicalOf(token);
      if (brand != null) return brand;
    }
    return tokens.join(' ');
  }

  /// The first name-worthy token of [line], or `null` when it holds none.
  ///
  /// This is the shop's identity for the merchant key: one token that stays the
  /// same whether the stored name has one word or three.
  String? firstToken(String line) {
    final tokens = _nameTokens(line);
    return tokens.isEmpty ? null : tokens.first;
  }

  List<String> _nameTokens(String line) {
    final tokens = <String>[];
    for (final token in line.split(_separator)) {
      if (token.length < 3) continue;
      if (!_letter.hasMatch(token)) continue;
      tokens.add(token);
      if (tokens.length == maxWords) break;
    }
    return tokens;
  }
}
