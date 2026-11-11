import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

typedef _Sprite = ({
  String path,
  String? accessory,
  Offset pivot,
  Offset position,
  Offset scale,
  double rotation,
});

typedef _Socket = ({Offset position, double rotation});
typedef _Frame = ({
  Map<String, _Sprite> sprites,
  List<String> drawOrder,
  _Socket face,
});

typedef _SpriteImage = ({ui.Image image, Rect source, Rect destination});

class FocusClips {
  FocusClips._(
    this.sitDown,
    this.focusBreathe,
    this.idleBreathe,
    this.think,
    this.fixLeaf,
    this.fidget,
    this.stretch,
    this.rebalance,
    this.focusComplete,
    this._images,
  );
  static const _directory = 'preview/sit_down';
  final TomatoClip sitDown;
  final TomatoClip focusBreathe;
  final TomatoClip idleBreathe;
  final TomatoClip think;
  final TomatoClip fixLeaf;
  final TomatoClip fidget;
  final TomatoClip stretch;
  final TomatoClip rebalance;
  final TomatoClip focusComplete;
  final Map<String, _SpriteImage> _images;

  static Future<FocusClips> load(AssetBundle bundle) async {
    final images = <String, _SpriteImage>{};
    Future<TomatoClip> read(String action, {_Socket? accessoryOrigin}) async {
      final data =
          jsonDecode(await bundle.loadString('$_directory/$action.json'))
              as Map<String, dynamic>;
      return TomatoClip._read(data, action, images, accessoryOrigin);
    }

    final sitDown = await read('sit_down');
    final focusBreathe = await read(
      'focus_breathe',
      accessoryOrigin: sitDown._accessoryOrigin,
    );
    final idleBreathe = await read(
      'idle_breathe',
      accessoryOrigin: sitDown._accessoryOrigin,
    );
    final think = await read(
      'think',
      accessoryOrigin: sitDown._accessoryOrigin,
    );
    final fixLeaf = await read(
      'fix_leaf',
      accessoryOrigin: sitDown._accessoryOrigin,
    );
    final fidget = await read(
      'fidget',
      accessoryOrigin: sitDown._accessoryOrigin,
    );
    final stretch = await read(
      'stretch',
      accessoryOrigin: sitDown._accessoryOrigin,
    );
    final rebalance = await read(
      'rebalance',
      accessoryOrigin: sitDown._accessoryOrigin,
    );
    final focusComplete = await read(
      'focus_complete',
      accessoryOrigin: sitDown._accessoryOrigin,
    );
    final paths = {
      ...sitDown._imagePaths,
      ...focusBreathe._imagePaths,
      ...idleBreathe._imagePaths,
      ...think._imagePaths,
      ...fixLeaf._imagePaths,
      ...fidget._imagePaths,
      ...stretch._imagePaths,
      ...rebalance._imagePaths,
      ...focusComplete._imagePaths,
    };
    const atlasDirectory = 'assets/animations/focus';
    final atlas =
        jsonDecode(await bundle.loadString('$atlasDirectory/atlas.json'))
            as Map<String, dynamic>;
    if (atlas['schemaVersion'] != 1)
      throw const FormatException('Unsupported focus atlas');
    final sprites = atlas['sprites'] as Map<String, dynamic>;
    final pages = (atlas['pages'] as List).cast<String>();
    final neededPages = <int>{};
    for (final path in paths) {
      final region = sprites[path] as Map<String, dynamic>?;
      if (region == null) throw FormatException('Missing focus sprite: $path');
      neededPages.add(region['page'] as int);
    }
    final decoded = <int, ui.Image>{};
    Rect rect(List<dynamic> v) => Rect.fromLTWH(
      (v[0] as num).toDouble(),
      (v[1] as num).toDouble(),
      (v[2] as num).toDouble(),
      (v[3] as num).toDouble(),
    );
    try {
      // Cropped, pre-sized regions share a few GPU textures instead of
      // allocating a transparent full-canvas texture for every baked frame.
      await Future.wait(
        neededPages.map((page) async {
          final bytes = await bundle.load('$atlasDirectory/${pages[page]}');
          final codec = await ui.instantiateImageCodec(
            bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
            allowUpscaling: false,
          );
          try {
            decoded[page] = (await codec.getNextFrame()).image;
          } finally {
            codec.dispose();
          }
        }),
      );
      for (final path in paths) {
        final region = sprites[path] as Map<String, dynamic>;
        images[path] = (
          image: decoded[region['page']]!,
          source: rect(region['source']),
          destination: rect(region['destination']),
        );
      }
    } catch (_) {
      for (final image in decoded.values) {
        image.dispose();
      }
      rethrow;
    }

    return FocusClips._(
      sitDown,
      focusBreathe,
      idleBreathe,
      think,
      fixLeaf,
      fidget,
      stretch,
      rebalance,
      focusComplete,
      images,
    );
  }

