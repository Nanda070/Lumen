import 'package:flutter/material.dart';

/// Premium charcoal — violet bloom + cream CTA; red/blue stay semantic.
abstract final class LumenColors {
  static const Color bg = Color(0xFF090A0D);
  static const Color bgElevated = Color(0xFF0E1015);
  static const Color surface = Color(0xFF14161C);
  static const Color surfaceRaised = Color(0xFF1B1E27);
  static const Color text = Color(0xFFF4F2EC);
  static const Color textMuted = Color(0xFF8B919C);
  static const Color accentRed = Color(0xFFC53B4A);
  static const Color accentBlue = Color(0xFF5B7CFF);
  static const Color accentViolet = Color(0xFF8B6CFF);
  static const Color accentCream = Color(0xFFE6DDD0);
  static const Color accentMint = Color(0xFF5ECF9A);

  /// Kebo finance brand (presentation layer).
  static const Color keboPrimary = Color(0xFF6934D2);
  static const Color keboPrimarySoft = Color(0x266934D2);
  static const Color keboLavender = Color(0xFFC4A8FF);
  static const Color keboLavenderFill = Color(0xFF9C88FF);
  static const Color keboOver = Color(0xFFED706B);
  static const Color keboSecondary = Color(0xFF260035);
  static const Color keboMuted = Color(0xFF606A84);
  static const Color keboBorder = Color(0xFF3A3A3C);
  static const Color keboCard = Color(0xFF1C1C1E);

  /// OpenNutriTracker-inspired macros (dark palette).
  static const Color nutriCarbs = Color(0xFFF2B45A);
  static const Color nutriFat = Color(0xFFFF937B);
  static const Color nutriProtein = Color(0xFF49C9B8);
  static const Color nutriRing = Color(0xFF8B6CFF);

  /// GymMane-inspired training (ember / brass accents on charcoal).
  static const Color gymEmber = Color(0xFFFFFFFF);
  static const Color gymOnEmber = Color(0xFF0A0A0A);
  static const Color gymEmberSoft = Color(0x1AFFFFFF);
  static const Color gymAccent = Color(0xFFD9A184);
  static const Color gymBrass = Color(0xFFB98F72);
  static const Color gymBorder = Color(0xFF2A2A2A);
  static const Color gymRaised = Color(0xFF161616);
  static const Color gymRaised2 = Color(0xFF202020);

  /// Glass fill ~8% white.
  static const Color glassFill = Color(0x14FFFFFF);

  /// Hairline ~12% white.
  static const Color glassStroke = Color(0x1FFFFFFF);

  /// Soft violet edge for module tiles.
  static const Color glassStrokeViolet = Color(0x2E8B6CFF);

  static const Color divider = Color(0x14FFFFFF);

  static const LinearGradient gradDusk = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3D5AFE), Color(0xFF7C4DFF)],
  );

  static const LinearGradient gradEmber = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6B3D), Color(0xFFFFB347)],
  );

  /// Soft ambient bloom behind content.
  static const RadialGradient ambienceViolet = RadialGradient(
    center: Alignment(0.0, -0.35),
    radius: 1.1,
    colors: [
      Color(0x338B6CFF),
      Color(0x148B6CFF),
      Color(0x00090A0D),
    ],
    stops: [0.0, 0.45, 1.0],
  );

  static const RadialGradient ambienceWarm = RadialGradient(
    center: Alignment(0.85, 0.75),
    radius: 0.9,
    colors: [
      Color(0x1AFF6B3D),
      Color(0x00090A0D),
    ],
  );
}
