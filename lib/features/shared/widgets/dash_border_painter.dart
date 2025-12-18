import 'package:flutter/cupertino.dart';

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double gapWidth;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.dashWidth = 5.0,
    this.gapWidth = 3.0,
    this.borderRadius = 6.0, // Default radius
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rRect);
    final dashedPath = Path();

    // Total length of the border path
    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      var distance = 0.0;
      while (distance < pathMetric.length) {
        final tangent = pathMetric.getTangentForOffset(distance);
        if (tangent != null) {
          dashedPath.moveTo(tangent.position.dx, tangent.position.dy);
          if (distance + dashWidth < pathMetric.length) {
            final nextTangent =
                pathMetric.getTangentForOffset(distance + dashWidth);
            if (nextTangent != null) {
              dashedPath.lineTo(
                  nextTangent.position.dx, nextTangent.position.dy);
            }
          }
        }
        distance += dashWidth + gapWidth;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
