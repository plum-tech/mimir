import 'dart:ui';
import 'package:flutter/widgets.dart';

class DashDecoration extends Decoration {
  final Set<LinePosition> borders;
  final Shape shape;
  final Color color;
  final BorderRadius? borderRadius;
  final List<int> dash;
  final double strokeWidth;

  const DashDecoration({
    this.borders = const {},
    this.shape = Shape.line,
    this.color = const Color(0xFF9E9E9E),
    this.borderRadius,
    this.dash = const <int>[5, 5],
    this.strokeWidth = 1,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _DashPainter(
      shape: shape,
      borders: borders,
      color: color,
      borderRadius: borderRadius,
      dash: dash,
      strokeWidth: strokeWidth,
    );
  }
}

class _DashPainter extends BoxPainter {
  final Set<LinePosition> borders;
  final Shape shape;
  final Color color;
  final BorderRadius borderRadius;
  final List<int> dash;
  final double strokeWidth;

  _DashPainter({
    required this.shape,
    required this.borders,
    required this.color,
    BorderRadius? borderRadius,
    required this.dash,
    required this.strokeWidth,
  }) : borderRadius = borderRadius ?? BorderRadius.circular(0);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    Path outPath = Path();
    if (shape == Shape.line) {
      for (final border in borders) {
        if (border == LinePosition.left) {
          outPath.moveTo(offset.dx, offset.dy);
          outPath.lineTo(offset.dx, offset.dy + configuration.size!.height);
        } else if (border == LinePosition.top) {
          outPath.moveTo(offset.dx, offset.dy);
          outPath.lineTo(offset.dx + configuration.size!.width, offset.dy);
        } else if (border == LinePosition.right) {
          outPath.moveTo(offset.dx + configuration.size!.width, offset.dy);
          outPath.lineTo(offset.dx + configuration.size!.width, offset.dy + configuration.size!.height);
        } else {
          outPath.moveTo(offset.dx, offset.dy + configuration.size!.height);
          outPath.lineTo(offset.dx + configuration.size!.width, offset.dy + configuration.size!.height);
        }
      }
    } else if (shape == Shape.box) {
      RRect rect = RRect.fromLTRBAndCorners(
        offset.dx,
        offset.dy,
        offset.dx + configuration.size!.width,
        offset.dy + configuration.size!.height,
        bottomLeft: borderRadius.bottomLeft,
        bottomRight: borderRadius.bottomRight,
        topLeft: borderRadius.topLeft,
        topRight: borderRadius.topRight,
      );
      outPath.addRRect(rect);
    } else if (shape == Shape.circle) {
      outPath.addOval(Rect.fromLTWH(offset.dx, offset.dy, configuration.size!.width, configuration.size!.height));
    }

    PathMetrics metrics = outPath.computeMetrics(forceClosed: false);
    Path drawPath = Path();

    for (PathMetric me in metrics) {
      double totalLength = me.length;
      int index = -1;

      for (double start = 0; start < totalLength;) {
        double to = start + dash[(++index) % dash.length];
        to = to > totalLength ? totalLength : to;
        bool isEven = index % 2 == 0;
        if (isEven) {
          drawPath.addPath(me.extractPath(start, to, startWithMoveTo: true), Offset.zero);
        }
        start = to;
      }
    }

    canvas.drawPath(
        drawPath,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth);
  }
}

enum LinePosition { left, top, right, bottom }

enum Shape { line, box, circle }
