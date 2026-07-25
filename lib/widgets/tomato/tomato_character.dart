import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/models/tomato_state.dart';
import '../../core/theme/app_colors.dart';

/// A beautifully animated tomato character that changes based on focus progress
/// Now supports custom image assets for different tomato states
class TomatoCharacter extends StatefulWidget {
  final TomatoState state;
  final double progress; // 0.0 to 1.0
  final String? accessory;
  final VoidCallback? onTap;
  final bool isCollectible;
  final double size;
  final bool useImageAssets; // Toggle between custom images and painted tomato

  const TomatoCharacter({
    super.key,
    required this.state,
    required this.progress,
    this.accessory,
    this.onTap,
    this.isCollectible = false,
    this.size = 200,
    this.useImageAssets = true, // Default to using image assets
  });

  @override
  State<TomatoCharacter> createState() => _TomatoCharacterState();
}

class _TomatoCharacterState extends State<TomatoCharacter>
    with TickerProviderStateMixin {
  late AnimationController _idleController;
  late AnimationController _bounceController;
  late AnimationController _glowController;
  late AnimationController _collectibleController;
  late AnimationController _blinkController; // Controls the eye blink
  late AnimationController _armController; // Controls arm waving

  late Animation<double> _idleAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _collectibleAnimation;
  late Animation<double> _blinkAnimation;
  late Animation<double> _armAnimation;

  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();

    // IDLE Animation (Gentle breathing)
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _idleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOutSine),
    );
    _idleController.repeat(reverse: true);

    // Bounce animation for state transitions
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    // Glow animation for collectible state
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Collectible bounce animation (Victory Jump)
    _collectibleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _collectibleAnimation = Tween<double>(begin: 0.0, end: -20.0).animate(
      CurvedAnimation(parent: _collectibleController, curve: Curves.easeInOut),
    );

    // Blink Animation (Rapid close and open)
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _blinkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );

    // Listen to blink completion to schedule the next blink
    _blinkController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _blinkController.reverse(); // Open eyes
      } else if (status == AnimationStatus.dismissed) {
        _scheduleNextBlink();
      }
    });

    _scheduleNextBlink();

    // Arm Wave Animation (Waving up and down 3 times)
    _armController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    // Sine wave for waving back and forth
    _armAnimation = Tween<double>(
      begin: 0.0,
      end: math.pi * 6,
    ).animate(CurvedAnimation(parent: _armController, curve: Curves.linear));

    _armController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _armController.reset();
        _scheduleNextWave();
      }
    });

    _scheduleNextWave();

    if (widget.isCollectible) {
      _glowController.repeat(reverse: true);
      _collectibleController.repeat(reverse: true);
      _idleController.stop(); // Stop idle when collectible/celebrating
    }
  }

  void _scheduleNextBlink() {
    if (!mounted) return;
    // Random blink interval between 2 and 6 seconds
    final delay = Duration(milliseconds: 2000 + _random.nextInt(4000));
    Future.delayed(delay, () {
      if (mounted && !widget.isCollectible && !_blinkController.isAnimating) {
        _blinkController.forward();
      } else if (mounted) {
        // If collectible, schedule another check later
        _scheduleNextBlink();
      }
    });
  }

  void _scheduleNextWave() {
    if (!mounted) return;
    // Random arm wave interval between 5 and 15 seconds
    final delay = Duration(milliseconds: 5000 + _random.nextInt(10000));
    Future.delayed(delay, () {
      if (mounted && !widget.isCollectible && !_armController.isAnimating) {
        _armController.forward();
      } else if (mounted) {
        _scheduleNextWave();
      }
    });
  }

  @override
  void didUpdateWidget(TomatoCharacter oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Trigger bounce animation on state change
    if (oldWidget.state != widget.state) {
      _bounceController.forward(from: 0.0);
    }

    // Handle collectible state animations
    if (widget.isCollectible && !oldWidget.isCollectible) {
      // VICTORY! Start jumping
      _glowController.repeat(reverse: true);
      _collectibleController.repeat(reverse: true);
      _idleController.stop(); // Stop breathing to jump
    } else if (!widget.isCollectible && oldWidget.isCollectible) {
      // Back to normal
      _glowController.stop();
      _glowController.reset();
      _collectibleController.stop();
      _collectibleController.reset();
      _idleController.repeat(reverse: true); // Resume breathing
    }
  }

  @override
  void dispose() {
    _idleController.dispose();
    _bounceController.dispose();
    _glowController.dispose();
    _collectibleController.dispose();
    _blinkController.dispose();
    _armController.dispose();
    super.dispose();
  }

  // Get colors based on tomato state with smooth interpolation
  Color _getTomatoColor() {
    if (widget.progress <= 0.5) {
      // Interpolate from unripe (green) to half-ripe (orange)
      return Color.lerp(
        AppColors.tomatoUnripe,
        AppColors.tomatoHalfRipe,
        widget.progress * 2,
      )!;
    } else {
      // Interpolate from half-ripe (orange) to ripe (red)
      return Color.lerp(
        AppColors.tomatoHalfRipe,
        AppColors.tomatoRipe,
        (widget.progress - 0.5) * 2,
      )!;
    }
  }

  Color _getTomatoHighlightColor() {
    if (widget.progress <= 0.5) {
      return Color.lerp(
        AppColors.tomatoUnripeLight,
        AppColors.tomatoHalfRipeLight,
        widget.progress * 2,
      )!;
    } else {
      return Color.lerp(
        AppColors.tomatoHalfRipeLight,
        AppColors.tomatoRipeGloss,
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
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _bounceAnimation,
          _glowAnimation,
          _collectibleAnimation,
          _idleAnimation,
          _blinkAnimation,
          _armAnimation,
        ]),
        builder: (context, child) {
          final scale = widget.isCollectible ? 1.0 : _idleAnimation.value;
          final dy = widget.isCollectible ? _collectibleAnimation.value : 0.0;

          return Transform.translate(
            offset: Offset(0, dy),
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: effectiveSize,
                height: effectiveSize,
                decoration: widget.isCollectible
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accentGold.withAlpha(
                              (100 * _glowAnimation.value).toInt(),
                            ),
                            blurRadius: 30 + (20 * _glowAnimation.value),
                            spreadRadius: 10 * _glowAnimation.value,
                          ),
                        ],
                      )
                    : null,
                child: _buildPremiumTomato(effectiveSize),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build premium painted tomato with anchor system
  Widget _buildPremiumTomato(double size) {
    // Math logic for anchors based on canvas drawing
    // We establish the exact coordinate scale used by the TomatoPainter
    final center = Offset(size / 2, size / 2 + size * 0.05);
    final radius = size * 0.45;

    // Anchor: Center of the eyes
    final eyeY = center.dy - radius * 0.05;
    final eyeAnchor = Offset(center.dx, eyeY);

    // Anchor: Top of the head / base of the stem
    final headAnchor = Offset(center.dx, center.dy - radius * 0.95);

    // Anchor: Lower body / neck area
    final bodyAnchor = Offset(center.dx, center.dy + radius * 0.5);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 1. The Base Tomato
        Positioned.fill(
          child: CustomPaint(
            painter: TomatoPainter(
              color: _getTomatoColor(),
              highlightColor: _getTomatoHighlightColor(),
              progress: widget.progress,
              isCollectible: widget.isCollectible,
              blinkAmount: _blinkAnimation.value,
              armWavePhase: _armAnimation.value,
            ),
          ),
        ),

        // 2. The Perfectly Aligned Accessory
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
    final accessorySize = size * 0.4; // Base accessory size

    Widget accessoryWidget;
    Offset anchorPoint;
    double width;
    double height;

    // Map each accessory to its physical anchor and dimensions
    switch (accessory) {
      case 'sunglasses':
        width = accessorySize * 1.2;
        height = accessorySize * 0.45;
        accessoryWidget = CustomPaint(
          size: Size(width, height),
          painter: SunglassesPainter(),
        );
        anchorPoint = eyeAnchor;
        break;
      case 'eyepatch':
        width = size; // Straps go all the way across
        height = accessorySize * 0.45;
        accessoryWidget = CustomPaint(
          size: Size(width, height),
          painter: EyepatchPainter(),
        );
        anchorPoint = eyeAnchor;
        break;
      case 'crown':
        width = accessorySize * 1.1;
        height = accessorySize * 0.6;
        accessoryWidget = CustomPaint(
          size: Size(width, height),
          painter: CrownPainter(),
        );
        anchorPoint = Offset(
          headAnchor.dx,
          headAnchor.dy - (height * 0.3),
        ); // Sit slightly above stem base
        break;
      case 'tophat':
        width = accessorySize * 1.3;
        height = accessorySize * 1.0;
        accessoryWidget = CustomPaint(
          size: Size(width, height),
          painter: TopHatPainter(),
        );
        anchorPoint = Offset(
          headAnchor.dx,
          headAnchor.dy - (height * 0.4),
        ); // Sit on top of head
        break;
      case 'headphones':
        width =
            size * 0.95; // Wide enough to go around the squished tomato body
        height = size * 0.7;
        accessoryWidget = CustomPaint(
          size: Size(width, height),
          painter: HeadphonesPainter(),
        );
        anchorPoint = Offset(
          headAnchor.dx,
          headAnchor.dy + (height * 0.4),
        ); // Center around ears
        break;
      case 'bowtie':
        width = accessorySize * 0.8;
        height = accessorySize * 0.4;
        accessoryWidget = CustomPaint(
          size: Size(width, height),
          painter: BowtiePainter(),
        );
        anchorPoint = bodyAnchor;
        break;
      default:
        return const SizedBox.shrink();
    }

    // Position the accessory exactly centered on the chosen anchor point
    return Positioned(
      left: anchorPoint.dx - (width / 2),
      top: anchorPoint.dy - (height / 2),
      width: width,
      height: height,
      child: accessoryWidget,
    );
  }

  // Removed _getAccessoryWidget as it's replaced by _buildAlignedAccessory
}

