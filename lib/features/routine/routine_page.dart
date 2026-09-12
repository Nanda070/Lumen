import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/app_database.dart';
import '../../design_system/design_system.dart';
import '../../l10n/app_localizations.dart';

/// Routine hub — FocusForce-inspired list + today's timed slots.
class RoutinePage extends StatefulWidget {
  const RoutinePage({super.key, required this.database});

  final AppDatabase database;

  @override
  State<RoutinePage> createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  Future<void> _openEditor({Routine? existing}) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _RoutineEditorSheet(
        database: widget.database,
        existing: existing,
      ),
    );
  }

  static bool _runsToday(Routine r, DateTime day) {
    // Mon=1 … Sun=64; DateTime.weekday Mon=1 … Sun=7
    final bit = 1 << (day.weekday - 1);
    return (r.weekdaysMask & bit) != 0 && r.isEnabled;
  }

  static String _fmtTime(int minutes) {
    final h = (minutes ~/ 60).toString().padLeft(2, '0');
    final m = (minutes % 60).toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final today = AppDatabase.dayOnly(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            LumenSpacing.pagePadding,
            LumenSpacing.lg,
            LumenSpacing.pagePadding,
            LumenSpacing.sm,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.moreRoutine, style: theme.headlineLarge),
                    const SizedBox(height: LumenSpacing.xs),
                    Text(
                      l10n.routineSubtitle,
                      style: theme.bodyMedium?.copyWith(
                        color: LumenColors.textMuted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(PhosphorIconsRegular.x),
              ),
              IconButton(
                onPressed: () => _openEditor(),
                icon: const Icon(
                  PhosphorIconsRegular.plusCircle,
                  color: LumenColors.accentMint,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Routine>>(
            stream: widget.database.watchRoutines(),
            builder: (context, snap) {
              final routines = snap.data ?? const [];
              return StreamBuilder<List<RoutineSlotLog>>(
                stream: widget.database.watchRoutineSlotLogsForDay(today),
                builder: (context, logSnap) {
                  final logs = logSnap.data ?? const [];
                  final doneIds = {for (final l in logs) l.slotId};

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(
                      LumenSpacing.pagePadding,
                      0,
                      LumenSpacing.pagePadding,
                      120,
                    ),
                    children: [
                      Text(l10n.routineToday, style: theme.titleMedium),
                      const SizedBox(height: LumenSpacing.sm),
                      _TodaySlotsBlock(
                        database: widget.database,
                        routines: routines.where((r) => _runsToday(r, today)).toList(),
                        doneIds: doneIds,
                        today: today,
                        emptyLabel: l10n.routineNoSlotsToday,
                        minutesLabel: l10n.routineMinutes,
                      ),
                      const SizedBox(height: LumenSpacing.lg),
                      Text(l10n.moreRoutine, style: theme.titleMedium),
                      const SizedBox(height: LumenSpacing.sm),
                      if (routines.isEmpty)
                        Text(
                          l10n.routineEmpty,
                          style: theme.bodyMedium?.copyWith(
                            color: LumenColors.textMuted,
                          ),
                        )
                      else
                        ...routines.map(
                          (r) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: LumenSpacing.sm,
                            ),
                            child: _RoutineCard(
                              routine: r,
                              timeLabel: _fmtTime(r.startMinutes),
                              onTap: () => _openEditor(existing: r),
                              onToggle: (v) => widget.database
                                  .setRoutineEnabled(r.id, v),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TodaySlotsBlock extends StatelessWidget {
  const _TodaySlotsBlock({
    required this.database,
    required this.routines,
    required this.doneIds,
    required this.today,
    required this.emptyLabel,
    required this.minutesLabel,
  });

  final AppDatabase database;
  final List<Routine> routines;
  final Set<int> doneIds;
  final DateTime today;
  final String emptyLabel;
  final String Function(int) minutesLabel;

  @override
  Widget build(BuildContext context) {
    if (routines.isEmpty) {
      return Text(
        emptyLabel,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: LumenColors.textMuted,
            ),
      );
    }

    return Column(
      children: [
        for (final r in routines)
          StreamBuilder<List<RoutineSlot>>(
            stream: database.watchRoutineSlots(r.id),
            builder: (context, snap) {
              final slots = snap.data ?? const [];
              if (slots.isEmpty) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final s in slots)
                    Padding(
                      padding: const EdgeInsets.only(bottom: LumenSpacing.xs),
                      child: GlowCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: LumenSpacing.md,
                          vertical: LumenSpacing.sm,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => database.toggleRoutineSlotDone(
                                s.id,
                                today,
                              ),
                              icon: Icon(
                                doneIds.contains(s.id)
                                    ? PhosphorIconsRegular.checkCircle
                                    : PhosphorIconsRegular.circle,
                                color: doneIds.contains(s.id)
                                    ? LumenColors.accentMint
                                    : LumenColors.textMuted,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          decoration: doneIds.contains(s.id)
                                              ? TextDecoration.lineThrough
                                              : null,
                                        ),
                                  ),
                                  Text(
                                    '${r.title} · ${minutesLabel(s.durationMinutes)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: LumenColors.textMuted,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
      ],
    );
  }
}

class _RoutineCard extends StatelessWidget {
  const _RoutineCard({
    required this.routine,
    required this.timeLabel,
    required this.onTap,
    required this.onToggle,
  });

  final Routine routine;
  final String timeLabel;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;

  static const _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return GlowCard(
      violetEdge: true,
      onTap: onTap,
      padding: const EdgeInsets.all(LumenSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(routine.title, style: theme.titleMedium),
              ),
              Switch.adaptive(
                value: routine.isEnabled,
                onChanged: onToggle,
              ),
            ],
          ),
          Text(
            timeLabel,
            style: theme.headlineSmall?.copyWith(
              color: LumenColors.accentBlue,
            ),
          ),
          const SizedBox(height: LumenSpacing.xs),
          Wrap(
            spacing: 4,
            children: [
              for (var i = 0; i < 7; i++)
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: LumenRadii.card,
                    color: (routine.weekdaysMask & (1 << i)) != 0
                        ? LumenColors.accentViolet.withValues(alpha: 0.35)
                        : LumenColors.surface,
                  ),
                  child: Text(
                    _dayLabels[i],
                    style: theme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SlotDraft {
  _SlotDraft({required this.title, required this.durationMinutes});

  String title;
  int durationMinutes;
}

class _RoutineEditorSheet extends StatefulWidget {
  const _RoutineEditorSheet({required this.database, this.existing});

  final AppDatabase database;
  final Routine? existing;

  @override
  State<_RoutineEditorSheet> createState() => _RoutineEditorSheetState();
}

class _RoutineEditorSheetState extends State<_RoutineEditorSheet> {
  late final TextEditingController _title;
  late int _startMinutes;
  late int _mask;
  late List<_SlotDraft> _slots;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _title = TextEditingController(text: e?.title ?? '');
    _startMinutes = e?.startMinutes ?? 8 * 60;
    _mask = e?.weekdaysMask ?? 127;
    _slots = [];
    if (e != null) {
      widget.database.getRoutineSlots(e.id).then((list) {
        if (!mounted) return;
        setState(() {
          _slots = [
            for (final s in list)
              _SlotDraft(title: s.title, durationMinutes: s.durationMinutes),
          ];
        });
      });
    } else {
      _slots = [_SlotDraft(title: '', durationMinutes: 15)];
    }
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final initial = TimeOfDay(
      hour: _startMinutes ~/ 60,
      minute: _startMinutes % 60,
    );
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (picked != null) {
      setState(() => _startMinutes = picked.hour * 60 + picked.minute);
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final title = _title.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.routineTitleRequired)),
      );
      return;
    }
    final slots = [
      for (final s in _slots)
        if (s.title.trim().isNotEmpty)
          (title: s.title.trim(), durationMinutes: s.durationMinutes),
    ];
    setState(() => _saving = true);
    try {
      final e = widget.existing;
      if (e == null) {
        await widget.database.insertRoutine(
          title: title,
          startMinutes: _startMinutes,
          weekdaysMask: _mask,
          slots: slots,
        );
      } else {
        await widget.database.updateRoutine(
          id: e.id,
          title: title,
          startMinutes: _startMinutes,
          weekdaysMask: _mask,
          slots: slots,
        );
      }
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    final h = (_startMinutes ~/ 60).toString().padLeft(2, '0');
    final m = (_startMinutes % 60).toString().padLeft(2, '0');

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: GlassSurface(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(LumenRadii.lg),
        ),
        fillColor: LumenColors.bgElevated.withValues(alpha: 0.96),
        padding: const EdgeInsets.fromLTRB(
          LumenSpacing.pagePadding,
          LumenSpacing.md,
          LumenSpacing.pagePadding,
          LumenSpacing.lg,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.existing == null ? l10n.routineNew : l10n.routineEdit,
                style: theme.titleLarge,
              ),
              const SizedBox(height: LumenSpacing.sm),
              TextField(
                controller: _title,
                decoration: InputDecoration(hintText: l10n.routineTitleHint),
              ),
              const SizedBox(height: LumenSpacing.sm),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.routineStart),
                trailing: TextButton(
                  onPressed: _pickTime,
                  child: Text('$h:$m', style: theme.headlineSmall),
                ),
              ),
              Text(l10n.routineWeekdays, style: theme.labelMedium),
              const SizedBox(height: LumenSpacing.xs),
              Wrap(
                spacing: 6,
                children: [
                  for (var i = 0; i < 7; i++)
                    FilterChip(
                      label: Text(_RoutineCard._dayLabels[i]),
                      selected: (_mask & (1 << i)) != 0,
                      onSelected: (sel) {
                        setState(() {
                          if (sel) {
                            _mask |= 1 << i;
                          } else {
                            _mask &= ~(1 << i);
                          }
                        });
                      },
                    ),
                ],
              ),
              const SizedBox(height: LumenSpacing.md),
              Text(l10n.routineSlots, style: theme.titleMedium),
              const SizedBox(height: LumenSpacing.xs),
              for (var i = 0; i < _slots.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: LumenSpacing.xs),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: _slots[i].title,
                          decoration: InputDecoration(
                            hintText: l10n.routineSlotHint,
                          ),
                          onChanged: (v) => _slots[i].title = v,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _slots[i].durationMinutes =
                                (_slots[i].durationMinutes + 5).clamp(5, 180);
                          });
                        },
                        icon: const Icon(PhosphorIconsRegular.plus),
                      ),
                      Text(
                        l10n.routineMinutes(_slots[i].durationMinutes),
                        style: theme.labelMedium,
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _slots[i].durationMinutes =
                                (_slots[i].durationMinutes - 5).clamp(5, 180);
                          });
                        },
                        icon: const Icon(PhosphorIconsRegular.minus),
                      ),
                    ],
                  ),
                ),
              TextButton.icon(
                onPressed: () => setState(
                  () => _slots.add(_SlotDraft(title: '', durationMinutes: 15)),
                ),
                icon: const Icon(PhosphorIconsRegular.plus),
                label: Text(l10n.routineAddSlot),
              ),
              const SizedBox(height: LumenSpacing.md),
              Row(
                children: [
                  if (widget.existing != null)
                    TextButton(
                      onPressed: () async {
                        await widget.database
                            .deleteRoutine(widget.existing!.id);
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: Text(
                        l10n.routineDelete,
                        style: const TextStyle(color: LumenColors.accentRed),
                      ),
                    ),
                  const Spacer(),
                  FilledButton(
                    onPressed: _saving ? null : _save,
                    child: Text(l10n.financeSave),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
