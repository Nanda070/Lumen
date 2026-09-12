import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'lumen_colors.dart';
import 'lumen_radii.dart';
import 'lumen_typography.dart';

abstract final class LumenTheme {
  static ThemeData dark() {
    final textTheme = LumenTypography.textTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: LumenColors.bg,
      colorScheme: const ColorScheme.dark(
        surface: LumenColors.surface,
        primary: LumenColors.accentBlue,
        secondary: LumenColors.accentViolet,
        tertiary: LumenColors.accentCream,
        onSurface: LumenColors.text,
        onPrimary: LumenColors.text,
        onSecondary: LumenColors.text,
        onTertiary: LumenColors.bg,
        error: LumenColors.accentRed,
      ),
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: LumenColors.bg.withValues(alpha: 0),
        foregroundColor: LumenColors.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: textTheme.headlineMedium,
      ),
      dividerColor: LumenColors.divider,
      dividerTheme: const DividerThemeData(
        color: LumenColors.divider,
        thickness: 1,
        space: 1,
      ),
      cardTheme: const CardThemeData(
        color: LumenColors.surfaceRaised,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: LumenRadii.card),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: LumenColors.surfaceRaised,
        hintStyle: textTheme.bodyMedium?.copyWith(color: LumenColors.textMuted),
        border: const OutlineInputBorder(
          borderRadius: LumenRadii.card,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: LumenRadii.card,
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: LumenRadii.card,
          borderSide: BorderSide(color: LumenColors.accentViolet, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: LumenColors.accentCream,
          foregroundColor: LumenColors.bg,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: const RoundedRectangleBorder(borderRadius: LumenRadii.card),
          textStyle: textTheme.labelLarge?.copyWith(
            color: LumenColors.bg,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: LumenColors.accentBlue,
          textStyle: textTheme.labelLarge,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: LumenColors.surface.withValues(alpha: 0.72),
        indicatorColor: LumenColors.accentViolet.withValues(alpha: 0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.labelSmall?.copyWith(
            color: selected ? LumenColors.accentBlue : LumenColors.textMuted,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: selected ? LumenColors.accentBlue : LumenColors.textMuted,
          );
        }),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: LumenColors.bgElevated,
        selectedIconTheme: const IconThemeData(
          color: LumenColors.accentBlue,
          size: 24,
        ),
        unselectedIconTheme: const IconThemeData(
          color: LumenColors.textMuted,
          size: 24,
        ),
        selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: LumenColors.accentBlue,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: textTheme.labelMedium,
        indicatorColor: LumenColors.accentViolet.withValues(alpha: 0.18),
      ),
      splashFactory: InkSparkle.splashFactory,
    );
  }
}
