import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'lumen_colors.dart';

/// Outfit — geometric premium sans; tabular figures for money/dates.
abstract final class LumenTypography {
  static TextTheme textTheme() {
    final base = GoogleFonts.outfitTextTheme().apply(
      bodyColor: LumenColors.text,
      displayColor: LumenColors.text,
    );

    TextStyle merge(TextStyle? s, TextStyle o) => (s ?? const TextStyle()).merge(o);

    return TextTheme(
      displayLarge: merge(
        base.displayLarge,
        const TextStyle(
          fontSize: 44,
          fontWeight: FontWeight.w700,
          height: 1.05,
          letterSpacing: -1.4,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
      ),
      displayMedium: merge(
        base.displayMedium,
        const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          height: 1.1,
          letterSpacing: -1.1,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
      ),
      headlineLarge: merge(
        base.headlineLarge,
        const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w600,
          height: 1.15,
          letterSpacing: -0.8,
        ),
      ),
      headlineMedium: merge(
        base.headlineMedium,
        const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          height: 1.2,
          letterSpacing: -0.5,
        ),
      ),
      titleLarge: merge(
        base.titleLarge,
        const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.3,
          letterSpacing: -0.2,
        ),
      ),
      titleMedium: merge(
        base.titleMedium,
        const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.35,
        ),
      ),
      bodyLarge: merge(
        base.bodyLarge,
        const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.45,
        ),
      ),
      bodyMedium: merge(
        base.bodyMedium,
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.45,
        ),
      ),
      bodySmall: merge(
        base.bodySmall,
        const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.4,
          color: LumenColors.textMuted,
        ),
      ),
      labelLarge: merge(
        base.labelLarge,
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.3,
        ),
      ),
      labelMedium: merge(
        base.labelMedium,
        const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.3,
          color: LumenColors.textMuted,
        ),
      ),
      labelSmall: merge(
        base.labelSmall,
        const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          height: 1.3,
          color: LumenColors.textMuted,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
