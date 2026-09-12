import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import '../l10n/app_localizations.dart';

/// Shared large-title page chrome for module hubs and rooms.
class ModuleScaffold extends StatelessWidget {
  const ModuleScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.body,
    this.slivers,
  });

  final String title;
  final String subtitle;
  final Widget? trailing;
  final Widget? body;
  final List<Widget>? slivers;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    // Shell already applies SafeArea(top); keep premium air below it.
    const topAir = LumenSpacing.lg;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              LumenSpacing.pagePadding,
              topAir,
              LumenSpacing.pagePadding,
              LumenSpacing.lg,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.headlineLarge,
                      ),
                      const SizedBox(height: LumenSpacing.xs),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.bodyMedium?.copyWith(
                          color: LumenColors.textMuted,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
        ),
        ...?slivers,
        if (body != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: LumenSpacing.pagePadding,
              ),
              child: body,
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 140)),
      ],
    );
  }
}

class ComingSoonRoom extends StatelessWidget {
  const ComingSoonRoom({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;

    return ModuleScaffold(
      title: title,
      subtitle: subtitle,
      body: GlowCard(
        violetEdge: true,
        padding: const EdgeInsets.all(LumenSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.roomComingSoon,
              style: theme.titleMedium?.copyWith(
                color: LumenColors.accentViolet,
              ),
            ),
            const SizedBox(height: LumenSpacing.xs),
            Text(
              subtitle,
              style: theme.bodyMedium?.copyWith(
                color: LumenColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
