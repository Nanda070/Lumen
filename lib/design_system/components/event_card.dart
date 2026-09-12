import 'package:flutter/material.dart';

import '../lumen_colors.dart';
import '../lumen_radii.dart';
import '../lumen_spacing.dart';
import 'glow_card.dart';

/// Calendar event chip — accent stripe on glow tile.
class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.title,
    required this.timeLabel,
    this.accent = LumenColors.accentBlue,
    this.onTap,
  });

  final String title;
  final String timeLabel;
  final Color accent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return GlowCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 3,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(LumenRadii.md),
                ),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.45),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  LumenSpacing.md,
                  LumenSpacing.md,
                  LumenSpacing.md,
                  LumenSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.titleMedium),
                    const SizedBox(height: 4),
                    Text(timeLabel, style: theme.bodySmall),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
