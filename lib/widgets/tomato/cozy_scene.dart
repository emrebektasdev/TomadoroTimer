import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'tomato_clip.dart';

const parchment = Color(0xfffff8ed);
const ink = Color(0xff492c30);
const sage = Color(0xff566e46);
const berry = Color(0xff9d393c);

class GardenHeading extends StatelessWidget {
  final String eyebrow, title;
  final Color? foreground;
  final bool fitTitle;
  const GardenHeading(
    this.eyebrow,
    this.title, {
    super.key,
    this.foreground,
    this.fitTitle = false,
  });
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        eyebrow,
        style: TextStyle(
          fontSize: 11,
          letterSpacing: 2.2,
          fontWeight: FontWeight.w700,
          color: foreground ?? sage,
        ),
      ),
      const SizedBox(height: 5),
      if (fitTitle)
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: _title(),
        )
      else
        _title(),
    ],
  );

  Widget _title() => Text(
    title,
    maxLines: fitTitle ? 1 : null,
    style: TextStyle(
      fontFamily: 'serif',
      fontWeight: FontWeight.w700,
      fontSize: 32,
      color: foreground ?? ink,
      height: 1.15,
    ),
  );
}

enum GardenPose { ready, focus, rest, harvest }

class CozyScene extends StatelessWidget {
  final GardenPose pose;
  final String? accessory;
  final bool showBackground;
  final String backgroundAsset;
  final Alignment backgroundAlignment;
  final bool grounded;
  final ({
    TomatoClip clip,
    Animation<double> progress,
    bool glasses,
    bool scarf,
  })?
  motion;

