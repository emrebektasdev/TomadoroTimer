import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Landmarks are in the illustration, before cover fitting and cropping.
class FocusBackdropSpec {
  const FocusBackdropSpec(this.asset, this.groundFraction);
  final String asset;
  final double groundFraction;
  static const imageSize = Size(841, 1870);

  static FocusBackdropSpec forAsset(String asset) => FocusBackdropSpec(
    asset,
    asset.endsWith('winter_cabin.png') || asset.endsWith('moonlight.png')
        ? .55
        : .56,
  );
}

class FocusComposition {
  const FocusComposition({
    required this.backgroundRect,
    required this.ringRect,
    required this.headerTop,
    required this.headerHeight,
    required this.timerFont,
    required this.timerHeight,
    required this.captionHeight,
    required this.footerHeight,
    required this.ground,
  });

  final Rect backgroundRect, ringRect;
  final double headerTop, headerHeight, timerFont, timerHeight;
  final double captionHeight, footerHeight;
  final Offset ground;

  static FocusComposition calculate({
    required Size viewport,
    required double bodyHeight,
    required double safeTop,
    required FocusBackdropSpec backdrop,
    double textScale = 1,
  }) {
    final width = math.min(viewport.width, 530.0);
    final compact = (bodyHeight / 740).clamp(.85, 1.0);
    final timerFont = (width * .17).clamp(52.0, 72.0) * compact;
    final timerHeight = timerFont * 1.12;
    final captionHeight = textScale > 1.15 ? 36.0 : 20.0;
    final headerHeight = math.max(60.0, 56 * textScale + 6);
    // Status, timer, description, main action and a reserved reset touch area.
    final footerHeight = 16 + timerHeight + 4 + captionHeight + 10 + 48 + 40;
    final minTop = safeTop + 12 + headerHeight + 14;
    final maxBottom = bodyHeight - footerHeight - 16;
    final diameter = math.min(
      math.min(width * .78, 360.0),
      math.max(80.0, maxBottom - minTop),
    );
    final minGround = minTop + diameter * .85;
    final maxGround = math.max(minGround, maxBottom - diameter * .15);
    final image = FocusBackdropSpec.imageSize;
    final sourceGround = image.height * backdrop.groundFraction;
    final coverScale = math.max(
      viewport.width / image.width,
      viewport.height / image.height,
    );
    final defaultGround =
        (viewport.height - image.height * coverScale) / 2 +
        sourceGround * coverScale;
    final groundY = defaultGround.clamp(minGround, maxGround);
    // Cover plus the minimum extra crop needed on short/large-text screens.
    // The same rectangle paints the background and locates the ground.
    final scale = math.max(
      coverScale,
      math.max(
        groundY / sourceGround,
        (viewport.height - groundY) / (image.height - sourceGround),
      ),
    );
    final imageWidth = image.width * scale;
    final imageHeight = image.height * scale;
    final background = Rect.fromLTWH(
      (viewport.width - imageWidth) / 2,
      groundY - sourceGround * scale,
      imageWidth,
      imageHeight,
    );
    final ring = Rect.fromLTWH(
      (viewport.width - diameter) / 2,
      groundY - diameter * .85,
      diameter,
      diameter,
    );
    final headerTop = (viewport.height * .14).clamp(
      safeTop + 12,
      math.max(safeTop + 12, ring.top - headerHeight - 12),
    );
    return FocusComposition(
      backgroundRect: background,
      ringRect: ring,
      headerTop: headerTop.toDouble(),
      headerHeight: headerHeight,
      timerFont: timerFont,
      timerHeight: timerHeight,
      captionHeight: captionHeight,
      footerHeight: footerHeight,
      ground: Offset(viewport.width / 2, groundY),
    );
  }
}

class FocusBackdrop extends StatelessWidget {
  const FocusBackdrop({
    super.key,
    required this.spec,
    required this.composition,
  });
  final FocusBackdropSpec spec;
  final FocusComposition composition;
  @override
  Widget build(BuildContext context) => ClipRect(
    child: Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fromRect(
          rect: composition.backgroundRect,
          child: Image.asset(
            spec.asset,
            fit: BoxFit.cover,
            excludeFromSemantics: true,
          ),
        ),
      ],
    ),
  );
}

class FocusCompositionScope extends InheritedWidget {
  const FocusCompositionScope({
    super.key,
    required this.composition,
    required super.child,
  });
  final FocusComposition composition;
  static FocusComposition? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<FocusCompositionScope>()
      ?.composition;
  @override
  bool updateShouldNotify(FocusCompositionScope old) =>
      old.composition.ringRect != composition.ringRect ||
      old.composition.backgroundRect != composition.backgroundRect ||
      old.composition.captionHeight != composition.captionHeight;
}