  void dispose() {
    for (final image in _images.values.map((region) => region.image).toSet()) {
      image.dispose();
    }
  }
}

class TomatoClip {
  TomatoClip._(
    this.duration,
    this._fps,
    this._size,
    this._frames,
    this._images,
    this._accessoryOrigin,
    this._blendArmOrder, [
    this._transitionFrom,
  ]);

  final Duration duration;
  final double _fps;
  final Size _size;
  final List<_Frame> _frames;
  final Map<String, _SpriteImage> _images;
  final _Socket _accessoryOrigin;
  final bool _blendArmOrder;
  final _Frame? _transitionFrom;

  /// Retain the exact visible sample, then settle into the completion pose.
  /// Deformed PNGs blend in canvas space; shared rigid parts interpolate their
  /// transforms, including the accessory sockets.
  TomatoClip transitionTo(TomatoClip next, double progress) => TomatoClip._(
    const Duration(milliseconds: 240),
    _fps,
    _size,
    [next._frames.first],
    _images,
    _accessoryOrigin,
    false,
    _sample(progress),
  );

  _Frame _sample(double progress) =>
      _frames[(progress *
              duration.inMicroseconds *
              _fps /
              Duration.microsecondsPerSecond)
          .round()
          .clamp(0, _frames.length - 1)];

  Set<String> get _imagePaths => {
    for (final frame in _frames)
      for (final sprite in frame.sprites.values) sprite.path,
  };

  static TomatoClip _read(
    Map<String, dynamic> data,
    String action,
    Map<String, _SpriteImage> images,
    _Socket? accessoryOrigin,
  ) {
    if (data['schemaVersion'] != 1 || data['action'] != action) {
      throw FormatException('Unsupported $action export');
    }
    final canvas = data['canvas'] as Map<String, dynamic>;
    final size = Size(_number(canvas['widthPx']), _number(canvas['heightPx']));
    final parts = data['parts'] as Map<String, dynamic>;
    final frames = [
      for (final frame in data['frames'] as List)
        _readFrame(frame as Map<String, dynamic>, parts),
    ];
    return TomatoClip._(
      Duration(
        microseconds:
            (_number(data['durationSeconds']) * Duration.microsecondsPerSecond)
                .round(),
      ),
      _number(data['fps']),
      size,
      frames,
      images,
      accessoryOrigin ?? frames.first.face,
      action == 'fix_leaf',
    );
  }

  static _Frame _readFrame(
    Map<String, dynamic> frame,
    Map<String, dynamic> parts,
  ) {
    final samples = frame['parts'] as Map<String, dynamic>;
    final face = frame['sockets']['FACE_SOCKET'] as Map<String, dynamic>;
    final order = (frame['drawOrder'] as List).cast<String>();
    return (
      sprites: {
        for (final id in order) id: _readSprite(parts[id], samples[id]),
      },
      drawOrder: order,
      face: (
        position: _offset(face['positionPx']),
        rotation: _number(face['rotationRad']),
      ),
    );
  }

  static _Sprite _readSprite(
    Map<String, dynamic> part,
    Map<String, dynamic> sample,
  ) {
    final baked = sample['bakedPng'] as String?;
    return (
      path: baked ?? part['png'] as String,
      accessory: part['accessory'] as String?,
      pivot: baked == null ? _offset(part['sourcePivotPx']) : Offset.zero,
      position: baked == null ? _offset(sample['positionPx']) : Offset.zero,
      scale: baked == null ? _offset(sample['scale']) : const Offset(1, 1),
      rotation: baked == null ? _number(sample['rotationRad']) : 0,
    );
  }

  static double _number(Object? value) => (value as num).toDouble();

  static Offset _offset(List<dynamic> pair) =>
      Offset(_number(pair[0]), _number(pair[1]));
}

class TomatoClipPainter extends CustomPainter {
  TomatoClipPainter({
    required this.clip,
    required this.progress,
    required this.glasses,
    required this.scarf,
    this.otherAccessory,
  }) : super(repaint: progress);

  final TomatoClip clip;
  final Animation<double> progress;
  final bool glasses;
  final bool scarf;
  final CustomPainter? otherAccessory;

