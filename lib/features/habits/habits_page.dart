import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/app_database.dart';
import '../../design_system/design_system.dart';
import '../../l10n/app_localizations.dart';

/// Habits hub — mhabit-inspired Today cards + All list with 7-day strip.
class HabitsPage extends StatefulWidget {
  const HabitsPage({super.key, required this.database});

  final AppDatabase database;

  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

enum _HabitsTab { today, all }

const _habitColors = <int>[
  0xFF8B6CFF,
  0xFF5ECF9A,
  0xFF5B7CFF,
  0xFFFF6B3D,
  0xFFE6DDD0,
  0xFFC53B4A,
];

class _HabitsPageState extends State<HabitsPage> {
  _HabitsTab _tab = _HabitsTab.today;

  Future<void> _openEditor({Habit? existing}) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _HabitEditorSheet(
        database: widget.database,
        existing: existing,
      ),
    );
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
                    Text(l10n.moreHabits, style: theme.headlineLarge),
                    const SizedBox(height: LumenSpacing.xs),
                    Text(
                      l10n.habitsSubtitle,
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
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: LumenSpacing.pagePadding,
          ),
          child: GlassSurface(
            borderRadius: LumenRadii.pill,
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Expanded(
                  child: _SegChip(
                    label: l10n.habitsTabToday,
                    selected: _tab == _HabitsTab.today,
                    onTap: () => setState(() => _tab = _HabitsTab.today),
                  ),
                ),
                Expanded(
                  child: _SegChip(
                    label: l10n.habitsTabAll,
                    selected: _tab == _HabitsTab.all,
                    onTap: () => setState(() => _tab = _HabitsTab.all),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: LumenSpacing.md),
        Expanded(
          child: StreamBuilder<List<Habit>>(
            stream: widget.database.watchHabits(),
            builder: (context, habitSnap) {
              final habits = habitSnap.data ?? const [];
              if (habits.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: LumenSpacing.pagePadding,
                  ),
                  child: Text(
                    l10n.habitsEmpty,
                    style: theme.bodyMedium?.copyWith(
                      color: LumenColors.textMuted,
                    ),
                  ),
                );
              }
              return StreamBuilder<List<HabitLog>>(
                stream: widget.database.watchHabitLogsInRange(
                  today.subtract(const Duration(days: 13)),
                  today,
                ),
                builder: (context, logSnap) {
                  final logs = logSnap.data ?? const [];
                  final doneToday = {
                    for (final l in logs)
                      if (l.day == today && l.status == 'done') l.habitId,
                  };
                  if (_tab == _HabitsTab.today) {
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        LumenSpacing.pagePadding,
                        0,
                        LumenSpacing.pagePadding,
                        120,
                      ),
                      itemCount: habits.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: LumenSpacing.sm),
                      itemBuilder: (context, i) {
                        final h = habits[i];
                        final checked = doneToday.contains(h.id);
                        return _TodayHabitCard(
                          habit: h,
                          checked: checked,
                          database: widget.database,
                          onEdit: () => _openEditor(existing: h),
                          onToggle: () =>
                              widget.database.toggleHabitDone(h.id, today),
                        );
                      },
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      LumenSpacing.pagePadding,
                      0,
                      LumenSpacing.pagePadding,
                      120,
                    ),
                    itemCount: habits.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: LumenSpacing.sm),
                    itemBuilder: (context, i) {
                      final h = habits[i];
                      return _AllHabitRow(
                        habit: h,
                        logs: logs.where((l) => l.habitId == h.id).toList(),
                        today: today,
                        onOpen: () => _openEditor(existing: h),
                        onToggleDay: (d) =>
                            widget.database.toggleHabitDone(h.id, d),
                      );
                    },
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

class _SegChip extends StatelessWidget {
  const _SegChip({
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
          ? LumenColors.accentViolet.withValues(alpha: 0.28)
          : Colors.transparent,
      borderRadius: LumenRadii.pill,
      child: InkWell(
        onTap: onTap,
        borderRadius: LumenRadii.pill,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: selected ? LumenColors.text : LumenColors.textMuted,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
          ),
        ),
      ),
    );
  }
}

class _TodayHabitCard extends StatelessWidget {
  const _TodayHabitCard({
    required this.habit,
    required this.checked,
    required this.database,
    required this.onEdit,
    required this.onToggle,
  });

  final Habit habit;
  final bool checked;
  final AppDatabase database;
  final VoidCallback onEdit;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final color = Color(habit.colorArgb);

