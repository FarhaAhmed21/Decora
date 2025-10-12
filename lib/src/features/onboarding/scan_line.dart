import 'package:flutter/material.dart';

class ScanLinePainter extends CustomPainter {
  ScanLinePainter(this.position);
  final double position;
  @override
  void paint(Canvas canvas, Size size) {
    final double y = size.height * position;

    final Paint shadowPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 30)
      ..strokeWidth = 30
      ..style = PaintingStyle.stroke;

    final Paint glowPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 20)
      ..strokeWidth = 15
      ..style = PaintingStyle.stroke;

    final Paint scanPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final Path pathLine = Path()
      ..moveTo(10, y)
      ..quadraticBezierTo(size.width / 2, y + 6, size.width - 10, y);

    canvas.drawPath(pathLine, shadowPaint);
    canvas.drawPath(pathLine, glowPaint);
    canvas.drawPath(pathLine, scanPaint);
  }

  @override
  bool shouldRepaint(_) => true;
}