class TomatoPainter extends CustomPainter {
  final Color color;
  final Color highlightColor;
  final double progress;
  final bool isCollectible;
  final double blinkAmount;
  final double armWavePhase;

  TomatoPainter({
    required this.color,
    required this.highlightColor,
    required this.progress,
    required this.isCollectible,
    this.blinkAmount = 0.0,
    this.armWavePhase = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Determine the mathematical center and base radius
    final center = Offset(size.width / 2, size.height / 2 + size.height * 0.05);
    final radius = size.width * 0.40; // Slightly smaller to fit limbs

    // 1. Drop Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withAlpha(20)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 1.25),
        width: radius * 1.3,
        height: radius * 0.2,
      ),
      shadowPaint,
    );

    // Common stroke paint for all outlines
    final outlinePaint = Paint()
      ..color =
          const Color(0xFF6B1D1D) // Dark red outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final leafOutlinePaint = Paint()
      ..color =
          const Color(0xFF264A1B) // Dark green outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // 2. Legs and Shoes
    _drawLegs(canvas, center, radius, color, outlinePaint, leafOutlinePaint);

    // 3. Left Arm (Idle)
    _drawLeftArm(canvas, center, radius, color, outlinePaint);

    // 4. Right Arm (Waving based on armWavePhase)
    canvas.save();
    // Rotate around the shoulder joint
    final rightShoulder = Offset(
      center.dx + radius * 0.85,
      center.dy + radius * 0.2,
    );
    canvas.translate(rightShoulder.dx, rightShoulder.dy);
    // Sine wave motion. Arm starts pointing up and right.
    // Base angle -math.pi/6, fluctuates by +- 0.2 radians
    final rotation = -math.pi / 6 + math.sin(armWavePhase) * 0.3;
    canvas.rotate(rotation);
    canvas.translate(-rightShoulder.dx, -rightShoulder.dy);
    _drawRightArm(canvas, rightShoulder, radius, color, outlinePaint);
    canvas.restore();

