import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Input of [ScanReceiptUseCase]: the image to recognise.
@immutable
final class ScanReceiptRequest extends Equatable {
  const ScanReceiptRequest({required this.imagePath});

  /// Absolute path of the captured receipt image.
  final String imagePath;

  @override
  List<Object?> get props => [imagePath];
}
