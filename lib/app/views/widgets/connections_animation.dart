import 'dart:math';
import 'package:flutter/material.dart';

class ConnectionsAnimation extends StatefulWidget {
  const ConnectionsAnimation({super.key});

  @override
  _ConnectionsAnimationState createState() => _ConnectionsAnimationState();
}

class _ConnectionsAnimationState extends State<ConnectionsAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: ConnectionsPainter(_controller),
        child: const Center(),
      ),
    );
  }
}

class ConnectionsPainter extends CustomPainter {
  final Animation<double> animation;

  ConnectionsPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = Colors.purple.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw concentric circles
    for (var i = 1; i <= 5; i++) {
      canvas.drawCircle(center, radius * i / 5, paint);
    }

    final dashedPaint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw dashed connecting lines
    final path = Path();
    const double angleStep = 2 * pi / 5;
    final double startAngle = animation.value * 2 * pi;

    for (int i = 0; i < 5; i++) {
      final double angle = startAngle + i * angleStep;
      final double r = radius * (i % 2 == 0 ? 0.6 : 0.8);
      final offset = center + Offset(cos(angle) * r, sin(angle) * r);
      if (i == 0) {
        path.moveTo(offset.dx, offset.dy);
      } else {
        path.lineTo(offset.dx, offset.dy);
      }
    }
    path.close();

    final dashArray = [10.0, 5.0];
    int dashIndex = 0;
    double distance = 0;

    for (final metric in path.computeMetrics()) {
      while (distance < metric.length) {
        final double len = dashArray[dashIndex % 2];
        canvas.drawPath(
          metric.extractPath(distance, distance + len),
          dashedPaint,
        );
        distance += len;
        dashIndex++;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