    // 5. Main Body
    _drawBody(canvas, center, radius, color, outlinePaint);

    // 6. Highlights & Shading
    _drawHighlightsAndShading(canvas, center, radius);

    // 7. Stem and Leaves
    _drawStemAndLeaves(canvas, center, radius, leafOutlinePaint);

    // 8. Face (Eyes, Mouth, Cheeks, Blinking)
    _drawFace(canvas, center, radius);

    // 9. Collectible Sparkles
    if (isCollectible) {
      _drawSparkles(canvas, center, radius);
    }
  }

  void _drawLegs(
    Canvas canvas,
    Offset center,
    double radius,
    Color bodyColor,
    Paint outlinePaint,
    Paint leafOutlinePaint,
  ) {
    final legFillPaint = Paint()
      ..color = bodyColor
      ..style = PaintingStyle.fill;
    final shoeFillPaint = Paint()
      ..color = const Color(0xFF5A9E30)
      ..style = PaintingStyle.fill;

    // Left Leg Setup
    final leftLegX = center.dx - radius * 0.3;
    final legTop = center.dy + radius * 0.8;
    final legBottom = center.dy + radius * 1.1;
    final legWidth = radius * 0.25;

    // Left Leg rect
    final leftLegRect = Rect.fromLTRB(
      leftLegX - legWidth / 2,
      legTop,
      leftLegX + legWidth / 2,
      legBottom,
    );
    canvas.drawRect(leftLegRect, legFillPaint);

    // Left Leg Outline (just the sides)
    canvas.drawLine(
      Offset(leftLegRect.left, legTop),
      Offset(leftLegRect.left, legBottom),
      outlinePaint,
    );
    canvas.drawLine(
      Offset(leftLegRect.right, legTop),
      Offset(leftLegRect.right, legBottom),
      outlinePaint,
    );

    // Left Shoe
    final leftShoeRect = Rect.fromCenter(
      center: Offset(leftLegX - radius * 0.05, legBottom + radius * 0.05),
      width: radius * 0.45,
      height: radius * 0.25,
    );
    final leftShoeRRect = RRect.fromRectAndCorners(
      leftShoeRect,
      topLeft: Radius.circular(radius * 0.2),
      topRight: Radius.circular(radius * 0.2),
      bottomLeft: Radius.circular(radius * 0.05),
      bottomRight: Radius.circular(radius * 0.05),
    );
    canvas.drawRRect(leftShoeRRect, shoeFillPaint);
    canvas.drawRRect(leftShoeRRect, leafOutlinePaint);

    // Right Leg Setup
    final rightLegX = center.dx + radius * 0.3;
    final rightLegRect = Rect.fromLTRB(
      rightLegX - legWidth / 2,
      legTop,
      rightLegX + legWidth / 2,
      legBottom,
    );
    canvas.drawRect(rightLegRect, legFillPaint);

    // Right Leg Outline
    canvas.drawLine(
      Offset(rightLegRect.left, legTop),
      Offset(rightLegRect.left, legBottom),
      outlinePaint,
    );
    canvas.drawLine(
      Offset(rightLegRect.right, legTop),
      Offset(rightLegRect.right, legBottom),
      outlinePaint,
    );

    // Right Shoe
    final rightShoeRect = Rect.fromCenter(
      center: Offset(rightLegX + radius * 0.05, legBottom + radius * 0.05),
      width: radius * 0.45,
      height: radius * 0.25,
    );
    final rightShoeRRect = RRect.fromRectAndCorners(
      rightShoeRect,
      topLeft: Radius.circular(radius * 0.2),
      topRight: Radius.circular(radius * 0.2),
      bottomLeft: Radius.circular(radius * 0.05),
      bottomRight: Radius.circular(radius * 0.05),
    );
    canvas.drawRRect(rightShoeRRect, shoeFillPaint);
    canvas.drawRRect(rightShoeRRect, leafOutlinePaint);
  }

  void _drawLeftArm(
    Canvas canvas,
    Offset center,
    double radius,
    Color bodyColor,
    Paint outlinePaint,
  ) {
    final fillPaint = Paint()
      ..color = bodyColor
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(center.dx - radius * 0.85, center.dy + radius * 0.2);
    // Curve out and down
    path.quadraticBezierTo(
      center.dx - radius * 1.3,
      center.dy + radius * 0.5,
      center.dx - radius * 1.1,
      center.dy + radius * 0.9,
    );
    // Hand shape (mittens)
    path.quadraticBezierTo(
      center.dx - radius * 0.9,
      center.dy + radius * 1.05,
      center.dx - radius * 0.8,
      center.dy + radius * 0.8,
    );
    // Thumb indentation
    path.quadraticBezierTo(
      center.dx - radius * 0.9,
      center.dy + radius * 0.7,
      center.dx - radius * 0.65,
      center.dy + radius * 0.55,
    );

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, outlinePaint);
  }

  void _drawRightArm(
    Canvas canvas,
    Offset shoulder,
    double radius,
    Color bodyColor,
    Paint outlinePaint,
  ) {
    final fillPaint = Paint()
      ..color = bodyColor
      ..style = PaintingStyle.fill;

    // Draw waving right arm relative to the shoulder joint
    final path = Path();
    path.moveTo(shoulder.dx, shoulder.dy);
    // Curve up and right
    path.quadraticBezierTo(
      shoulder.dx + radius * 0.4,
      shoulder.dy - radius * 0.2,
      shoulder.dx + radius * 0.6,
      shoulder.dy - radius * 0.4,
    );
    // Mitten fingers
    path.quadraticBezierTo(
      shoulder.dx + radius * 0.7,
      shoulder.dy - radius * 0.6,
      shoulder.dx + radius * 0.4,
      shoulder.dy - radius * 0.8,
    );
    // Thumb indent
    path.quadraticBezierTo(
      shoulder.dx + radius * 0.2,
      shoulder.dy - radius * 0.7,
      shoulder.dx - radius * 0.1,
      shoulder.dy - radius * 0.4,
    );

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, outlinePaint);
  }

  void _drawBody(
    Canvas canvas,
    Offset center,
    double radius,
    Color bodyColor,
    Paint outlinePaint,
  ) {
    final bodyFillPaint = Paint()
      ..color = bodyColor
      ..style = PaintingStyle.fill;

    // Perfect Circle
    canvas.drawCircle(center, radius, bodyFillPaint);
    canvas.drawCircle(center, radius, outlinePaint);
  }

  void _drawHighlightsAndShading(Canvas canvas, Offset center, double radius) {
    // Inner Crescent Shadow (Bottom Right)
    final shadowPaint = Paint()
      ..color =
          const Color(0xFFBA2A2A) // Darker variant of body color red
      ..style = PaintingStyle.fill;

    final shadowPath = Path();
    shadowPath.addOval(
      Rect.fromCircle(center: center, radius: radius * 0.95),
    ); // Slightly inside outline
    final cutShadowPath = Path();
    cutShadowPath.addOval(
      Rect.fromCircle(
        center: Offset(center.dx - radius * 0.08, center.dy - radius * 0.08),
        radius: radius * 0.96,
      ),
    );

    final finalShadowPath = Path.combine(
      PathOperation.difference,
      shadowPath,
      cutShadowPath,
    );
    canvas.save();
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: center, radius: radius * 0.96)),
    ); // Ensure it stays inside body
    canvas.drawPath(finalShadowPath, shadowPaint);
    canvas.restore();

    // Outer Crescent Gloss Highlight (Top Left)
    final glossPaint = Paint()
      ..color = Colors.white.withAlpha(200)
      ..style = PaintingStyle.fill;

    final glossPath = Path();
    glossPath.addOval(
      Rect.fromCircle(
        center: Offset(center.dx - radius * 0.05, center.dy - radius * 0.05),
        radius: radius * 0.85,
      ),
    );
    final cutGlossPath = Path();
    cutGlossPath.addOval(
      Rect.fromCircle(
        center: Offset(center.dx + radius * 0.05, center.dy + radius * 0.05),
        radius: radius * 0.88,
      ),
    );

    // Combine difference, but we only want the top-left part, so we'll clip it
    final finalGlossPath = Path.combine(
      PathOperation.difference,
      glossPath,
      cutGlossPath,
    );

    canvas.save();
    // Clip to only keep the top-left quadrant of the highlight
    canvas.clipRect(
      Rect.fromLTRB(
        center.dx - radius,
        center.dy - radius,
        center.dx + radius * 0.2,
        center.dy + radius * 0.2,
      ),
    );
    // Draw the curved highlight
    canvas.drawPath(finalGlossPath, glossPaint);

    // Add two small highlight spots standard in vector art below the main gloss
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - radius * 0.75, center.dy - radius * 0.1),
        width: radius * 0.08,
        height: radius * 0.15,
      ),
      glossPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - radius * 0.65, center.dy + radius * 0.1),
        width: radius * 0.06,
        height: radius * 0.12,
      ),
      glossPaint,
    );
    canvas.restore();
  }

  void _drawStemAndLeaves(
    Canvas canvas,
    Offset center,
    double radius,
    Paint leafOutlinePaint,
  ) {
    final leafFillPaint = Paint()
      ..color =
          const Color(0xFF63B838) // Vibrant green
      ..style = PaintingStyle.fill;

    final stemFillPaint = Paint()
      ..color =
          const Color(0xFF4C9329) // Slightly darker green for stem
      ..style = PaintingStyle.fill;

    // Draw Stem
    final stemPath = Path();
    stemPath.moveTo(center.dx - radius * 0.05, center.dy - radius * 0.9);
    stemPath.lineTo(center.dx - radius * 0.02, center.dy - radius * 1.3);
    // Rounded tip
    stemPath.quadraticBezierTo(
      center.dx + radius * 0.05,
      center.dy - radius * 1.35,
      center.dx + radius * 0.08,
      center.dy - radius * 1.3,
    );
    stemPath.lineTo(center.dx + radius * 0.05, center.dy - radius * 0.9);
    canvas.drawPath(stemPath, stemFillPaint);
    canvas.drawPath(stemPath, leafOutlinePaint);

    // Draw 4 Pointy Leaves
    // We will draw them from back to front
    // Leaf function helper
    void drawLeaf(Offset tip, Offset leftCtrl, Offset rightCtrl) {
      final path = Path();
      path.moveTo(center.dx, center.dy - radius * 0.85); // Center base
      path.quadraticBezierTo(leftCtrl.dx, leftCtrl.dy, tip.dx, tip.dy);
      path.quadraticBezierTo(
        rightCtrl.dx,
        rightCtrl.dy,
        center.dx,
        center.dy - radius * 0.85,
      );
      canvas.drawPath(path, leafFillPaint);
      canvas.drawPath(path, leafOutlinePaint);
      // Inner vein
      final veinPath = Path();
      veinPath.moveTo(center.dx, center.dy - radius * 0.85);
      veinPath.quadraticBezierTo(
        (tip.dx + center.dx) / 2 + radius * 0.05,
        (tip.dy + center.dy - radius * 0.85) / 2,
        tip.dx * 0.95,
        tip.dy * 0.95,
      );
      canvas.drawPath(veinPath, leafOutlinePaint..strokeWidth = radius * 0.04);
      leafOutlinePaint.strokeWidth = radius * 0.08; // Reset
    }

    // Top Right Leaf
    drawLeaf(
      Offset(center.dx + radius * 0.6, center.dy - radius * 1.05),
      Offset(center.dx + radius * 0.3, center.dy - radius * 1.15),
      Offset(center.dx + radius * 0.4, center.dy - radius * 0.9),
    );

    // Bottom Right Leaf
    drawLeaf(
      Offset(center.dx + radius * 0.7, center.dy - radius * 0.6),
      Offset(center.dx + radius * 0.4, center.dy - radius * 0.8),
      Offset(center.dx + radius * 0.4, center.dy - radius * 0.5),
    );

    // Top Left Leaf
    drawLeaf(
      Offset(center.dx - radius * 0.6, center.dy - radius * 1.05),
      Offset(center.dx - radius * 0.4, center.dy - radius * 0.9),
      Offset(center.dx - radius * 0.3, center.dy - radius * 1.15),
    );

    // Bottom Left Leaf
    drawLeaf(
      Offset(center.dx - radius * 0.7, center.dy - radius * 0.6),
      Offset(center.dx - radius * 0.4, center.dy - radius * 0.5),
      Offset(center.dx - radius * 0.4, center.dy - radius * 0.8),
    );

    // Draw small center green cap to cover leaf joints
    canvas.drawCircle(
      Offset(center.dx, center.dy - radius * 0.85),
      radius * 0.1,
      stemFillPaint,
    );
    canvas.drawCircle(
      Offset(center.dx, center.dy - radius * 0.85),
      radius * 0.1,
      leafOutlinePaint,
    );
  }

  void _drawFace(Canvas canvas, Offset center, double radius) {
    // Base coordinates
    final eyeY = center.dy - radius * 0.1;
    final eyeXOffset = radius * 0.28;

    // Cheek Blushes
    final cheekPaint = Paint()
      ..color =
          const Color(0xFFF25C5C) // Soft red over body color
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - eyeXOffset * 1.2, center.dy + radius * 0.15),
        width: radius * 0.25,
        height: radius * 0.15,
      ),
      cheekPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + eyeXOffset * 1.2, center.dy + radius * 0.15),
        width: radius * 0.25,
        height: radius * 0.15,
      ),
      cheekPaint,
    );

    // Mouth
    final mouthPaint = Paint()
      ..color =
          const Color(0xFF3B1D1D) // Dark brown/black
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.05
      ..strokeCap = StrokeCap.round;

    final mouthPath = Path();
    mouthPath.moveTo(center.dx - radius * 0.15, center.dy + radius * 0.15);
    mouthPath.quadraticBezierTo(
      center.dx,
      center.dy + radius * 0.3,
      center.dx + radius * 0.15,
      center.dy + radius * 0.15,
    );
    canvas.drawPath(mouthPath, mouthPaint);

    // Eyes
    final eyePaint = Paint()
      ..color = const Color(0xFF3B1D1D)
      ..style = PaintingStyle.fill;

    final eyeWhitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Animate eye closure
    final eyeWidth = radius * 0.18 + (radius * 0.03 * blinkAmount);
    final eyeHeight = radius * 0.25 * (1.0 - blinkAmount).clamp(0.05, 1.0);
    final currentEyeY = eyeY + (radius * 0.12 * blinkAmount);

    void drawEye(double centerX) {
      // Eyelash/Eyebrow curve (only visible when not fully blinking)
      if (blinkAmount < 0.5) {
        final lashPath = Path();
        // Shift eyelash based on side
        final lashDir = centerX > center.dx ? 1.0 : -1.0;
        lashPath.moveTo(
          centerX + lashDir * radius * 0.1,
          currentEyeY - eyeHeight * 0.6,
        );
        lashPath.quadraticBezierTo(
          centerX + lashDir * radius * 0.2,
          currentEyeY - eyeHeight * 0.7,
          centerX + lashDir * radius * 0.25,
          currentEyeY - eyeHeight * 0.5,
        );
        canvas.drawPath(lashPath, mouthPaint); // same dark line as mouth
      }

      // Main Black Oval
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(centerX, currentEyeY),
          width: eyeWidth,
          height: eyeHeight,
        ),
        eyePaint,
      );

      // White Highlights
      if (blinkAmount < 0.5) {
        final highlightScale = 1.0 - (blinkAmount * 2);
        canvas.save();
        canvas.translate(centerX, currentEyeY);
        canvas.scale(highlightScale);
        canvas.translate(-centerX, -currentEyeY);

        // Large Top Highlight
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(
              centerX + eyeWidth * 0.1,
              currentEyeY - eyeHeight * 0.2,
            ),
            width: eyeWidth * 0.45,
            height: eyeHeight * 0.4,
          ),
          eyeWhitePaint,
        );
        // Small Bottom Highlight
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(
              centerX - eyeWidth * 0.15,
              currentEyeY + eyeHeight * 0.2,
            ),
            width: eyeWidth * 0.25,
            height: eyeHeight * 0.2,
          ),
          eyeWhitePaint,
        );
        canvas.restore();
      }
    }

    drawEye(center.dx - eyeXOffset);
    drawEye(center.dx + eyeXOffset);
  }

  void _drawSparkles(Canvas canvas, Offset center, double radius) {
    final sparklePaint = Paint()
      ..color = AppColors.accentGold
      ..style = PaintingStyle.fill;

    final sparklePositions = [
      Offset(center.dx - radius * 0.8, center.dy - radius * 0.5),
      Offset(center.dx + radius * 0.9, center.dy - radius * 0.3),
      Offset(center.dx - radius * 0.6, center.dy + radius * 0.6),
      Offset(center.dx + radius * 0.7, center.dy + radius * 0.5),
    ];

    for (final pos in sparklePositions) {
      _drawSparkle(canvas, pos, radius * 0.08, sparklePaint);
    }
  }

  void _drawSparkle(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    // 4-pointed star
    path.moveTo(center.dx, center.dy - size);
    path.lineTo(center.dx + size * 0.3, center.dy - size * 0.3);
    path.lineTo(center.dx + size, center.dy);
    path.lineTo(center.dx + size * 0.3, center.dy + size * 0.3);
    path.lineTo(center.dx, center.dy + size);
    path.lineTo(center.dx - size * 0.3, center.dy + size * 0.3);
    path.lineTo(center.dx - size, center.dy);
    path.lineTo(center.dx - size * 0.3, center.dy - size * 0.3);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant TomatoPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.highlightColor != highlightColor ||
        oldDelegate.progress != progress ||
        oldDelegate.isCollectible != isCollectible;
  }
}

