import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'cozy_scene.dart';

class FocusProgressRing extends StatelessWidget {
  const FocusProgressRing({
    super.key,
    required this.progress,
    required this.glow,
    required this.child,
    this.label = 'Odak ilerlemesi',
  });

  final double progress;
  final Animation<double> glow;
  final Widget child;
  final String label;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    value: '${(progress.clamp(0.0, 1.0) * 100).round()}%',
    child: SizedBox.square(
      dimension: 220,
      child: CustomPaint(
        painter: FocusProgressPainter(progress, glow),
        child: Center(child: child),
      ),
    ),
  );
}

class FocusProgressPainter extends CustomPainter {
  FocusProgressPainter(this.progress, this.glow) : super(repaint: glow);

  final double progress;
  final Animation<double> glow;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = (Offset.zero & size).deflate(9);
    final pulse = math.sin(math.pi * glow.value).clamp(0.0, 1.0);
    if (pulse > 0 && progress >= 1) {
      canvas.drawOval(
        bounds,
        Paint()
          ..color = const Color(0xffffdc89).withValues(alpha: .42 * pulse)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5 + 4 * pulse
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
    }
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawOval(bounds, paint..color = sage.withValues(alpha: .18));
    canvas.drawArc(
      bounds,
      -math.pi / 2,
      math.pi * 2 * progress.clamp(0.0, 1.0),
      false,
      paint..color = Color.lerp(sage, const Color(0xffd7aa50), .3 * pulse)!,
    );
  }

  @override
  bool shouldRepaint(FocusProgressPainter oldDelegate) =>
      progress != oldDelegate.progress || glow != oldDelegate.glow;
}
