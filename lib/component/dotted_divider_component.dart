import 'package:flutter/material.dart';

class DottedDivider extends StatelessWidget {
  final Color color;
  final double height;
  final double thickness;
  final double dashLength;
  final double dashGap;

  const DottedDivider({
    super.key,
    this.color = Colors.grey,
    this.height = 1.0,
    this.thickness = 1.0,
    this.dashLength = 5.0,
    this.dashGap = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        size: Size(double.infinity, height),
        painter: DottedPainter(
            color.withOpacity(0.4), thickness, dashLength, dashGap),
      ),
    );
  }
}

class DottedPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final double dashLength;
  final double dashGap;

  DottedPainter(
    this.color,
    this.thickness,
    this.dashLength,
    this.dashGap,
  );

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    double startX = 0.0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashLength, size.height / 2),
        paint,
      );
      startX += dashLength + dashGap;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
