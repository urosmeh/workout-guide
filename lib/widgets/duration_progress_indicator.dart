import 'package:flutter/material.dart';
import 'dart:math' as math;

class DurationProgressIndicator extends CustomPainter {
  DurationProgressIndicator({
    @required this.animation,
    @required this.backgroundColor,
    @required this.barColor,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor;
  final Color barColor;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = barColor;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(covariant DurationProgressIndicator old) {
    return animation.value != old.animation.value ||
        barColor != old.barColor ||
        backgroundColor != old.backgroundColor;
  }
}