// Accessory Painters
class SunglassesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Left lens
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          0,
          size.height * 0.3,
          size.width * 0.4,
          size.height * 0.5,
        ),
        const Radius.circular(5),
      ),
      paint,
    );

    // Right lens
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.6,
          size.height * 0.3,
          size.width * 0.4,
          size.height * 0.5,
        ),
        const Radius.circular(5),
      ),
      paint,
    );

    // Bridge
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.4,
        size.height * 0.45,
        size.width * 0.2,
        size.height * 0.1,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class EyepatchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Eyepatch
    canvas.drawOval(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Strap
    final strapPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawLine(
      Offset(size.width, size.height / 2),
      Offset(size.width * 2, size.height / 2),
      strapPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CrownPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accentGold
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.4);
    path.lineTo(size.width * 0.2, size.height * 0.6);
    path.lineTo(size.width * 0.35, 0);
    path.lineTo(size.width * 0.5, size.height * 0.4);
    path.lineTo(size.width * 0.65, 0);
    path.lineTo(size.width * 0.8, size.height * 0.6);
    path.lineTo(size.width, size.height * 0.4);
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);

    // Jewels
    final jewelPaint = Paint()..color = Colors.red;
    canvas.drawCircle(
      Offset(size.width * 0.35, size.height * 0.5),
      size.width * 0.05,
      jewelPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.65, size.height * 0.5),
      size.width * 0.05,
      jewelPaint,
    );
    final blueJewelPaint = Paint()..color = Colors.blue;
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.7),
      size.width * 0.06,
      blueJewelPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TopHatPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Hat top
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.15,
          0,
          size.width * 0.7,
          size.height * 0.7,
        ),
        const Radius.circular(3),
      ),
      paint,
    );

    // Hat brim
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, size.height * 0.7, size.width, size.height * 0.15),
        const Radius.circular(2),
      ),
      paint,
    );

    // Band
    final bandPaint = Paint()..color = AppColors.tomatoRed;
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.15,
        size.height * 0.55,
        size.width * 0.7,
        size.height * 0.12,
      ),
      bandPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HeadphonesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    // Headband
    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(
      size.width / 2,
      -size.height * 0.3,
      size.width,
      size.height,
    );
    canvas.drawPath(path, paint);

    // Ear cups
    final cupPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromLTWH(0, size.height * 0.5, size.width * 0.25, size.height * 0.5),
      cupPaint,
    );
    canvas.drawOval(
      Rect.fromLTWH(
        size.width * 0.75,
        size.height * 0.5,
        size.width * 0.25,
        size.height * 0.5,
      ),
      cupPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BowtiePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.tomatoRed
      ..style = PaintingStyle.fill;

    // Left wing
    final leftPath = Path();
    leftPath.moveTo(size.width * 0.5, size.height * 0.5);
    leftPath.quadraticBezierTo(0, 0, 0, size.height * 0.5);
    leftPath.quadraticBezierTo(
      0,
      size.height,
      size.width * 0.5,
      size.height * 0.5,
    );
    canvas.drawPath(leftPath, paint);

    // Right wing
    final rightPath = Path();
    rightPath.moveTo(size.width * 0.5, size.height * 0.5);
    rightPath.quadraticBezierTo(size.width, 0, size.width, size.height * 0.5);
    rightPath.quadraticBezierTo(
      size.width,
      size.height,
      size.width * 0.5,
      size.height * 0.5,
    );
    canvas.drawPath(rightPath, paint);

    // Center knot
    final knotPaint = Paint()..color = AppColors.tomatoRedDark;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.5),
        width: size.width * 0.2,
        height: size.height * 0.5,
      ),
      knotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Animated sparkle widget for collectible state
class _SparkleWidget extends StatefulWidget {
  final double size;

  const _SparkleWidget({required this.size});

  @override
  State<_SparkleWidget> createState() => _SparkleWidgetState();
}

class _SparkleWidgetState extends State<_SparkleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800 + (math.Random().nextInt(400))),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _opacityAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Icon(
              Icons.star,
              size: widget.size,
              color: AppColors.accentGold,
            ),
          ),
        );
      },
    );
  }
}
