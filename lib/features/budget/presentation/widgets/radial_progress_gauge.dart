import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// A glassmorphic ring-shaped progress gauge: a blurred translucent glass
/// disc, a soft color-matched outer glow, and a gradient progress stroke
/// (a light tint sweeping into the base color) with rounded caps -- the
/// Budget/Financial-Health screens' signature visual, distinct from the
/// Dashboard's flat linear bars. Every instance is visually unique since
/// its gradient is derived from the [color] passed in.
class RadialProgressGauge extends StatelessWidget {
  const RadialProgressGauge({
    super.key,
    required this.progress,
    required this.size,
    required this.color,
    this.strokeWidth = 8,
    this.child,
  });

  final double progress;
  final double size;
  final Color color;
  final double strokeWidth;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Soft color-matched outer glow.
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.35),
                  blurRadius: size * 0.18,
                  spreadRadius: size * 0.01,
                ),
              ],
            ),
          ),
          // Blurred glass disc.
          ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? AppColors.glassOverlayDark
                      : AppColors.glassOverlayLight,
                  border: Border.all(color: color.withValues(alpha: 0.25)),
                ),
              ),
            ),
          ),
          CustomPaint(
            size: Size(size, size),
            painter: _GaugePainter(
              progress: progress.clamp(0, 1),
              color: color,
              strokeWidth: strokeWidth,
              trackColor: theme.colorScheme.outline.withValues(alpha: 0.25),
            ),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
    required this.trackColor,
  });

  final double progress;
  final Color color;
  final double strokeWidth;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = (size.shortestSide - strokeWidth) / 2;
    final Rect arcRect = Rect.fromCircle(center: center, radius: radius);

    final Paint trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0) return;

    final double sweepAngle = 2 * pi * progress;
    final Paint progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: sweepAngle,
        transform: const GradientRotation(-pi / 2),
        colors: [Color.lerp(color, Colors.white, 0.45)!, color],
      ).createShader(arcRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(arcRect, -pi / 2, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.trackColor != trackColor;
  }
}
