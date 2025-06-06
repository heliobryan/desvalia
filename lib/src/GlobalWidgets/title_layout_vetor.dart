import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class TitleVetor extends CustomPainter {
  final String text;
  TitleVetor(this.text);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0XFFA6B92E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path = Path()
      ..moveTo(30, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width - 30, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);

    final textPainter = TextPainter(
      text: TextSpan(
          text: text,
          style: secondFont.bold(color: Colors.white, fontSize: 25)),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );

    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
