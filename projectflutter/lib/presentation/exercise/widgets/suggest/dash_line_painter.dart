import 'package:flutter/material.dart';

class DashedLinePainter extends CustomPainter {
  final double dashHeight;
  final double dashSpacing;
  final Color color;

  DashedLinePainter({
    this.dashHeight = 5,
    this.dashSpacing = 4,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;

    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
