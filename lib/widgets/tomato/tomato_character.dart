import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/models/tomato_state.dart';
import '../../core/theme/app_colors.dart';

/// A premium, ultra-smooth animated tomato character mascot for Tomadoro.
/// Features 3D vector shading, cute expressiveness, smooth continuous floating/breathing animations,
/// organic arm swaying, eye blinking, interactive tap squash-and-stretch reactions, and loot sparkles.
class TomatoCharacter extends StatefulWidget {
  final TomatoState state;
  final double progress; // 0.0 to 1.0
  final String? accessory;
  final VoidCallback? onTap;
  final bool isCollectible;
  final double size;
  final bool useImageAssets;

  const TomatoCharacter({
    super.key,
    required this.state,
    required this.progress,
    this.accessory,
    this.onTap,
    this.isCollectible = false,
    this.size = 200,
    this.useImageAssets = true,
  });

  @override
  State<TomatoCharacter> createState() => _TomatoCharacterState();
}

class _TomatoCharacterState extends State<TomatoCharacter>
    with TickerProviderStateMixin {
  // Animation Controllers
  late AnimationController _breatheController;
  late AnimationController _bounceController;
  late AnimationController _glowController;
  late AnimationController _collectibleController;
  late AnimationController _blinkController;
  late AnimationController _armController;
  late AnimationController _sparkleController;
  late AnimationController _tapController;

  // Animations
  late Animation<double> _breatheScaleAnimation;
  late Animation<double> _floatYAnimation;
  late Animation<double> _wobbleRotationAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _collectibleAnimation;
  late Animation<double> _blinkAnimation;
  late Animation<double> _armAnimation;
  late Animation<double> _sparkleRotationAnimation;

  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();

    // 1. Gentle Floating & Breathing Animation (Continuous Loop)
    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    _breatheScaleAnimation = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOutSine),
    );
    _floatYAnimation = Tween<double>(begin: 0.0, end: -12.0).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOutSine),
    );
    _wobbleRotationAnimation = Tween<double>(begin: -0.04, end: 0.04).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOutSine),
    );
    _breatheController.repeat(reverse: true);

    // 2. Continuous Magic Sparkle Orbit Animation (Loot Vibe)
    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );
    _sparkleRotationAnimation = Tween<double>(begin: 0.0, end: math.pi * 2).animate(
      CurvedAnimation(parent: _sparkleController, curve: Curves.linear),
    );
    _sparkleController.repeat();

    // 3. Bounce Animation for State Transitions
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    // 4. Glow Animation for Collectible / Completed State
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _glowAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // 5. Collectible Jump (Victory Bounce)
    _collectibleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _collectibleAnimation = Tween<double>(begin: 0.0, end: -26.0).animate(
      CurvedAnimation(parent: _collectibleController, curve: Curves.easeInOut),
    );

    // 6. Blink Animation (Periodic Cute Eye Blink)
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _blinkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );

    _blinkController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _blinkController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _scheduleNextBlink();
      }
    });
    _scheduleNextBlink();

    // 7. Arm Wave Animation
    _armController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _armAnimation = Tween<double>(
      begin: 0.0,
      end: math.pi * 6,
    ).animate(CurvedAnimation(parent: _armController, curve: Curves.easeInOutSine));

    _armController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _armController.reset();
        _scheduleNextWave();
      }
    });
    _scheduleNextWave();

    // 8. Tap Reaction Controller (Juicy Squash & Stretch)
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    if (widget.isCollectible) {
      _glowController.repeat(reverse: true);
      _collectibleController.repeat(reverse: true);
    }
  }

  void _scheduleNextBlink() {
    if (!mounted) return;
    final delay = Duration(milliseconds: 2200 + _random.nextInt(3500));
    Future.delayed(delay, () {
      if (mounted && !_blinkController.isAnimating) {
        _blinkController.forward();
      }
    });
  }

  void _scheduleNextWave() {
    if (!mounted) return;
    final delay = Duration(milliseconds: 4000 + _random.nextInt(8000));
    Future.delayed(delay, () {
      if (mounted && !_armController.isAnimating) {
        _armController.forward();
      }
    });
  }

  void _handleTap() {
    _tapController.forward(from: 0.0);
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  @override
  void didUpdateWidget(TomatoCharacter oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.state != widget.state) {
      _bounceController.forward(from: 0.0);
    }

    if (widget.isCollectible && !oldWidget.isCollectible) {
      _glowController.repeat(reverse: true);
      _collectibleController.repeat(reverse: true);
    } else if (!widget.isCollectible && oldWidget.isCollectible) {
      _glowController.stop();
      _glowController.reset();
      _collectibleController.stop();
      _collectibleController.reset();
    }
  }

  @override
  void dispose() {
    _breatheController.dispose();
    _sparkleController.dispose();
    _bounceController.dispose();
    _glowController.dispose();
    _collectibleController.dispose();
    _blinkController.dispose();
    _armController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  // Smooth Color Interpolation for Unripe -> Half Ripe -> Ripe
  Color _getTomatoBaseColor() {
    if (widget.progress <= 0.5) {
      return Color.lerp(
        const Color(0xFF7CB342), // Fresh Unripe Green
        const Color(0xFFFF8F00), // Golden Amber Half-Ripe
        widget.progress * 2,
      )!;
    } else {
      return Color.lerp(
        const Color(0xFFFF8F00), // Golden Amber Half-Ripe
        const Color(0xFFE53935), // Vibrant Premium Red
        (widget.progress - 0.5) * 2,
      )!;
    }
  }

  Color _getTomatoHighlightColor() {
    if (widget.progress <= 0.5) {
      return Color.lerp(
        const Color(0xFFAED581),
        const Color(0xFFFFC107),
        widget.progress * 2,
      )!;
    } else {
      return Color.lerp(
        const Color(0xFFFFC107),
        const Color(0xFFFF8A80),
        (widget.progress - 0.5) * 2,
      )!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final effectiveSize = widget.size < (screenWidth * 0.4)
        ? screenWidth * 0.45
        : widget.size;

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _breatheController,
          _sparkleController,
          _bounceAnimation,
          _glowAnimation,
          _collectibleAnimation,
          _blinkAnimation,
          _armAnimation,
          _tapController,
        ]),
        builder: (context, child) {
          final floatY = widget.isCollectible
              ? _collectibleAnimation.value
              : _floatYAnimation.value;

          final scale = _breatheScaleAnimation.value;
          final rotation = widget.isCollectible ? 0.0 : _wobbleRotationAnimation.value;

          // Tap squash-and-stretch math
          final tapProgress = _tapController.value;
          final squashX = 1.0 + (math.sin(tapProgress * math.pi) * 0.12);
          final squashY = 1.0 - (math.sin(tapProgress * math.pi) * 0.10);

          return Transform.translate(
            offset: Offset(0, floatY),
            child: Transform.rotate(
              angle: rotation,
              child: Transform.scale(
                scaleX: scale * squashX,
                scaleY: scale * squashY,
                child: Container(
                  width: effectiveSize,
                  height: effectiveSize,
                  decoration: widget.isCollectible
                      ? BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accentGold.withValues(
                                alpha: 0.5 * _glowAnimation.value,
                              ),
                              blurRadius: 35 + (20 * _glowAnimation.value),
                              spreadRadius: 12 * _glowAnimation.value,
                            ),
                          ],
                        )
                      : null,
                  child: _buildPremiumTomato(
                    effectiveSize,
                    _floatYAnimation.value,
                    _sparkleRotationAnimation.value,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build ultra-premium painted tomato character
  Widget _buildPremiumTomato(double size, double floatY, double sparkleAngle) {
    final center = Offset(size / 2, size / 2 + size * 0.05);
    final radius = size * 0.42;

    // Anchor points for accessories
    final eyeY = center.dy - radius * 0.06;
    final eyeAnchor = Offset(center.dx, eyeY);
    final headAnchor = Offset(center.dx, center.dy - radius * 0.92);
    final bodyAnchor = Offset(center.dx, center.dy + radius * 0.48);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 1. Dynamic Soft Floor Shadow (Expands & contracts with floating height)
        Positioned(
          bottom: size * 0.02,
          left: size * 0.15,
          right: size * 0.15,
          height: size * 0.12,
          child: CustomPaint(
            painter: _FloorShadowPainter(
              floatOffset: floatY,
              size: size,
            ),
          ),
        ),

        // 2. The Main Mascot Body (3D Vector Character)
        Positioned.fill(
          child: CustomPaint(
            painter: PremiumTomatoPainter(
              baseColor: _getTomatoBaseColor(),
              highlightColor: _getTomatoHighlightColor(),
              progress: widget.progress,
              isCollectible: widget.isCollectible,
              blinkAmount: _blinkAnimation.value,
              armWavePhase: _armAnimation.value,
              sparkleAngle: sparkleAngle,
            ),
          ),
        ),

        // 3. Accessory Layer (Perfectly Anchored)
        if (widget.accessory != null)
          _buildAlignedAccessory(
            widget.accessory!,
            size,
            headAnchor,
            eyeAnchor,
            bodyAnchor,
          ),
      ],
    );
  }

  Widget _buildAlignedAccessory(
    String accessory,
    double size,
    Offset headAnchor,
    Offset eyeAnchor,
    Offset bodyAnchor,
  ) {
    final accessorySize = size * 0.4;
    Widget accessoryWidget;
    Offset anchorPoint;
    double width;
    double height;

    switch (accessory) {
      case 'sunglasses':
        width = accessorySize * 1.25;
        height = accessorySize * 0.48;
        accessoryWidget = CustomPaint(
          size: Size(width, height),
          painter: SunglassesPainter(),
        );
        anchorPoint = eyeAnchor;
        break;
      case 'eyepatch':
        width = size;
        height = accessorySize * 0.48;
        accessoryWidget = CustomPaint(
          size: Size(width, height),
          painter: EyepatchPainter(),
        );
        anchorPoint = eyeAnchor;
        break;
      case 'crown':
        width = accessorySize * 1.15;
        height = accessorySize * 0.65;
        accessoryWidget = CustomPaint(
          size: Size(width, height),
          painter: CrownPainter(),
        );
        anchorPoint = Offset(headAnchor.dx, headAnchor.dy - (height * 0.32));
        break;
      case 'tophat':
        width = accessorySize * 1.35;
        height = accessorySize * 1.05;
        accessoryWidget = CustomPaint(
          size: Size(width, height),
          painter: TopHatPainter(),
        );
        anchorPoint = Offset(headAnchor.dx, headAnchor.dy - (height * 0.42));
        break;
      case 'headphones':
        width = size * 0.98;
        height = size * 0.72;
        accessoryWidget = CustomPaint(
          size: Size(width, height),
          painter: HeadphonesPainter(),
        );
        anchorPoint = Offset(headAnchor.dx, headAnchor.dy + (height * 0.38));
        break;
      case 'bowtie':
        width = accessorySize * 0.85;
        height = accessorySize * 0.42;
        accessoryWidget = CustomPaint(
          size: Size(width, height),
          painter: BowtiePainter(),
        );
        anchorPoint = bodyAnchor;
        break;
      default:
        return const SizedBox.shrink();
    }

    return Positioned(
      left: anchorPoint.dx - (width / 2),
      top: anchorPoint.dy - (height / 2),
      width: width,
      height: height,
      child: accessoryWidget,
    );
  }
}

/// Dynamic Soft Floor Shadow Painter
class _FloorShadowPainter extends CustomPainter {
  final double floatOffset; // Negative when floating up
  final double size;

  _FloorShadowPainter({required this.floatOffset, required this.size});

  @override
  void paint(Canvas canvas, Size size) {
    // Normalize float offset (0 to 12)
    final floatRatio = (-floatOffset / 14.0).clamp(0.0, 1.0);

    final width = size.width * (0.65 - (floatRatio * 0.12));
    final height = size.height * (0.35 - (floatRatio * 0.08));

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.18 - (floatRatio * 0.08))
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8.0 + (floatRatio * 4.0));

    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: width, height: height),
      shadowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _FloorShadowPainter oldDelegate) {
    return oldDelegate.floatOffset != floatOffset;
  }
}

