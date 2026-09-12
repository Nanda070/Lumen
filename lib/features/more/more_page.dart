import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../design_system/design_system.dart';
import '../../l10n/app_localizations.dart';
import '../../shell/module_scaffold.dart';

class MorePage extends StatelessWidget {
  const MorePage({
    super.key,
    required this.locale,
    required this.onLocaleChanged,
    required this.displayName,
    required this.currencyCode,
  });

  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;
  final String displayName;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;

    return ModuleScaffold(
      title: l10n.navMore,
      subtitle: l10n.moreSubtitle,
      body: Column(
        children: [
          GlowCard(
            violetEdge: true,
            padding: const EdgeInsets.all(LumenSpacing.lg),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(displayName, style: theme.titleLarge),
                      const SizedBox(height: LumenSpacing.xxs),
                      Text(
                        l10n.moreProfileMeta(currencyCode),
                        style: theme.bodySmall?.copyWith(
                          color: LumenColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  PhosphorIconsRegular.userCircle,
                  color: LumenColors.accentViolet,
                  size: 32,
                ),
              ],
            ),
          ),
          const SizedBox(height: LumenSpacing.lg),
          _RoomTile(
            icon: PhosphorIconsRegular.circleDashed,
            label: l10n.moreHabits,
          ),
          _RoomTile(
            icon: PhosphorIconsRegular.clock,
            label: l10n.moreRoutine,
          ),
          _RoomTile(
            icon: PhosphorIconsRegular.forkKnife,
            label: l10n.moreNutrition,
          ),
          _RoomTile(
            icon: PhosphorIconsRegular.barbell,
            label: l10n.moreTraining,
          ),
          const SizedBox(height: LumenSpacing.xl),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(l10n.moreSettings, style: theme.titleLarge),
          ),
          const SizedBox(height: LumenSpacing.sm),
          GlassSurface(
            padding: const EdgeInsets.all(LumenSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.language, style: theme.labelMedium),
                const SizedBox(height: LumenSpacing.sm),
                Row(
                  children: [
                    _LangChip(
                      label: l10n.languageEnglish,
                      selected: locale.languageCode == 'en',
                      onTap: () => onLocaleChanged(const Locale('en')),
                    ),
                    const SizedBox(width: LumenSpacing.xs),
                    _LangChip(
                      label: l10n.languageRussian,
                      selected: locale.languageCode == 'ru',
                      onTap: () => onLocaleChanged(const Locale('ru')),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: LumenSpacing.xl),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(l10n.moreAbout, style: theme.titleLarge),
          ),
          const SizedBox(height: LumenSpacing.sm),
          GlowCard(
            violetEdge: true,
            padding: const EdgeInsets.all(LumenSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.moreAboutBody, style: theme.titleMedium),
                const SizedBox(height: LumenSpacing.md),
                _ContactLine(
                  label: l10n.moreContactEmail,
                  value: 'adnan.huseynli1@gmail.com',
                ),
                _ContactLine(
                  label: l10n.moreContactTelegram,
                  value: 'nanda070',
                ),
                _ContactLine(
                  label: l10n.moreContactDiscord,
                  value: 'nandak070',
                ),
                _ContactLine(
                  label: l10n.moreContactServer,
                  value: 'discord.gg/cheterin',
                ),
                _ContactLine(
                  label: l10n.moreContactGithub,
                  value: 'nanda070',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactLine extends StatelessWidget {
  const _ContactLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: LumenSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: theme.labelMedium?.copyWith(color: LumenColors.textMuted),
            ),
          ),
          Expanded(
            child: Text(value, style: theme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _RoomTile extends StatelessWidget {
  const _RoomTile({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: LumenSpacing.sm),
      child: GlowCard(
        violetEdge: true,
        padding: const EdgeInsets.symmetric(
          horizontal: LumenSpacing.md,
          vertical: LumenSpacing.md,
        ),
        child: Row(
          children: [
            Icon(icon, color: LumenColors.accentViolet, size: 22),
            const SizedBox(width: LumenSpacing.sm),
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.titleMedium),
            ),
            Text(
              AppLocalizations.of(context).roomComingSoon,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  const _LangChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? LumenColors.accentCream
          : LumenColors.surfaceRaised,
      borderRadius: LumenRadii.card,
      child: InkWell(
        onTap: onTap,
        borderRadius: LumenRadii.card,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: LumenSpacing.md,
            vertical: LumenSpacing.sm,
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: selected ? LumenColors.bg : LumenColors.text,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
