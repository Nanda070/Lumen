import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/app_database.dart';
import '../../design_system/design_system.dart';
import '../../l10n/app_localizations.dart';
import 'lumen_backup.dart';

Future<void> showBackupSheet({
  required BuildContext context,
  required AppDatabase database,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _BackupSheet(database: database),
  );
}

class _BackupSheet extends StatefulWidget {
  const _BackupSheet({required this.database});

  final AppDatabase database;

  @override
  State<_BackupSheet> createState() => _BackupSheetState();
}

class _BackupSheetState extends State<_BackupSheet> {
  bool _busy = false;

  Future<void> _export() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await LumenBackup(widget.database).exportAndShare();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.moreBackupExported)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.moreBackupFailed('$e'))),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore(LumenRestoreMode mode) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      final result =
          await LumenBackup(widget.database).pickAndRestore(mode);
      if (!mounted) return;
      if (result.cancelled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.moreBackupCancelled)),
        );
        return;
      }
      if (!result.ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.moreBackupFailed(result.error ?? 'unknown')),
          ),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.moreBackupRestored)),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.moreBackupFailed('$e'))),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: GlassSurface(
        padding: const EdgeInsets.fromLTRB(
          LumenSpacing.pagePadding,
          LumenSpacing.lg,
          LumenSpacing.pagePadding,
          LumenSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.moreBackup, style: theme.titleLarge),
            const SizedBox(height: LumenSpacing.xs),
            Text(
              l10n.moreBackupHint,
              style: theme.bodySmall?.copyWith(color: LumenColors.textMuted),
            ),
            const SizedBox(height: LumenSpacing.lg),
            FilledButton.icon(
              onPressed: _busy ? null : _export,
              icon: const Icon(PhosphorIconsRegular.downloadSimple),
              label: Text(l10n.moreBackupExport),
            ),
            const SizedBox(height: LumenSpacing.md),
            Text(l10n.moreBackupRestore, style: theme.titleMedium),
            const SizedBox(height: LumenSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _busy
                        ? null
                        : () => _restore(LumenRestoreMode.replace),
                    child: Text(l10n.moreBackupReplace),
                  ),
                ),
                const SizedBox(width: LumenSpacing.sm),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _busy
                        ? null
                        : () => _restore(LumenRestoreMode.merge),
                    child: Text(l10n.moreBackupMerge),
                  ),
                ),
              ],
            ),
            const SizedBox(height: LumenSpacing.sm),
            Text(
              '${l10n.moreBackupReplace}: ${l10n.moreBackupReplaceBody}',
              style: theme.labelSmall?.copyWith(color: LumenColors.textMuted),
            ),
            const SizedBox(height: 4),
            Text(
              '${l10n.moreBackupMerge}: ${l10n.moreBackupMergeBody}',
              style: theme.labelSmall?.copyWith(color: LumenColors.textMuted),
            ),
            if (_busy) ...[
              const SizedBox(height: LumenSpacing.md),
              const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