/// Masterpiece 3D-Vector Custom Painter for the Tomato Mascot Character
class PremiumTomatoPainter extends CustomPainter {
  final Color baseColor;
  final Color highlightColor;
  final double progress;
  final bool isCollectible;
  final double blinkAmount;
  final double armWavePhase;
  final double sparkleAngle;

  PremiumTomatoPainter({
    required this.baseColor,
    required this.highlightColor,
    required this.progress,
    required this.isCollectible,
    required this.blinkAmount,
    required this.armWavePhase,
    required this.sparkleAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + size.height * 0.04);
    final radius = size.width * 0.39;

    // Outline colors
    final bodyOutlinePaint = Paint()
      ..color = Color.lerp(baseColor, const Color(0xFF4A0000), 0.55)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.065
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final leafOutlinePaint = Paint()
      ..color = const Color(0xFF1E3D14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.06
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // 1. Draw Cute Shoes & Legs
    _drawCuteLegsAndShoes(canvas, center, radius, baseColor, bodyOutlinePaint, leafOutlinePaint);

    // 2. Draw Left Arm (Gentle Idle Rest)
    _drawLeftArm(canvas, center, radius, baseColor, bodyOutlinePaint);

    // 3. Draw Right Arm (Smooth Waving Motion)
    canvas.save();
    final rightShoulder = Offset(center.dx + radius * 0.82, center.dy + radius * 0.15);
    canvas.translate(rightShoulder.dx, rightShoulder.dy);
    final armRotation = -math.pi / 5 + math.sin(armWavePhase) * 0.32;
    canvas.rotate(armRotation);
    canvas.translate(-rightShoulder.dx, -rightShoulder.dy);
    _drawRightArm(canvas, rightShoulder, radius, baseColor, bodyOutlinePaint);
    canvas.restore();

    // 4. Draw Plump 3D Tomato Body
    _draw3DPlumpBody(canvas, center, radius, baseColor, highlightColor, bodyOutlinePaint);

    // 5. Draw Multi-Layer Stem & 5-Star Leaf Crown
    _draw3DStemAndCrown(canvas, center, radius, leafOutlinePaint);

    // 6. Draw Expressive Cute Face (Anime eyes, Blush, Mouth)
    _drawCuteExpressiveFace(canvas, center, radius);

    // 7. Draw Magic Orbiting Loot Sparkles
    _drawLootSparkles(canvas, center, radius, sparkleAngle);
  }

  void _drawCuteLegsAndShoes(
    Canvas canvas,
    Offset center,
    double radius,
    Color bodyColor,
    Paint bodyOutline,
    Paint leafOutline,
  ) {
    final legFillPaint = Paint()
      ..color = Color.lerp(bodyColor, Colors.black, 0.15)!
      ..style = PaintingStyle.fill;

    final shoeUpperPaint = Paint()
      ..color = const Color(0xFF4CAF50) // Bright Leaf Green Shoes
      ..style = PaintingStyle.fill;

    final shoeSolePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final legYTop = center.dy + radius * 0.75;
    final legYBottom = center.dy + radius * 1.05;
    final legWidth = radius * 0.20;

    // --- Left Leg & Shoe ---
    final leftLegX = center.dx - radius * 0.28;
    final leftLegRect = Rect.fromLTRB(
      leftLegX - legWidth / 2,
      legYTop,
      leftLegX + legWidth / 2,
      legYBottom,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(leftLegRect, Radius.circular(legWidth * 0.4)),
      legFillPaint,
    );
    canvas.drawLine(
      Offset(leftLegRect.left, legYTop),
      Offset(leftLegRect.left, legYBottom),
      bodyOutline,
    );
    canvas.drawLine(
      Offset(leftLegRect.right, legYTop),
      Offset(leftLegRect.right, legYBottom),
      bodyOutline,
    );

    // Left Shoe
    final leftShoeCenter = Offset(leftLegX - radius * 0.08, legYBottom + radius * 0.06);
    final leftShoeRect = Rect.fromCenter(
      center: leftShoeCenter,
      width: radius * 0.44,
      height: radius * 0.24,
    );
    final leftShoeRRect = RRect.fromRectAndCorners(
      leftShoeRect,
      topLeft: Radius.circular(radius * 0.16),
      topRight: Radius.circular(radius * 0.16),
      bottomLeft: Radius.circular(radius * 0.10),
      bottomRight: Radius.circular(radius * 0.10),
    );
    canvas.drawRRect(leftShoeRRect, shoeUpperPaint);
    canvas.drawRRect(leftShoeRRect, leafOutline);

    // Left Shoe White Sole
    final leftSoleRect = Rect.fromLTRB(
      leftShoeRect.left + 1,
      leftShoeRect.bottom - radius * 0.06,
      leftShoeRect.right - 1,
      leftShoeRect.bottom,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(leftSoleRect, Radius.circular(radius * 0.04)),
      shoeSolePaint,
    );

    // --- Right Leg & Shoe ---
    final rightLegX = center.dx + radius * 0.28;
    final rightLegRect = Rect.fromLTRB(
      rightLegX - legWidth / 2,
      legYTop,
      rightLegX + legWidth / 2,
      legYBottom,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rightLegRect, Radius.circular(legWidth * 0.4)),
      legFillPaint,
    );
    canvas.drawLine(
      Offset(rightLegRect.left, legYTop),
      Offset(rightLegRect.left, legYBottom),
      bodyOutline,
    );
    canvas.drawLine(
      Offset(rightLegRect.right, legYTop),
      Offset(rightLegRect.right, legYBottom),
      bodyOutline,
    );

    // Right Shoe
    final rightShoeCenter = Offset(rightLegX + radius * 0.08, legYBottom + radius * 0.06);
    final rightShoeRect = Rect.fromCenter(
      center: rightShoeCenter,
      width: radius * 0.44,
      height: radius * 0.24,
    );
    final rightShoeRRect = RRect.fromRectAndCorners(
      rightShoeRect,
      topLeft: Radius.circular(radius * 0.16),
      topRight: Radius.circular(radius * 0.16),
      bottomLeft: Radius.circular(radius * 0.10),
      bottomRight: Radius.circular(radius * 0.10),
    );
    canvas.drawRRect(rightShoeRRect, shoeUpperPaint);
    canvas.drawRRect(rightShoeRRect, leafOutline);

    // Right Shoe White Sole
    final rightSoleRect = Rect.fromLTRB(
      rightShoeRect.left + 1,
      rightShoeRect.bottom - radius * 0.06,
      rightShoeRect.right - 1,
      rightShoeRect.bottom,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rightSoleRect, Radius.circular(radius * 0.04)),
      shoeSolePaint,
    );
  }

  void _drawLeftArm(
    Canvas canvas,
    Offset center,
    double radius,
    Color bodyColor,
    Paint bodyOutline,
  ) {
    final fillPaint = Paint()
      ..color = bodyColor
      ..style = PaintingStyle.fill;

    final path = Path();
    final shoulder = Offset(center.dx - radius * 0.82, center.dy + radius * 0.18);
    path.moveTo(shoulder.dx, shoulder.dy);
    path.quadraticBezierTo(
      center.dx - radius * 1.25,
      center.dy + radius * 0.45,
      center.dx - radius * 1.05,
      center.dy + radius * 0.85,
    );
    path.quadraticBezierTo(
      center.dx - radius * 0.85,
      center.dy + radius * 0.95,
      center.dx - radius * 0.72,
      center.dy + radius * 0.75,
    );
    path.quadraticBezierTo(
      center.dx - radius * 0.90,
      center.dy + radius * 0.45,
      shoulder.dx,
      shoulder.dy,
    );

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, bodyOutline);
  }

  void _drawRightArm(
    Canvas canvas,
    Offset shoulder,
    double radius,
    Color bodyColor,
    Paint bodyOutline,
  ) {
    final fillPaint = Paint()
      ..color = bodyColor
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(shoulder.dx, shoulder.dy);
    path.quadraticBezierTo(
      shoulder.dx + radius * 0.42,
      shoulder.dy - radius * 0.25,
      shoulder.dx + radius * 0.62,
      shoulder.dy - radius * 0.48,
    );
    path.quadraticBezierTo(
      shoulder.dx + radius * 0.72,
      shoulder.dy - radius * 0.68,
      shoulder.dx + radius * 0.42,
      shoulder.dy - radius * 0.82,
    );
    path.quadraticBezierTo(
      shoulder.dx + radius * 0.18,
      shoulder.dy - radius * 0.68,
      shoulder.dx - radius * 0.08,
      shoulder.dy - radius * 0.38,
    );

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, bodyOutline);
  }

  void _draw3DPlumpBody(
    Canvas canvas,
    Offset center,
    double radius,
    Color baseColor,
    Color highlightColor,
    Paint bodyOutline,
  ) {
    final darkShadowColor = Color.lerp(baseColor, const Color(0xFF380000), 0.58)!;

    // 3D Radial Gradient Fill
    final bodyGradientPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.35, -0.40),
        radius: 0.92,
        colors: [
          highlightColor,
          baseColor,
          darkShadowColor,
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    // Draw Chubby Squishy Tomato Body Shape
    final bodyPath = Path();
    bodyPath.moveTo(center.dx, center.dy - radius * 0.94);
    bodyPath.cubicTo(
      center.dx + radius * 0.75,
      center.dy - radius * 1.05,
      center.dx + radius * 1.08,
      center.dy - radius * 0.30,
      center.dx + radius * 1.02,
      center.dy + radius * 0.30,
    );
    bodyPath.cubicTo(
      center.dx + radius * 0.95,
      center.dy + radius * 0.95,
      center.dx - radius * 0.95,
      center.dy + radius * 0.95,
      center.dx - radius * 1.02,
      center.dy + radius * 0.30,
    );
    bodyPath.cubicTo(
      center.dx - radius * 1.08,
      center.dy - radius * 0.30,
      center.dx - radius * 0.75,
      center.dy - radius * 1.05,
      center.dx,
      center.dy - radius * 0.94,
    );

    // Draw Main Body Fill & Outline
    canvas.drawPath(bodyPath, bodyGradientPaint);
    canvas.drawPath(bodyPath, bodyOutline);

    // Specular Highlight Oval (Top-Left Gloss)
    final glossPath = Path();
    glossPath.addOval(
      Rect.fromCenter(
        center: Offset(center.dx - radius * 0.38, center.dy - radius * 0.42),
        width: radius * 0.42,
        height: radius * 0.24,
      ),
    );

    final glossPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.65),
          Colors.white.withValues(alpha: 0.05),
        ],
      ).createShader(glossPath.getBounds());

    canvas.save();
    canvas.rotate(-0.35);
    canvas.drawPath(glossPath, glossPaint);
    canvas.restore();
  }

  void _draw3DStemAndCrown(
    Canvas canvas,
    Offset center,
    double radius,
    Paint leafOutline,
  ) {
    final leafGreenLight = const Color(0xFF7CB342);
    final leafGreenDark = const Color(0xFF33691E);
    final stemBaseY = center.dy - radius * 0.88;

    // --- Curved 3D Stem ---
    final stemPath = Path();
    stemPath.moveTo(center.dx - radius * 0.06, stemBaseY);
    stemPath.cubicTo(
      center.dx - radius * 0.08,
      center.dy - radius * 1.22,
      center.dx + radius * 0.06,
      center.dy - radius * 1.38,
      center.dx + radius * 0.16,
      center.dy - radius * 1.34,
    );
    stemPath.cubicTo(
      center.dx + radius * 0.18,
      center.dy - radius * 1.25,
      center.dx + radius * 0.04,
      center.dy - radius * 1.15,
      center.dx + radius * 0.04,
      stemBaseY,
    );

    final stemGradient = LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [leafGreenLight, leafGreenDark],
    ).createShader(stemPath.getBounds());

    canvas.drawPath(stemPath, Paint()..shader = stemGradient);
    canvas.drawPath(stemPath, leafOutline);

    // Tiny Sprout Leaf on Stem Top
    final sproutPath = Path();
    sproutPath.moveTo(center.dx + radius * 0.12, center.dy - radius * 1.30);
    sproutPath.quadraticBezierTo(
      center.dx + radius * 0.28,
      center.dy - radius * 1.45,
      center.dx + radius * 0.32,
      center.dy - radius * 1.32,
    );
    sproutPath.quadraticBezierTo(
      center.dx + radius * 0.22,
      center.dy - radius * 1.25,
      center.dx + radius * 0.12,
      center.dy - radius * 1.30,
    );
    canvas.drawPath(sproutPath, Paint()..color = leafGreenLight);
    canvas.drawPath(sproutPath, leafOutline);

    // --- 5-Leaf Star Crown ---
    void drawCrownLeaf(Offset tip, Offset ctrlLeft, Offset ctrlRight) {
      final leafPath = Path();
      leafPath.moveTo(center.dx, stemBaseY);
      leafPath.quadraticBezierTo(ctrlLeft.dx, ctrlLeft.dy, tip.dx, tip.dy);
      leafPath.quadraticBezierTo(ctrlRight.dx, ctrlRight.dy, center.dx, stemBaseY);

      final leafGradient = RadialGradient(
        center: const Alignment(0, -0.5),
        radius: 0.9,
        colors: [leafGreenLight, leafGreenDark],
      ).createShader(leafPath.getBounds());

      canvas.drawPath(leafPath, Paint()..shader = leafGradient);
      canvas.drawPath(leafPath, leafOutline);
    }

    // Leaf 1: Top Left
    drawCrownLeaf(
      Offset(center.dx - radius * 0.65, center.dy - radius * 1.12),
      Offset(center.dx - radius * 0.45, center.dy - radius * 0.92),
      Offset(center.dx - radius * 0.32, center.dy - radius * 1.22),
    );

    // Leaf 2: Top Right
    drawCrownLeaf(
      Offset(center.dx + radius * 0.65, center.dy - radius * 1.12),
      Offset(center.dx + radius * 0.32, center.dy - radius * 1.22),
      Offset(center.dx + radius * 0.45, center.dy - radius * 0.92),
    );

    // Leaf 3: Mid Left
    drawCrownLeaf(
      Offset(center.dx - radius * 0.78, center.dy - radius * 0.68),
      Offset(center.dx - radius * 0.48, center.dy - radius * 0.88),
      Offset(center.dx - radius * 0.48, center.dy - radius * 0.58),
    );

    // Leaf 4: Mid Right
    drawCrownLeaf(
      Offset(center.dx + radius * 0.78, center.dy - radius * 0.68),
      Offset(center.dx + radius * 0.48, center.dy - radius * 0.58),
      Offset(center.dx + radius * 0.48, center.dy - radius * 0.88),
    );

    // Leaf 5: Front Center Leaf
    drawCrownLeaf(
      Offset(center.dx, center.dy - radius * 0.55),
      Offset(center.dx - radius * 0.28, center.dy - radius * 0.72),
      Offset(center.dx + radius * 0.28, center.dy - radius * 0.72),
    );

    // Stem Cap Button
    canvas.drawCircle(Offset(center.dx, stemBaseY), radius * 0.11, Paint()..color = leafGreenDark);
    canvas.drawCircle(Offset(center.dx, stemBaseY), radius * 0.11, leafOutline);
  }

  void _drawCuteExpressiveFace(Canvas canvas, Offset center, double radius) {
    final eyeY = center.dy - radius * 0.08;
    final eyeXOffset = radius * 0.28;

    // --- Rosy Blush Cheeks ---
    final blushPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFF5252).withValues(alpha: 0.65),
          const Color(0xFFFF5252).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - eyeXOffset * 1.22, center.dy + radius * 0.16),
        width: radius * 0.32,
        height: radius * 0.18,
      ),
      blushPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + eyeXOffset * 1.22, center.dy + radius * 0.16),
        width: radius * 0.32,
        height: radius * 0.18,
      ),
      blushPaint,
    );

    // --- Cute Expressive Mouth ---
    final mouthPaint = Paint()
      ..color = const Color(0xFF2A0808)
      ..style = PaintingStyle.fill;

    final mouthPath = Path();
    final mouthLeft = Offset(center.dx - radius * 0.16, center.dy + radius * 0.14);
    final mouthRight = Offset(center.dx + radius * 0.16, center.dy + radius * 0.14);

    mouthPath.moveTo(mouthLeft.dx, mouthLeft.dy);
    mouthPath.quadraticBezierTo(
      center.dx,
      center.dy + radius * 0.32,
      mouthRight.dx,
      mouthRight.dy,
    );
    mouthPath.quadraticBezierTo(
      center.dx,
      center.dy + radius * 0.18,
      mouthLeft.dx,
      mouthLeft.dy,
    );
    canvas.drawPath(mouthPath, mouthPaint);

    // Tiny Pink Tongue inside Mouth
    canvas.save();
    canvas.clipPath(mouthPath);
    final tonguePaint = Paint()..color = const Color(0xFFFF4081);
    canvas.drawCircle(
      Offset(center.dx, center.dy + radius * 0.25),
      radius * 0.10,
      tonguePaint,
    );
    canvas.restore();

    // --- Cute Anime Eyes with Dual Glossy Catchlights ---
    final eyePaint = Paint()..color = const Color(0xFF2A0808);
    final eyeWhitePaint = Paint()..color = Colors.white;

    final eyeWidth = radius * 0.20;
    final eyeHeight = radius * 0.28 * (1.0 - blinkAmount).clamp(0.04, 1.0);

    void drawAnimeEye(double centerX) {
      if (blinkAmount > 0.8) {
        // Closed Eye Curve (Happy Wink)
        final winkPath = Path();
        winkPath.moveTo(centerX - eyeWidth * 0.5, eyeY);
        winkPath.quadraticBezierTo(centerX, eyeY + radius * 0.08, centerX + eyeWidth * 0.5, eyeY);
        canvas.drawPath(
          winkPath,
          Paint()
            ..color = const Color(0xFF2A0808)
            ..style = PaintingStyle.stroke
            ..strokeWidth = radius * 0.06
            ..strokeCap = StrokeCap.round,
        );
        return;
      }

      // Eye Background Oval
      final eyeRect = Rect.fromCenter(
        center: Offset(centerX, eyeY),
        width: eyeWidth,
        height: eyeHeight,
      );
      canvas.drawRRect(RRect.fromRectAndRadius(eyeRect, Radius.circular(eyeWidth * 0.45)), eyePaint);

      // Catchlight 1: Main Glossy Oval (Top Right)
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(centerX + eyeWidth * 0.12, eyeY - eyeHeight * 0.22),
          width: eyeWidth * 0.42,
          height: eyeHeight * 0.38,
        ),
        eyeWhitePaint,
      );

      // Catchlight 2: Micro Highlight (Bottom Left)
      canvas.drawCircle(
        Offset(centerX - eyeWidth * 0.16, eyeY + eyeHeight * 0.22),
        eyeWidth * 0.12,
        eyeWhitePaint,
      );
    }

    drawAnimeEye(center.dx - eyeXOffset);
    drawAnimeEye(center.dx + eyeXOffset);
  }

  void _drawLootSparkles(Canvas canvas, Offset center, double radius, double sparkleAngle) {
    final goldPaint = Paint()
      ..color = AppColors.accentGold
      ..style = PaintingStyle.fill;

    final whiteSparklePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;

    // Orbiting 4-point magic stars around the mascot
    final orbitRadius = radius * 1.35;
    for (int i = 0; i < 4; i++) {
      final angle = sparkleAngle + (i * math.pi / 2);
      final x = center.dx + math.cos(angle) * orbitRadius;
      final y = center.dy + math.sin(angle) * (orbitRadius * 0.45);
      final starSize = radius * (0.06 + (0.03 * math.sin(angle * 2)));

      _draw4PointStar(canvas, Offset(x, y), starSize, i % 2 == 0 ? goldPaint : whiteSparklePaint);
    }
  }

  void _draw4PointStar(Canvas canvas, Offset position, double size, Paint paint) {
    final path = Path();
    path.moveTo(position.dx, position.dy - size);
    path.lineTo(position.dx + size * 0.28, position.dy - size * 0.28);
    path.lineTo(position.dx + size, position.dy);
    path.lineTo(position.dx + size * 0.28, position.dy + size * 0.28);
    path.lineTo(position.dx, position.dy + size);
    path.lineTo(position.dx - size * 0.28, position.dy + size * 0.28);
    path.lineTo(position.dx - size, position.dy);
    path.lineTo(position.dx - size * 0.28, position.dy - size * 0.28);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant PremiumTomatoPainter oldDelegate) {
    return oldDelegate.baseColor != baseColor ||
        oldDelegate.highlightColor != highlightColor ||
        oldDelegate.progress != progress ||
        oldDelegate.isCollectible != isCollectible ||
        oldDelegate.blinkAmount != blinkAmount ||
        oldDelegate.armWavePhase != armWavePhase ||
        oldDelegate.sparkleAngle != sparkleAngle;
  }
}