  @override
  void paint(Canvas canvas, Size size) {
    final sampledFrame =
        (progress.value *
                clip.duration.inMicroseconds *
                clip._fps /
                Duration.microsecondsPerSecond)
            .clamp(0.0, clip._frames.length - 1.0);
    final frame = clip._frames[sampledFrame.round()];
    final transition = clip._transitionFrom;
    final mix = Curves.easeInOut.transform(progress.value.clamp(0.0, 1.0));

    canvas.save();
    canvas.scale(
      size.width / clip._size.width,
      size.height / clip._size.height,
    );
    final before = clip._frames[sampledFrame.floor()].drawOrder;
    final after = clip._frames[sampledFrame.ceil()].drawOrder;
    if (transition != null) {
      if (mix == 0) {
        _paintSprites(canvas, transition, transition.drawOrder);
      } else if (mix == 1) {
        _paintSprites(canvas, frame, frame.drawOrder);
      } else {
        for (final id in frame.drawOrder) {
          final a = transition.sprites[id]!;
          final b = frame.sprites[id]!;
          if (a.path == b.path) {
            _paintSprite(canvas, (
              path: a.path,
              accessory: a.accessory,
              pivot: Offset.lerp(a.pivot, b.pivot, mix)!,
              position: Offset.lerp(a.position, b.position, mix)!,
              scale: Offset.lerp(a.scale, b.scale, mix)!,
              rotation: a.rotation + (b.rotation - a.rotation) * mix,
            ));
          } else {
            // Add premultiplied layers so opaque pixels stay opaque while
            // blending the two deformed silhouettes.
            final bounds = Offset.zero & clip._size;
            canvas.saveLayer(bounds, Paint());
            canvas.saveLayer(
              bounds,
              Paint()..color = Colors.white.withValues(alpha: 1 - mix),
            );
            _paintSprite(canvas, a);
            canvas.restore();
            canvas.saveLayer(
              bounds,
              Paint()
                ..color = Colors.white.withValues(alpha: mix)
                ..blendMode = BlendMode.plus,
            );
            _paintSprite(canvas, b);
            canvas.restore();
            canvas.restore();
          }
        }
      }
    } else if (clip._blendArmOrder &&
        before.indexOf('Kol_Sag') != after.indexOf('Kol_Sag')) {
      // Composite the same pose in both depth orders. Only visibility blends,
      // so the baked arm keeps one position and silhouette throughout.
      final fraction = sampledFrame - sampledFrame.floor();
      final bounds = Offset.zero & clip._size;
      canvas.saveLayer(bounds, Paint());
      canvas.saveLayer(
        bounds,
        Paint()..color = Colors.white.withValues(alpha: 1 - fraction),
      );
      _paintSprites(canvas, frame, before);
      canvas.restore();
      canvas.saveLayer(
        bounds,
        Paint()
          ..color = Colors.white.withValues(alpha: fraction)
          ..blendMode = BlendMode.plus,
      );
      _paintSprites(canvas, frame, after);
      canvas.restore();
      canvas.restore();
    } else {
      _paintSprites(canvas, frame, frame.drawOrder);
    }

    final accessory = otherAccessory;
    if (accessory != null) {
      final origin = clip._accessoryOrigin;
      final facePosition = transition == null
          ? frame.face.position
          : Offset.lerp(transition.face.position, frame.face.position, mix)!;
      final faceRotation = transition == null
          ? frame.face.rotation
          : transition.face.rotation +
                (frame.face.rotation - transition.face.rotation) * mix;
      canvas.translate(facePosition.dx, facePosition.dy);
      canvas.rotate(faceRotation - origin.rotation);
      canvas.translate(-origin.position.dx, -origin.position.dy);
      accessory.paint(canvas, clip._size);
    }
    canvas.restore();
  }

  void _paintSprites(Canvas canvas, _Frame frame, List<String> order) {
    for (final id in order) {
      _paintSprite(canvas, frame.sprites[id]!);
    }
  }

  void _paintSprite(Canvas canvas, _Sprite sprite) {
    if (sprite.accessory == 'gozluk' && !glasses ||
        sprite.accessory == 'atki' && !scarf) {
      return;
    }
    final image = clip._images[sprite.path]!;
    canvas.save();
    canvas.translate(sprite.position.dx, sprite.position.dy);
    canvas.rotate(sprite.rotation);
    canvas.scale(sprite.scale.dx, sprite.scale.dy);
    canvas.drawImageRect(
      image.image,
      image.source,
      image.destination.shift(-sprite.pivot),
      Paint()..filterQuality = FilterQuality.medium,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(TomatoClipPainter oldDelegate) =>
      clip != oldDelegate.clip ||
      progress != oldDelegate.progress ||
      glasses != oldDelegate.glasses ||
      scarf != oldDelegate.scarf ||
      otherAccessory != oldDelegate.otherAccessory;
}
