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
  });

  final String label;
  final String value;
  final String? suffix;
  final LinearGradient gradient;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final glow = gradient.colors.first;

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
              padding: const EdgeInsets.fromLTRB(
                LumenSpacing.md,
                LumenSpacing.md,
                LumenSpacing.md,
                LumenSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.labelMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.82),
                    ),
                  ),
                  const SizedBox(height: LumenSpacing.sm),
                  BigNumber(
                    value,
                    suffix: suffix,
                    color: Colors.white,
                    style: theme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 32,
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
