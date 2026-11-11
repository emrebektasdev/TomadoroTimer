import 'dart:ui' as ui;

import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tomadoro/widgets/tomato/focus_progress_ring.dart';

Future<int> alphaAt(double progress, double glow, int x, int y) async {
  final recorder = ui.PictureRecorder();
  FocusProgressPainter(
    progress,
    AlwaysStoppedAnimation(glow),
  ).paint(Canvas(recorder), const Size(220, 220));
  final picture = recorder.endRecording();
  final image = await picture.toImage(220, 220);
  try {
    final bytes = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
    return bytes.getUint8((y * 220 + x) * 4 + 3);
  } finally {
    image.dispose();
    picture.dispose();
  }
}

Future<int> colorAt(double progress, int x, int y) async {
  final recorder = ui.PictureRecorder();
  FocusProgressPainter(
    progress,
    const AlwaysStoppedAnimation(0.0),
  ).paint(Canvas(recorder), const Size(220, 220));
  final picture = recorder.endRecording();
  final image = await picture.toImage(220, 220);
  try {
    final bytes = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
    final i = (y * 220 + x) * 4;
    return (bytes.getUint8(i) << 16) |
        (bytes.getUint8(i + 1) << 8) |
        bytes.getUint8(i + 2);
  } finally {
    image.dispose();
    picture.dispose();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Quarter progress begins at twelve and fills clockwise', () async {
    expect(await colorAt(.25, 110, 9), 0x9d393c);
    expect(await colorAt(.25, 211, 110), 0x9d393c);
    expect(await colorAt(.25, 110, 211), 0xead8bd);
    expect(await colorAt(.25, 9, 110), 0xead8bd);
    expect(await colorAt(1, 9, 110), 0x9d393c);
    expect(await colorAt(1, 110, 211), 0x9d393c);
  });

  test('Completion halo fades away while the full ring remains', () async {
    expect(await alphaAt(1, .5, 110, 2), greaterThan(0));
    expect(await alphaAt(1, 1, 110, 2), 0);
    expect(await alphaAt(.5, .5, 110, 2), 0);
  });
}
