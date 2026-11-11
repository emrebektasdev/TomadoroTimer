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
    this.strokeWidth,
    this.foreground = berry,
    this.track = const Color(0xffead8bd),
  });

  final double progress;
  final Animation<double> glow;
  final Widget child;
  final String label;
  final double? strokeWidth;
  final Color foreground, track;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    value: '${(progress.clamp(0.0, 1.0) * 100).round()}%',
    child: SizedBox.square(
      dimension: 220,
      child: CustomPaint(
        painter: FocusProgressPainter(
          progress,
          glow,
          strokeWidth: strokeWidth,
          foreground: foreground,
          track: track,
        ),
        child: Center(child: child),
      ),
    ),
  );
}

class FocusProgressPainter extends CustomPainter {
  FocusProgressPainter(
    this.progress,
    this.glow, {
    this.strokeWidth,
    this.foreground = berry,
    this.track = const Color(0xffead8bd),
  }) : super(repaint: glow);

  final double progress;
  final Animation<double> glow;
  final double? strokeWidth;
  final Color foreground, track;

  @override
  void paint(Canvas canvas, Size size) {
    final width = strokeWidth ?? (size.shortestSide * .03).clamp(7.0, 10.0);
    final bounds = (Offset.zero & size).deflate(width / 2 + 5);
    final pulse = math.sin(math.pi * glow.value).clamp(0.0, 1.0);
    if (pulse > 0 && progress >= 1) {
      canvas.drawOval(
        bounds,
        Paint()
          ..color = const Color(0xffffdc89).withValues(alpha: .42 * pulse)
          ..style = PaintingStyle.stroke
          ..strokeWidth = width + 4 * pulse
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
    }
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;
    canvas.drawOval(bounds, paint..color = track);
    canvas.drawArc(
      bounds,
      -math.pi / 2,
      math.pi * 2 * progress.clamp(0.0, 1.0),
      false,
      paint..color = foreground,
    );
  }

  @override
  bool shouldRepaint(FocusProgressPainter oldDelegate) =>
      progress != oldDelegate.progress ||
      glow != oldDelegate.glow ||
      strokeWidth != oldDelegate.strokeWidth ||
      foreground != oldDelegate.foreground ||
      track != oldDelegate.track;
}
