import 'package:flutter/material.dart';

import '../lumen_colors.dart';
import '../lumen_spacing.dart';
import 'big_number.dart';
import 'glow_card.dart';

/// Finance ledger row — category, note, signed amount.
class TransactionRow extends StatelessWidget {
  const TransactionRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amountLabel,
    required this.isExpense,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String amountLabel;
  final bool isExpense;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final amountColor =
        isExpense ? LumenColors.accentRed : LumenColors.accentMint;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: LumenSpacing.pagePadding,
        vertical: LumenSpacing.xs,
      ),
      child: GlowCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(
          horizontal: LumenSpacing.md,
          vertical: LumenSpacing.md,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.titleMedium),
                  const SizedBox(height: 2),
                  Text(subtitle, style: theme.bodySmall),
                ],
              ),
            ),
            BigNumber(
              amountLabel,
              color: amountColor,
              style: theme.titleLarge?.copyWith(
                color: amountColor,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
