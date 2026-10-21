/// Folds Turkish and accented letters to plain ASCII.
///
/// OCR on old thermal prints mixes scripts (`TÍC`, `Mağazacilik`, `Fatıha`), so
/// keyword vocabularies would otherwise need every accented variant as a
/// separate entry. Folding once lets markers stay ASCII (`tic` still matches
/// the `TÍC` above).
abstract final class AsciiFolding {
  static const Map<String, String> _foldings = {
    'ı': 'i',
    'ş': 's',
    'ğ': 'g',
    'ü': 'u',
    'ö': 'o',
    'ç': 'c',
    'â': 'a',
    'î': 'i',
    'û': 'u',
    'é': 'e',
    'è': 'e',
    'í': 'i',
    'á': 'a',
    'ó': 'o',
    'ú': 'u',
    'ñ': 'n',
    'ï': 'i',
    'ì': 'i',
    'ê': 'e',
    'ô': 'o',
  };

  /// [text] lowercased with every Turkish/accented letter mapped to ASCII.
  ///
  /// Combining marks are dropped, which is what turns the `i` + combining dot
  /// pair that lowercasing `İ` produces (`TİC`) back into a plain `i` (`tic`).
  static String fold(String text) {
    final buffer = StringBuffer();
    for (final rune in text.toLowerCase().runes) {
      if (rune >= _firstCombiningMark && rune <= _lastCombiningMark) continue;
      final char = String.fromCharCode(rune);
      buffer.write(_foldings[char] ?? char);
    }
    return buffer.toString();
  }

  static const int _firstCombiningMark = 0x0300;
  static const int _lastCombiningMark = 0x036F;
}
