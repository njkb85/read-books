import 'package:flutter/material.dart';

class ReadLogo extends StatelessWidget {
  final double size;
  
  const ReadLogo({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(size * 0.1),
        border: Border.all(color: Colors.white, width: size * 0.025),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size * 0.6,
            height: size * 0.3,
            child: CustomPaint(painter: _GeometricCrownPainter()),
          ),
          SizedBox(height: size * 0.03),
          SizedBox(
            width: size * 0.38,
            height: size * 0.38,
            child: CustomPaint(painter: _RuneRPainter()),
          ),
        ],
      ),
    );
  }
}

class _GeometricCrownPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.height * 0.07
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()..color = Colors.white..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    final path = Path();
    path.moveTo(w * 0.0, h * 1.0);
    path.lineTo(w * 0.0, h * 0.5);
    path.lineTo(w * 0.15, h * 0.05);
    path.lineTo(w * 0.3, h * 0.4);
    path.lineTo(w * 0.5, h * 0.0);
    path.lineTo(w * 0.7, h * 0.4);
    path.lineTo(w * 0.85, h * 0.05);
    path.lineTo(w * 1.0, h * 0.5);
    path.lineTo(w * 1.0, h * 1.0);
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawCircle(Offset(w * 0.15, h * 0.05), h * 0.05, fillPaint);
    canvas.drawCircle(Offset(w * 0.5, h * 0.0), h * 0.05, fillPaint);
    canvas.drawCircle(Offset(w * 0.85, h * 0.05), h * 0.05, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RuneRPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.15
      ..strokeCap = StrokeCap.square
      ..strokeJoin = StrokeJoin.miter;

    final w = size.width;
    final h = size.height;

    final path = Path();
    // Palo vertical
    path.moveTo(w * 0.25, h * 0.05);
    path.lineTo(w * 0.25, h * 0.95);
    // Brazo superior (horizontal-descendente)
    path.moveTo(w * 0.25, h * 0.05);
    path.lineTo(w * 0.85, h * 0.3);
    // Pierna (desde el centro hacia abajo-derecha)
    path.moveTo(w * 0.4, h * 0.45);
    path.lineTo(w * 0.85, h * 0.85);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
