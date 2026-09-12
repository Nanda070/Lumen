import 'package:flutter/painting.dart';

/// Radii 20–24 per STYLE.md (premium soft blocks).
abstract final class LumenRadii {
  static const double sm = 14;
  static const double md = 20;
  static const double lg = 24;
  static const double xl = 28;

  static const BorderRadius card = BorderRadius.all(Radius.circular(md));
  static const BorderRadius panel = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius island = BorderRadius.all(Radius.circular(28));
}
