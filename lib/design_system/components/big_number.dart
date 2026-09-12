import 'package:flutter/material.dart';

import '../lumen_colors.dart';
import '../lumen_typography.dart';

/// Large tabular figure for finance totals and dates.
class BigNumber extends StatelessWidget {
  const BigNumber(
    this.value, {
    super.key,
    this.suffix,
    this.color = LumenColors.text,
    this.suffixColor,
    this.style,
  });

  final String value;
  final String? suffix;
  final Color color;
  final Color? suffixColor;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final base =
        style ??
        LumenTypography.textTheme().displayMedium!.copyWith(color: color);

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: value, style: base),
          if (suffix != null)
            TextSpan(
              text: ' $suffix',
              style: base.copyWith(
                fontSize: (base.fontSize ?? 36) * 0.42,
                color: suffixColor ?? LumenColors.textMuted,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.2,
              ),
            ),
        ],
      ),
    );
  }
}
