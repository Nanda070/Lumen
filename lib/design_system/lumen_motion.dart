import 'package:flutter/animation.dart';

/// Quiet premium motion — soft springs, no neon bounce.
abstract final class LumenMotion {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 480);

  static const Curve spring = Curves.easeOutCubic;
  static const Curve softSpring = Curves.easeOutBack;
}