// ============================================================================
// ACCESSORY PAINTERS (Polished & Fully Aligned)
// ============================================================================

class SunglassesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final framePaint = Paint()
      ..color = const Color(0xFF111111)
      ..style = PaintingStyle.fill;

    final lensGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [const Color(0xFF222222), const Color(0xFF050505)],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final lensPaint = Paint()..shader = lensGradient;

    final glossPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;

    // Left Lens RRect
    final leftRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, size.height * 0.22, size.width * 0.42, size.height * 0.65),
      const Radius.circular(8),
    );
    canvas.drawRRect(leftRect, lensPaint);
    canvas.drawRRect(leftRect, framePaint..style = PaintingStyle.stroke..strokeWidth = 3);

    // Right Lens RRect
    final rightRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.58, size.height * 0.22, size.width * 0.42, size.height * 0.65),
      const Radius.circular(8),
    );
    canvas.drawRRect(rightRect, lensPaint);
    canvas.drawRRect(rightRect, framePaint..style = PaintingStyle.stroke..strokeWidth = 3);

    // Bridge
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.40, size.height * 0.38, size.width * 0.20, size.height * 0.15),
      framePaint..style = PaintingStyle.fill,
    );

    // Gloss Streak
    final glossPath = Path();
    glossPath.moveTo(size.width * 0.05, size.height * 0.3);
    glossPath.lineTo(size.width * 0.25, size.height * 0.3);
    glossPath.lineTo(size.width * 0.15, size.height * 0.7);
    glossPath.close();
    canvas.drawPath(glossPath, glossPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class EyepatchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final patchPaint = Paint()
      ..color = const Color(0xFF1E1E1E)
      ..style = PaintingStyle.fill;

    final strapPaint = Paint()
      ..color = const Color(0xFF1E1E1E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    // Eyepatch shape
    final patchPath = Path();
    patchPath.addOval(Rect.fromLTWH(size.width * 0.25, size.height * 0.1, size.width * 0.5, size.height * 0.8));
    canvas.drawPath(patchPath, patchPaint);

    // Straps going across
    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width, size.height * 0.7),
      strapPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CrownPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final crownGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [const Color(0xFFFFD54F), const Color(0xFFFFB300)],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final paint = Paint()..shader = crownGradient;
    final strokePaint = Paint()
      ..color = const Color(0xFFB78103)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.35);
    path.lineTo(size.width * 0.22, size.height * 0.55);
    path.lineTo(size.width * 0.38, 0);
    path.lineTo(size.width * 0.50, size.height * 0.40);
    path.lineTo(size.width * 0.62, 0);
    path.lineTo(size.width * 0.78, size.height * 0.55);
    path.lineTo(size.width, size.height * 0.35);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, strokePaint);

    // Ruby Jewels
    final rubyPaint = Paint()..color = const Color(0xFFE53935);
    canvas.drawCircle(Offset(size.width * 0.38, size.height * 0.55), size.width * 0.055, rubyPaint);
    canvas.drawCircle(Offset(size.width * 0.62, size.height * 0.55), size.width * 0.055, rubyPaint);

    // Sapphire Center Jewel
    final sapphirePaint = Paint()..color = const Color(0xFF1E88E5);
    canvas.drawCircle(Offset(size.width * 0.50, size.height * 0.75), size.width * 0.07, sapphirePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TopHatPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final hatPaint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.fill;

    // Hat Crown Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.18, 0, size.width * 0.64, size.height * 0.72),
        const Radius.circular(4),
      ),
      hatPaint,
    );

    // Hat Brim
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, size.height * 0.68, size.width, size.height * 0.18),
        const Radius.circular(4),
      ),
      hatPaint,
    );

    // Red Satin Band
    final bandPaint = Paint()..color = const Color(0xFFE53935);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.18, size.height * 0.54, size.width * 0.64, size.height * 0.14),
      bandPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HeadphonesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bandPaint = Paint()
      ..color = const Color(0xFF263238)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.05, size.height * 0.85);
    path.quadraticBezierTo(
      size.width / 2,
      -size.height * 0.35,
      size.width * 0.95,
      size.height * 0.85,
    );
    canvas.drawPath(path, bandPaint);

    // Ear Cups
    final cupPaint = Paint()
      ..color = const Color(0xFFD84315)
      ..style = PaintingStyle.fill;

    final cupRimPaint = Paint()
      ..color = const Color(0xFF263238)
      ..style = PaintingStyle.fill;

    // Left Cup
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, size.height * 0.45, size.width * 0.22, size.height * 0.52),
        const Radius.circular(10),
      ),
      cupPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.16, size.height * 0.48, size.width * 0.06, size.height * 0.46),
        const Radius.circular(4),
      ),
      cupRimPaint,
    );

    // Right Cup
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.78, size.height * 0.45, size.width * 0.22, size.height * 0.52),
        const Radius.circular(10),
      ),
      cupPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.78, size.height * 0.48, size.width * 0.06, size.height * 0.46),
        const Radius.circular(4),
      ),
      cupRimPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BowtiePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final tiePaint = Paint()
      ..color = const Color(0xFFE53935)
      ..style = PaintingStyle.fill;

    final tieOutline = Paint()
      ..color = const Color(0xFF8E0000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Left wing
    final leftPath = Path();
    leftPath.moveTo(size.width * 0.5, size.height * 0.5);
    leftPath.lineTo(0, 0);
    leftPath.lineTo(0, size.height);
    leftPath.close();
    canvas.drawPath(leftPath, tiePaint);
    canvas.drawPath(leftPath, tieOutline);

    // Right wing
    final rightPath = Path();
    rightPath.moveTo(size.width * 0.5, size.height * 0.5);
    rightPath.lineTo(size.width, 0);
    rightPath.lineTo(size.width, size.height);
    rightPath.close();
    canvas.drawPath(rightPath, tiePaint);
    canvas.drawPath(rightPath, tieOutline);

    // Center knot
    final knotPaint = Paint()..color = const Color(0xFFB71C1C);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.5, size.height * 0.5),
          width: size.width * 0.22,
          height: size.height * 0.55,
        ),
        const Radius.circular(4),
      ),
      knotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
