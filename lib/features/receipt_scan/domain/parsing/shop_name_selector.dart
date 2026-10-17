/// Picks the shop name out of the line the merchant parser selected.
///
/// A receipt prints the trade name first and the legal tail after it
/// (`TAHTAKALE SPOT Mağazacilik san . Tic.A.5`), while OCR adds stray fragments
/// lifted from the logo before it (`LS SOK MARKETLER`). The shop name is
/// therefore the first token that can actually *be* a name: at least three
/// characters and containing a letter, which drops logo junk like `LS`, bare
/// labels like `NO`, and store numbers like `8718`.
final class ShopNameSelector {
  const ShopNameSelector();

  static final RegExp _separator = RegExp(r'[^0-9A-Za-zÇĞİÖŞÜçğıöşü]+');
  static final RegExp _letter = RegExp(r'[A-Za-zÇĞİÖŞÜçğıöşü]');

  /// The first name-worthy token of [line], or `null` when it holds none.
  String? firstToken(String line) {
    for (final token in line.split(_separator)) {
      if (token.length < 3) continue;
      if (!_letter.hasMatch(token)) continue;
      return token;
    }
    return null;
  }
}
