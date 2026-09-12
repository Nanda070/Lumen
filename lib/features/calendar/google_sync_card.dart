import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../core/google_config.dart';
import '../../data/app_database.dart';
import '../../design_system/design_system.dart';
import '../../l10n/app_localizations.dart';
import 'google_calendar_sync.dart';

/// Compact Google Calendar connect / sync card for More or Calendar.
class GoogleSyncCard extends StatefulWidget {
  const GoogleSyncCard({super.key, required this.database});

  final AppDatabase database;

  @override
  State<GoogleSyncCard> createState() => _GoogleSyncCardState();
}

class _GoogleSyncCardState extends State<GoogleSyncCard> {
  late final GoogleCalendarSync _sync;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _sync = GoogleCalendarSync(widget.database);
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    final l10n = AppLocalizations.of(context);
    try {
      await action();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.googleSyncOk)),
      );
    } on GoogleNotConfiguredException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.googleNeedsConfig)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.googleSyncError)),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;

    return StreamBuilder<GoogleSyncStateData?>(
      stream: widget.database.watchGoogleSyncState(),
      builder: (context, snap) {
        final state = snap.data;
        final connected = state?.connected ?? false;
        final email = state?.accountEmail;

        return GlowCard(
          violetEdge: true,
          padding: const EdgeInsets.all(LumenSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    PhosphorIconsRegular.googleLogo,
                    color: LumenColors.accentViolet,
                  ),
                  const SizedBox(width: LumenSpacing.sm),
                  Expanded(
                    child: Text(
                      l10n.googleCalendarTitle,
                      style: theme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (_busy)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
              const SizedBox(height: LumenSpacing.xs),
              Text(
                !GoogleConfig.isConfigured
                    ? l10n.googleNeedsConfig
                    : connected
                        ? (email ?? l10n.googleConnected)
                        : l10n.googleDisconnected,
                style: theme.bodySmall?.copyWith(color: LumenColors.textMuted),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (state?.lastError != null && state!.lastError!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  state.lastError!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.labelSmall?.copyWith(
                    color: LumenColors.accentRed,
                  ),
                ),
              ],
              const SizedBox(height: LumenSpacing.sm),
              Row(
                children: [
                  if (!connected)
                    TextButton(
                      onPressed: _busy ? null : () => _run(_sync.connect),
                      child: Text(l10n.googleConnect),
                    )
                  else ...[
                    TextButton(
                      onPressed: _busy ? null : () => _run(_sync.syncNow),
                      child: Text(l10n.googleSyncNow),
                    ),
                    TextButton(
                      onPressed: _busy ? null : () => _run(_sync.disconnect),
                      child: Text(l10n.googleDisconnect),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
