import 'package:flutter/material.dart';

import '../lumen_colors.dart';

/// Soft violet + warm blooms behind the shell (ref ambient light).
class AtmosphereBackground extends StatelessWidget {
  const AtmosphereBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: LumenColors.bg),
        const DecoratedBox(
          decoration: BoxDecoration(gradient: LumenColors.ambienceViolet),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(gradient: LumenColors.ambienceWarm),
        ),
        child,
      ],
    );
  }
}
