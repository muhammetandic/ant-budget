import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Painter of the expense donut: one arc per slice, starting at twelve o'clock
/// and running clockwise, with a small gap between neighbours.
///
/// Drawn by hand rather than pulled from a charting package: a donut is a few
/// arcs, the app gains no dependency, and the widget around this painter decides
/// what the screen reader hears — a chart library can only report what it was
/// handed.
class DonutPainter extends CustomPainter {
  const DonutPainter({
    required this.values,
    required this.colors,
    required this.strokeWidth,
    this.gap = 3,
  });

  /// Size of every slice, in any unit: only the ratio between them matters.
  final List<double> values;

  /// Colour of each slice, index aligned with [values].
  final List<Color> colors;

  /// Thickness of the ring, in logical pixels.
  final double strokeWidth;

  /// Space left between two slices, in logical pixels.
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold<double>(0, (sum, value) => sum + value);
    final radius = math.min(size.width, size.height) / 2 - strokeWidth / 2;
    if (total <= 0 || radius <= 0) return;

    final center = size.center(Offset.zero);
    final gapAngle = gap / radius;
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    var angle = -math.pi / 2;
    for (var i = 0; i < values.length; i++) {
      final value = values[i];
      final sweep = value <= 0 ? 0 : value / total * 2 * math.pi;
      if (sweep > 0) {
        // A gap must never swallow a thin slice, so it keeps at least half of
        // its own angle.
        final drawn = math.max(sweep - gapAngle, sweep / 2);
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          angle + (sweep - drawn) / 2,
          drawn,
          false,
          ring..color = colors[i % colors.length],
        );
      }
      angle += sweep;
    }
  }

  @override
  bool shouldRepaint(DonutPainter oldDelegate) =>
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.gap != gap ||
      !listEquals(oldDelegate.values, values) ||
      !listEquals(oldDelegate.colors, colors);
}
