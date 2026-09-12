import 'package:flutter/material.dart';

import '../lumen_colors.dart';
import '../lumen_radii.dart';

/// Raised dark tile with optional violet edge (module grid language).
class GlowCard extends StatelessWidget {
  const GlowCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.borderRadius = LumenRadii.card,
    this.violetEdge = false,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final BorderRadius borderRadius;
  final bool violetEdge;

  @override
  Widget build(BuildContext context) {
    final stroke = violetEdge
        ? LumenColors.glassStrokeViolet
        : LumenColors.glassStroke;

    final ink = Ink(
      decoration: BoxDecoration(
        color: LumenColors.surfaceRaised.withValues(alpha: 0.92),
        borderRadius: borderRadius,
        border: Border.all(color: stroke, width: 1),
        boxShadow: violetEdge
            ? [
                BoxShadow(
                  color: LumenColors.accentViolet.withValues(alpha: 0.12),
                  blurRadius: 24,
                  spreadRadius: -2,
                ),
              ]
            : null,
      ),
      child: padding == null
          ? child
          : Padding(padding: padding!, child: child),
    );

    final body = Material(
      color: Colors.transparent,
      child: onTap == null
          ? ink
          : InkWell(
              onTap: onTap,
              borderRadius: borderRadius,
              splashColor: LumenColors.accentViolet.withValues(alpha: 0.12),
              highlightColor: Colors.transparent,
              child: ink,
            ),
    );

    if (!violetEdge) return body;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: LumenColors.accentViolet.withValues(alpha: 0.12),
            blurRadius: 24,
            spreadRadius: -2,
          ),
        ],
      ),
      child: body,
    );
  }
}
