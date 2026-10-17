import 'package:ant_budget/features/receipt_scan/domain/parsing/ascii_folding.dart';

/// The spellings OCR produces for the chains common on Turkish receipts.
///
/// Thermal prints and ML Kit mangle the logos around the shop word itself:
/// `ŞOK` arrives as `SOK` or `SSUK`, `BİM` loses its dot, `A101` mixes its
/// `O`s and `0`s. Picking the first word cannot repair a corruption *inside*
/// that word, so the curated catalogue restores the brand spelling. A shop that
/// is not listed is returned untouched, and the review form stays editable.
abstract final class MerchantBrands {
  /// Keyed by the [AsciiFolding]-folded word, so `BİM` and `BIM` share a key.
  static const Map<String, String> _canonicalByFolded = {
    'sok': 'ŞOK',
    'ssuk': 'ŞOK',
    'ssok': 'ŞOK',
    'bim': 'BİM',
    'a101': 'A101',
    'a1o1': 'A101',
    'a1ol': 'A101',
    'a10l': 'A101',
    'aio1': 'A101',
    'migros': 'MİGROS',
  };

  /// [word] with a known chain's spelling restored, or [word] unchanged.
  static String correct(String word) =>
      _canonicalByFolded[AsciiFolding.fold(word)] ?? word;
}
