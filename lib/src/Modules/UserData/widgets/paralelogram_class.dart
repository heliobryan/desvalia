import 'package:flutter/material.dart';

class LeftParallelogramClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double slant = 20;
    final path = Path();
    path.moveTo(slant, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
