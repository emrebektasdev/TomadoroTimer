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
  late Animation<double> _idleAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _collectibleAnimation;

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

    if (widget.isCollectible) {
      _glowController.repeat(reverse: true);
      _collectibleController.repeat(reverse: true);
      _idleController.stop(); // Stop idle when collectible/celebrating
    }
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
    // DEBUG: Get actual screen width to calculate size
    final screenWidth = MediaQuery.of(context).size.width;
    // Force size to be at least 45% of screen width if widget.size is too small
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
        ]),
        builder: (context, child) {
          // Idle vs Collectible transforms
          final scale = widget.isCollectible ? 1.0 : _idleAnimation.value;
          final dy = widget.isCollectible ? _collectibleAnimation.value : 0.0;

          return Transform.translate(
            offset: Offset(0, dy), // Jump action
            child: Transform.scale(
              scale: scale, // Breathe action
              child: Container(
                width: effectiveSize,
                height: effectiveSize,
                // DEBUG: Uncomment to see container bounds
                // color: Colors.red.withOpacity(0.3),
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
                child: widget.useImageAssets
                    ? _buildImageTomato(effectiveSize)
                    : _buildPaintedTomato(),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build tomato using image assets - SIMPLIFIED VERSION
  Widget _buildImageTomato(double size) {
    // Hangi görsel gösterilecek?
    final String imagePath;
    final int stageKey;

    if (widget.progress < 0.5) {
      imagePath = 'assets/images/unripe_tomato.png';
      stageKey = 0;
    } else if (widget.progress < 1.0 || !widget.isCollectible) {
      imagePath = 'assets/images/semiripe_tomato.png';
      stageKey = 1;
    } else {
      imagePath = 'assets/images/ripe_tomato.png';
      stageKey = 2;
    }

    return SizedBox(
      width: size,
      height: size,
      // Kırmızı arka plan kaldırıldı - domates artık büyük görünecek
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: Image.asset(
          imagePath,
          key: ValueKey<int>(stageKey),
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Görsel bulunamazsa CustomPaint kullan
            debugPrint('HATA: Görsel yüklenemedi: $imagePath - $error');
            return CustomPaint(
              size: Size(size, size),
              painter: TomatoPainter(
                color: _getTomatoColor(),
                highlightColor: _getTomatoHighlightColor(),
                progress: widget.progress,
                isCollectible: widget.isCollectible,
              ),
            );
          },
        ),
      ),
    );
  }

  /// Build painted tomato (fallback/alternative)
  Widget _buildPaintedTomato() {
    return CustomPaint(
      painter: TomatoPainter(
        color: _getTomatoColor(),
        highlightColor: _getTomatoHighlightColor(),
        progress: widget.progress,
        isCollectible: widget.isCollectible,
      ),
      child: _buildAccessory(),
    );
  }

  Widget? _buildAccessory() {
    if (widget.accessory == null) return null;

    return Positioned(
      top: widget.size * 0.15,
      left: 0,
      right: 0,
      child: Center(child: _getAccessoryWidget(widget.accessory!)),
    );
  }

  Widget _getAccessoryWidget(String accessory) {
    final accessorySize = widget.size * 0.4;

    switch (accessory) {
      case 'sunglasses':
        return CustomPaint(
          size: Size(accessorySize, accessorySize * 0.4),
          painter: SunglassesPainter(),
        );
      case 'eyepatch':
        return CustomPaint(
          size: Size(accessorySize * 0.5, accessorySize * 0.4),
          painter: EyepatchPainter(),
        );
      case 'crown':
        return CustomPaint(
          size: Size(accessorySize, accessorySize * 0.5),
          painter: CrownPainter(),
        );
      case 'tophat':
        return CustomPaint(
          size: Size(accessorySize * 0.6, accessorySize * 0.7),
          painter: TopHatPainter(),
        );
      case 'headphones':
        return CustomPaint(
          size: Size(accessorySize, accessorySize * 0.5),
          painter: HeadphonesPainter(),
        );
      case 'bowtie':
        return CustomPaint(
          size: Size(accessorySize * 0.5, accessorySize * 0.3),
          painter: BowtiePainter(),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

/// Custom painter for the tomato character
class TomatoPainter extends CustomPainter {
  final Color color;
  final Color highlightColor;
  final double progress;
  final bool isCollectible;

  TomatoPainter({
    required this.color,
    required this.highlightColor,
    required this.progress,
    required this.isCollectible,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + size.height * 0.05);
    final radius =
        size.width * 0.45; // Increased from 0.4 to make tomato larger

    // Draw shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withAlpha(30)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, size.height * 0.9),
        width: radius * 1.5,
        height: radius * 0.3,
      ),
      shadowPaint,
    );

    // Draw tomato body
    final bodyPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        radius: 1.2,
        colors: [highlightColor, color],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    // Draw slightly squished circle (tomato shape)
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(1.0, 0.9); // Slightly squished vertically
    canvas.translate(-center.dx, -center.dy);
    canvas.drawCircle(center, radius, bodyPaint);
    canvas.restore();

    // Draw tomato segments (subtle lines)
    _drawTomatoSegments(canvas, center, radius);

    // Draw highlight/shine
    _drawHighlight(canvas, center, radius);

    // Draw stem and leaves
    _drawStemAndLeaves(canvas, size, center, radius);

    // Draw cute face
    _drawFace(canvas, center, radius);

    // Draw sparkles if collectible
    if (isCollectible) {
      _drawSparkles(canvas, center, radius);
    }
  }

  void _drawTomatoSegments(Canvas canvas, Offset center, double radius) {
    final segmentPaint = Paint()
      ..color = Colors.black.withAlpha(10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw subtle segment lines
    for (int i = 0; i < 4; i++) {
      final angle = (i * math.pi / 2) + (math.pi / 4);
      final path = Path();
      path.moveTo(
        center.dx + math.cos(angle) * radius * 0.1,
        center.dy - radius * 0.8,
      );
      path.quadraticBezierTo(
        center.dx + math.cos(angle) * radius * 0.8,
        center.dy,
        center.dx + math.cos(angle) * radius * 0.1,
        center.dy + radius * 0.7,
      );
      canvas.drawPath(path, segmentPaint);
    }
  }

  void _drawHighlight(Canvas canvas, Offset center, double radius) {
    final highlightPaint = Paint()
      ..color = Colors.white.withAlpha(80)
      ..style = PaintingStyle.fill;

    // Main highlight
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - radius * 0.25, center.dy - radius * 0.25),
        width: radius * 0.4,
        height: radius * 0.25,
      ),
      highlightPaint,
    );

    // Small secondary highlight
    final smallHighlightPaint = Paint()..color = Colors.white.withAlpha(60);
    canvas.drawCircle(
      Offset(center.dx - radius * 0.35, center.dy - radius * 0.45),
      radius * 0.08,
      smallHighlightPaint,
    );
  }

  void _drawStemAndLeaves(
    Canvas canvas,
    Size size,
    Offset center,
    double radius,
  ) {
    final stemPaint = Paint()
      ..color = AppColors.leafGreenDark
      ..style = PaintingStyle.fill;

    // Draw stem
    final stemPath = Path();
    stemPath.moveTo(center.dx - 4, center.dy - radius * 0.85);
    stemPath.quadraticBezierTo(
      center.dx,
      center.dy - radius * 1.1,
      center.dx + 4,
      center.dy - radius * 0.85,
    );
    stemPath.lineTo(center.dx + 3, center.dy - radius * 0.8);
    stemPath.quadraticBezierTo(
      center.dx,
      center.dy - radius * 0.95,
      center.dx - 3,
      center.dy - radius * 0.8,
    );
    stemPath.close();
    canvas.drawPath(stemPath, stemPaint);

    // Draw leaves
    final leafPaint = Paint()
      ..color = AppColors.leafGreen
      ..style = PaintingStyle.fill;

    // Right leaf
    final rightLeafPath = Path();
    rightLeafPath.moveTo(center.dx, center.dy - radius * 0.85);
    rightLeafPath.quadraticBezierTo(
      center.dx + radius * 0.5,
      center.dy - radius * 1.1,
      center.dx + radius * 0.4,
      center.dy - radius * 0.7,
    );
    rightLeafPath.quadraticBezierTo(
      center.dx + radius * 0.2,
      center.dy - radius * 0.85,
      center.dx,
      center.dy - radius * 0.85,
    );
    canvas.drawPath(rightLeafPath, leafPaint);

    // Left leaf
    final leftLeafPath = Path();
    leftLeafPath.moveTo(center.dx, center.dy - radius * 0.85);
    leftLeafPath.quadraticBezierTo(
      center.dx - radius * 0.5,
      center.dy - radius * 1.1,
      center.dx - radius * 0.4,
      center.dy - radius * 0.7,
    );
    leftLeafPath.quadraticBezierTo(
      center.dx - radius * 0.2,
      center.dy - radius * 0.85,
      center.dx,
      center.dy - radius * 0.85,
    );
    canvas.drawPath(leftLeafPath, leafPaint);
  }

  void _drawFace(Canvas canvas, Offset center, double radius) {
    // Draw CUTER Face
    // Bigger eyes, positioned lower and closer together for "kawaii" look
    final eyePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final eyeWhitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Eye config
    final eyeY = center.dy - radius * 0.05; // Slightly lower than before
    final eyeXOffset = radius * 0.22; // Closer together
    final eyeWidth = radius * 0.18; // Rounder/Bigger
    final eyeHeight = radius * 0.22;

    // LEFT EYE
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - eyeXOffset, eyeY),
        width: eyeWidth,
        height: eyeHeight,
      ),
      eyePaint,
    );
    // Left shine (top right of pupil)
    canvas.drawCircle(
      Offset(center.dx - eyeXOffset + eyeWidth * 0.2, eyeY - eyeHeight * 0.2),
      radius * 0.05,
      eyeWhitePaint,
    );

    // RIGHT EYE
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + eyeXOffset, eyeY),
        width: eyeWidth,
        height: eyeHeight,
      ),
      eyePaint,
    );
    // Right shine
    canvas.drawCircle(
      Offset(center.dx + eyeXOffset + eyeWidth * 0.2, eyeY - eyeHeight * 0.2),
      radius * 0.05,
      eyeWhitePaint,
    );

    // CUTE MOUTH
    // Smaller, simpler curve
    final smilePaint = Paint()
      ..color = Colors.black.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.03
      ..strokeCap = StrokeCap.round;

    final smilePath = Path();
    smilePath.moveTo(center.dx - radius * 0.1, center.dy + radius * 0.15);
    smilePath.quadraticBezierTo(
      center.dx,
      center.dy + radius * 0.22, // Subtle curve
      center.dx + radius * 0.1,
      center.dy + radius * 0.15,
    );
    canvas.drawPath(smilePath, smilePaint);

    // CHEEKS
    // Rosy and soft
    final cheekPaint = Paint()
      ..color = const Color(0xFFFF8A80)
          .withAlpha(100) // Soft red/pink
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - radius * 0.35, center.dy + radius * 0.08),
        width: radius * 0.15,
        height: radius * 0.1,
      ),
      cheekPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + radius * 0.35, center.dy + radius * 0.08),
        width: radius * 0.15,
        height: radius * 0.1,
      ),
      cheekPaint,
    );
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
