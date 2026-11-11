import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tomadoro/widgets/tomato/focus_composition.dart';
import 'package:tomadoro/widgets/tomato/tomato_clip.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'Cover crop and the visible ground stay aligned with the complete mobile layout',
    () {
      for (final size in [
        const Size(320, 568),
        const Size(320, 640),
        const Size(360, 640),
        const Size(384, 832),
        const Size(448, 997),
        const Size(800, 600),
      ]) {
        for (final scale in [1.0, 1.3]) {
          for (final asset in [
            'morning_greenhouse.png',
            'rainy_greenhouse.png',
            'autumn_garden.png',
            'moonlight.png',
            'winter_cabin.png',
          ]) {
            final spec = FocusBackdropSpec.forAsset('assets/images/$asset');
            final layout = FocusComposition.calculate(
              viewport: size,
              bodyHeight: size.height - 88,
              safeTop: 24,
              backdrop: spec,
              textScale: scale,
            );
            final background = layout.backgroundRect;
            expect(background.left, lessThanOrEqualTo(.001));
            expect(background.top, lessThanOrEqualTo(.001));
            expect(background.right, greaterThanOrEqualTo(size.width - .001));
            expect(background.bottom, greaterThanOrEqualTo(size.height - .001));
            final floorInImage = spec.groundFraction * 1870;
            final floorOnScreen =
                background.top + floorInImage * background.height / 1870;
            expect(layout.ground.dy, closeTo(floorOnScreen, .001));
            expect(
              layout.ringRect.top,
              greaterThanOrEqualTo(
                layout.headerTop + layout.headerHeight + 11.99,
              ),
            );
            expect(
              layout.ringRect.bottom + 8 + layout.footerHeight,
              lessThanOrEqualTo(size.height - 88 + .001),
            );
            expect(
              layout.ground.dy,
              closeTo(layout.ringRect.top + layout.ringRect.height * .85, .001),
            );
          }
        }
      }
    },
  );

  test(
    'Soles and crossed-leg seat touch one floor without clipping gestures or accessories',
    () async {
      final clips = await FocusClips.load(rootBundle);
      try {
        for (final clip in [
          clips.idleBreathe,
          clips.think,
          clips.fixLeaf,
          clips.fidget,
          clips.stretch,
          clips.rebalance,
          clips.sitDown,
          clips.focusBreathe,
          clips.focusComplete,
        ]) {
          final count = (clip.duration.inMicroseconds * 24 / 1000000).round();
          for (var i = 0; i <= count; i++) {
            expect(clip.groundYAt(i / count), closeTo(538.5, .001));
            final progress = i / count;
            final recorder = ui.PictureRecorder();
            TomatoClipPainter(
              clip: clip,
              progress: AlwaysStoppedAnimation(progress),
              glasses: true,
              scarf: true,
              grounded: true,
            ).paint(Canvas(recorder), const Size(300, 300));
            final picture = recorder.endRecording();
            final image = await picture.toImage(300, 300);
            try {
              final pixels = (await image.toByteData(
                format: ui.ImageByteFormat.rawRgba,
              ))!.buffer.asUint8List();
              var bottom = 0;
              var radius = 0.0;
              for (var y = 0; y < 300; y++) {
                for (var x = 0; x < 300; x++) {
                  if (pixels[(y * 300 + x) * 4 + 3] < 96) continue;
                  bottom = math.max(bottom, y);
                  radius = math.max(
                    radius,
                    math.sqrt(
                      math.pow(x + .5 - 150, 2) + math.pow(y + .5 - 150, 2),
                    ),
                  );
                }
              }
              expect(bottom, inInclusiveRange(254, 256));
              expect(
                radius,
                lessThan(136),
                reason:
                    'Leaves, raised hands, glasses and scarf must fit inside the ring.',
              );
            } finally {
              image.dispose();
              picture.dispose();
            }
          }
        }
      } finally {
        clips.dispose();
      }
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
