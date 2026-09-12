import 'package:flutter/material.dart';

import '../lumen_colors.dart';
import '../lumen_radii.dart';
import '../lumen_spacing.dart';
import 'big_number.dart';

/// Hero metric block — dusk/ember gradient + soft outer glow (ref dashboard).
class GradientMetricCard extends StatelessWidget {
  const GradientMetricCard({
    super.key,
    required this.label,
    required this.value,
    this.suffix,
    this.gradient = LumenColors.gradEmber,
    this.onTap,
    this.compact = false,
  });

  final String label;
  final String value;
  final String? suffix;
  final LinearGradient gradient;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final glow = gradient.colors.first;
    final valueSize = compact ? 24.0 : 28.0;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: LumenRadii.card,
        boxShadow: [
          BoxShadow(
            color: glow.withValues(alpha: 0.28),
            blurRadius: 28,
            spreadRadius: -4,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: LumenRadii.card,
          child: Ink(
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: LumenRadii.card,
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                LumenSpacing.md,
                compact ? LumenSpacing.sm : LumenSpacing.md,
                LumenSpacing.md,
                compact ? LumenSpacing.md : LumenSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.labelMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.82),
                      fontSize: compact ? 11 : 12,
                    ),
                  ),
                  SizedBox(height: compact ? 6 : LumenSpacing.sm),
                  BigNumber(
                    value,
                    suffix: suffix,
                    color: Colors.white,
                    style: theme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontSize: valueSize,
                      height: 1.05,
                    ),
                    suffixColor: Colors.white.withValues(alpha: 0.72),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
