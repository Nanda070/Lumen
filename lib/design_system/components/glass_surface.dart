import 'dart:ui';

import 'package:flutter/material.dart';

import '../lumen_colors.dart';
import '../lumen_radii.dart';

/// Frosted glass panel — soft fill + blur + luminous hairline.
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.borderRadius = LumenRadii.panel,
    this.blur = 32,
    this.padding,
    this.strokeColor = LumenColors.glassStroke,
    this.fillColor = LumenColors.glassFill,
    this.glowColor,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final double blur;
  final EdgeInsetsGeometry? padding;
  final Color strokeColor;
  final Color fillColor;
  final Color? glowColor;

  @override
  Widget build(BuildContext context) {
    final panel = ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: borderRadius,
            border: Border.all(color: strokeColor, width: 1),
          ),
          child: padding == null
              ? child
              : Padding(padding: padding!, child: child),
        ),
      ),
    );

    if (glowColor == null) return panel;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: glowColor!.withValues(alpha: 0.16),
            blurRadius: 28,
            spreadRadius: 0,
          ),
        ],
      ),
      child: panel,
    );
  }
}