  const CozyScene({
    super.key,
    required this.pose,
    this.accessory,
    this.showBackground = true,
    this.backgroundAsset = 'assets/images/windowsill.webp',
    this.backgroundAlignment = Alignment.bottomCenter,
    this.motion,
    this.grounded = false,
  });
  @override
  Widget build(BuildContext context) => grounded
      ? _groundedScene()
      : ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: LayoutBuilder(
            builder: (context, box) {
              final size = math.min(box.maxHeight * .78, box.maxWidth * .58);
              final clip = motion;
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  if (showBackground)
                    Positioned.fill(
                      child: Image.asset(
                        backgroundAsset,
                        fit: BoxFit.cover,
                        alignment: backgroundAlignment,
                        excludeFromSemantics: true,
                      ),
                    ),
                  if (pose == GardenPose.rest)
                    const Positioned.fill(
                      child: ColoredBox(color: Color(0x326f906b)),
                    ),
                  Positioned(
                    bottom: box.maxHeight * .085,
                    child: Container(
                      width: size * .59,
                      height: size * .075,
                      decoration: BoxDecoration(
                        color: const Color(0x426c452a),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: box.maxHeight * .07,
                    child: clip != null
                        ? SizedBox.square(
                            dimension: size,
                            child: RepaintBoundary(
                              child: CustomPaint(
                                painter: TomatoClipPainter(
                                  clip: clip.clip,
                                  progress: clip.progress,
                                  glasses: clip.glasses,
                                  scarf: clip.scarf,
                                  otherAccessory:
                                      accessory == null ||
                                          accessory == 'acc_sunglasses' ||
                                          accessory == 'acc_scarf'
                                      ? null
                                      : _Wearable(accessory!, GardenPose.focus),
                                ),
                                child: Semantics(
                                  image: true,
                                  label: 'Domates maskotu',
                                ),
                              ),
                            ),
                          )
                        : TweenAnimationBuilder<double>(
                            key: ValueKey(pose),
                            duration: Duration(
                              milliseconds:
                                  MediaQuery.disableAnimationsOf(context)
                                  ? 0
                                  : 650,
                            ),
                            tween: Tween(begin: 0, end: 1),
                            builder: (context, value, child) =>
                                Transform.translate(
                                  offset: Offset(
                                    0,
                                    pose == GardenPose.harvest
                                        ? -16 * math.sin(value * math.pi)
                                        : 0,
                                  ),
                                  child: Transform.rotate(
                                    angle: pose == GardenPose.ready
                                        ? 0.06 * math.sin(2 * math.pi * value)
                                        : 0,
                                    child: child,
                                  ),
                                ),
                            child: SizedBox.square(
                              dimension: size,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(
                                    'assets/images/${pose.name}.png',
                                    semanticLabel: 'Domates maskotu',
                                    gaplessPlayback: true,
                                  ),
                                  if (accessory != null)
                                    CustomPaint(
                                      painter: _Wearable(accessory!, pose),
                                    ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        );

  Widget _groundedScene() => LayoutBuilder(
    builder: (context, box) {
      final clip = motion;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: box.maxWidth * .25,
            top: box.maxHeight * .85 + 2 - box.maxWidth * .0275,
            child: Container(
              key: const ValueKey('focus-ground-shadow'),
              width: box.maxWidth * .5,
              height: box.maxWidth * .055,
              decoration: BoxDecoration(
                color: const Color(0x35704a2c),
                borderRadius: BorderRadius.all(
                  Radius.elliptical(box.maxWidth * .25, box.maxWidth * .0275),
                ),
                boxShadow: const [
                  BoxShadow(color: Color(0x18745338), blurRadius: 7),
                ],
              ),
            ),
          ),
          if (clip != null)
            Positioned.fill(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: TomatoClipPainter(
                    clip: clip.clip,
                    progress: clip.progress,
                    glasses: clip.glasses,
                    scarf: clip.scarf,
                    grounded: true,
                    otherAccessory:
                        accessory == null ||
                            accessory == 'acc_sunglasses' ||
                            accessory == 'acc_scarf'
                        ? null
                        : _Wearable(accessory!, GardenPose.focus),
                  ),
                  child: Semantics(image: true, label: 'Domates maskotu'),
                ),
              ),
            ),
        ],
      );
    },
  );
}

class _Wearable extends CustomPainter {
  final String id;
  final GardenPose pose;
  _Wearable(this.id, this.pose);
  @override
  void paint(Canvas c, Size size) {
    c.scale(size.width / 100);
    final y = pose == GardenPose.rest
        ? 51.0
        : pose == GardenPose.harvest
        ? 44.0
        : 45.0;
    final p = Paint()
      ..color = ink
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    switch (id) {
      case 'acc_sunglasses':
        c.drawCircle(Offset(40, y), 9, p);
        c.drawCircle(Offset(61, y), 9, p);
        c.drawLine(Offset(49, y), Offset(52, y), p);
        c.drawLine(Offset(31, y - 1), Offset(21, y - 4), p);
        c.drawLine(Offset(70, y - 1), Offset(78, y - 4), p);
      case 'acc_headphones':
        c.drawArc(
          const Rect.fromLTWH(19, 12, 62, 78),
          math.pi,
          math.pi,
          false,
          p..strokeWidth = 4,
        );
        p
          ..style = PaintingStyle.fill
          ..color = sage;
        for (final x in [16.0, 78.0]) {
          c.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(x, 46, 7, 17),
              const Radius.circular(4),
            ),
            p,
          );
        }
      case 'acc_scarf':
        p
          ..color = sage
          ..strokeWidth = 6;
        c.drawPath(
          Path()
            ..moveTo(30, 72)
            ..quadraticBezierTo(50, 85, 70, 72),
          p,
        );
        c.drawLine(const Offset(62, 78), const Offset(67, 86), p);
      default:
        final symbol = {
          'acc_hat': '🎩',
          'acc_crown': '👑',
          'acc_eyepatch': '●',
          'acc_bowtie': '🎀',
        }[id];
        if (symbol == null) return;
        final text = TextPainter(
          text: TextSpan(
            text: symbol,
            style: const TextStyle(fontSize: 23, color: ink),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        text.paint(
          c,
          Offset(
            id == 'acc_eyepatch' ? 30 : 50 - text.width / 2,
            id == 'acc_bowtie'
                ? 68
                : id == 'acc_eyepatch'
                ? y - 12
                : 1,
          ),
        );
    }
  }

  @override
  bool shouldRepaint(_Wearable old) => id != old.id || pose != old.pose;
}

class LeafBranch extends CustomPainter {
  final double progress;
  LeafBranch(this.progress);
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final y = size.height * .58;
    canvas.drawLine(
      Offset(4, y),
      Offset(size.width - 4, y),
      p..color = const Color(0xffdfd4c4),
    );
    final end = 4 + (size.width - 8) * progress.clamp(0.0, 1.0);
    canvas.drawLine(Offset(4, y), Offset(end, y), p..color = sage);
    for (double x = 5; x <= end; x += 17) {
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(-.6);
      canvas.drawOval(const Rect.fromLTWH(0, -4, 10, 5), p);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(LeafBranch old) => old.progress != progress;
}