    return GlowCard(
      violetEdge: true,
      onTap: onEdit,
      padding: const EdgeInsets.all(LumenSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(habit.title, style: theme.titleLarge),
                const SizedBox(height: LumenSpacing.xxs),
                FutureBuilder<int>(
                  future: database.habitStreak(habit.id),
                  builder: (context, snap) {
                    final n = snap.data ?? 0;
                    return Text(
                      l10n.habitsStreak(n),
                      style: theme.bodySmall?.copyWith(
                        color: LumenColors.textMuted,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Material(
            color: checked ? color : LumenColors.surfaceRaised,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  checked
                      ? PhosphorIconsRegular.check
                      : PhosphorIconsRegular.circle,
                  color: checked ? LumenColors.bg : color,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AllHabitRow extends StatelessWidget {
  const _AllHabitRow({
    required this.habit,
    required this.logs,
    required this.today,
    required this.onOpen,
    required this.onToggleDay,
  });

  final Habit habit;
  final List<HabitLog> logs;
  final DateTime today;
  final VoidCallback onOpen;
  final ValueChanged<DateTime> onToggleDay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final color = Color(habit.colorArgb);
    final doneDays = {
      for (final l in logs)
        if (l.status == 'done') AppDatabase.dayOnly(l.day),
    };

    return GlowCard(
      padding: const EdgeInsets.symmetric(
        horizontal: LumenSpacing.md,
        vertical: LumenSpacing.sm,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: CustomPaint(
              painter: _RingPainter(
                progress: doneDays.contains(today) ? 1 : 0.15,
                color: color,
              ),
              child: Center(
                child: Icon(
                  PhosphorIconsRegular.circleDashed,
                  size: 14,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(width: LumenSpacing.sm),
          Expanded(
            child: GestureDetector(
              onTap: onOpen,
              child: Text(
                habit.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.titleMedium,
              ),
            ),
          ),
          for (var i = 6; i >= 0; i--)
            _DayDot(
              day: today.subtract(Duration(days: i)),
              done: doneDays.contains(today.subtract(Duration(days: i))),
              color: color,
              onTap: () => onToggleDay(today.subtract(Duration(days: i))),
            ),
        ],
      ),
    );
  }
}

class _DayDot extends StatelessWidget {
  const _DayDot({
    required this.day,
    required this.done,
    required this.color,
    required this.onTap,
  });

  final DateTime day;
  final bool done;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done ? color.withValues(alpha: 0.85) : Colors.transparent,
            border: Border.all(
              color: done ? color : LumenColors.textMuted.withValues(alpha: 0.45),
            ),
          ),
          child: done
              ? const Icon(PhosphorIconsRegular.check, size: 12, color: LumenColors.bg)
              : Text(
                  '${day.day}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 9,
                        color: LumenColors.textMuted,
                      ),
                ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.shortestSide / 2 - 2;
    final track = Paint()
      ..color = LumenColors.surface
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(c, r, track);
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r),
      -1.5708,
      progress.clamp(0.0, 1.0) * 6.2832,
      false,
      fill,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress || old.color != color;
}

class _HabitEditorSheet extends StatefulWidget {
  const _HabitEditorSheet({required this.database, this.existing});

  final AppDatabase database;
  final Habit? existing;

  @override
  State<_HabitEditorSheet> createState() => _HabitEditorSheetState();
}

class _HabitEditorSheetState extends State<_HabitEditorSheet> {
  late final TextEditingController _title;
  late final TextEditingController _notes;
  late String _freq;
  late int _times;
  late int _color;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _title = TextEditingController(text: e?.title ?? '');
    _notes = TextEditingController(text: e?.notes ?? '');
    _freq = e?.frequency ?? 'daily';
    _times = e?.timesPerPeriod ?? 1;
    _color = e?.colorArgb ?? _habitColors.first;
  }

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final title = _title.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.habitsTitleRequired)),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final e = widget.existing;
      if (e == null) {
        await widget.database.insertHabit(
          title: title,
          frequency: _freq,
          timesPerPeriod: _times,
          colorArgb: _color,
          notes: _notes.text.trim(),
        );
      } else {
        await widget.database.updateHabit(
          id: e.id,
          title: title,
          frequency: _freq,
          timesPerPeriod: _times,
          periodDays: e.periodDays,
          colorArgb: _color,
          notes: _notes.text.trim(),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.existing == null ? l10n.habitsNew : l10n.habitsEdit,
              style: theme.titleLarge,
            ),
            const SizedBox(height: LumenSpacing.sm),
            TextField(
              controller: _title,
              autofocus: true,
              decoration: InputDecoration(hintText: l10n.habitsTitleHint),
            ),
            const SizedBox(height: LumenSpacing.sm),
            TextField(
              controller: _notes,
              maxLines: 2,
              decoration: InputDecoration(hintText: l10n.habitsNotesHint),
            ),
            const SizedBox(height: LumenSpacing.sm),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: Text(l10n.habitsFreqDaily),
                  selected: _freq == 'daily',
                  onSelected: (_) => setState(() {
                    _freq = 'daily';
                    _times = 1;
                  }),
                ),
                ChoiceChip(
                  label: Text(l10n.habitsFreqWeekly),
                  selected: _freq == 'weekly',
                  onSelected: (_) => setState(() {
                    _freq = 'weekly';
                    _times = 3;
                  }),
                ),
              ],
            ),
            const SizedBox(height: LumenSpacing.sm),
            Row(
              children: [
                for (final c in _habitColors)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => setState(() => _color = c),
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Color(c),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _color == c
                                ? LumenColors.text
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: LumenSpacing.md),
            Row(
              children: [
                if (widget.existing != null)
                  TextButton(
                    onPressed: () async {
                      await widget.database.deleteHabit(widget.existing!.id);
                      if (context.mounted) Navigator.pop(context);
                    },
                    child: Text(
                      l10n.habitsDelete,
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
    );
  }
}
