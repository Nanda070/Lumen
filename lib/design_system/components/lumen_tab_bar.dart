import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../lumen_colors.dart';
import '../lumen_motion.dart';
import '../lumen_radii.dart';
import '../lumen_spacing.dart';

class LumenNavItem {
  const LumenNavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

/// Floating glass island tab bar — matte + luminous edge.
class LumenTabBar extends StatelessWidget {
  const LumenTabBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onSelect,
  });

  final List<LumenNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        LumenSpacing.pagePadding,
        0,
        LumenSpacing.pagePadding,
        bottom > 0 ? bottom : LumenSpacing.sm,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: LumenRadii.island,
          boxShadow: [
            BoxShadow(
              color: LumenColors.accentViolet.withValues(alpha: 0.14),
              blurRadius: 32,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.45),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: LumenRadii.island,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 36, sigmaY: 36),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xCC12141A),
                borderRadius: LumenRadii.island,
                border: Border.all(color: LumenColors.glassStroke, width: 1),
              ),
              child: SizedBox(
                height: 68,
                child: Row(
                  children: [
                    for (var i = 0; i < items.length; i++)
                      Expanded(
                        child: _TabItem(
                          item: items[i],
                          selected: i == currentIndex,
                          onTap: () => onSelect(i),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final LumenNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? LumenColors.accentBlue : LumenColors.textMuted;

    return InkWell(
      onTap: onTap,
      splashColor: LumenColors.accentViolet.withValues(alpha: 0.14),
      highlightColor: Colors.transparent,
      child: AnimatedDefaultTextStyle(
        duration: LumenMotion.fast,
        curve: LumenMotion.spring,
        style: Theme.of(context).textTheme.labelSmall!.copyWith(
          color: color,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: selected ? 1.08 : 1.0,
              duration: LumenMotion.fast,
              curve: LumenMotion.spring,
              child: AnimatedSwitcher(
                duration: LumenMotion.fast,
                child: Icon(
                  selected ? item.selectedIcon : item.icon,
                  key: ValueKey(selected),
                  size: 24,
                  color: color,
                ),
              ),
            ),
            const SizedBox(height: LumenSpacing.xxs),
            Text(item.label),
          ],
        ),
      ),
    );
  }
}

List<LumenNavItem> lumenNavItems({
  required String today,
  required String calendar,
  required String tasks,
  required String finance,
  required String more,
}) {
  return [
    LumenNavItem(
      label: today,
      icon: PhosphorIconsRegular.sun,
      selectedIcon: PhosphorIconsFill.sun,
    ),
    LumenNavItem(
      label: calendar,
      icon: PhosphorIconsRegular.calendarBlank,
      selectedIcon: PhosphorIconsFill.calendarBlank,
    ),
    LumenNavItem(
      label: tasks,
      icon: PhosphorIconsRegular.checkSquare,
      selectedIcon: PhosphorIconsFill.checkSquare,
    ),
    LumenNavItem(
      label: finance,
      icon: PhosphorIconsRegular.wallet,
      selectedIcon: PhosphorIconsFill.wallet,
    ),
    LumenNavItem(
      label: more,
      icon: PhosphorIconsRegular.dotsThreeOutline,
      selectedIcon: PhosphorIconsFill.dotsThreeOutline,
    ),
  ];
}
