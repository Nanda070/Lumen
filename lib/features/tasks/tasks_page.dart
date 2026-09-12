import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/app_database.dart';
import '../../design_system/design_system.dart';
import '../../l10n/app_localizations.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key, required this.database});

  final AppDatabase database;

  @override
  State<TasksPage> createState() => _TasksPageState();
}

enum _TasksFilter { inbox, today, done }

class _TasksPageState extends State<TasksPage> {
  _TasksFilter _filter = _TasksFilter.inbox;

  Stream<List<Task>> get _stream {
    switch (_filter) {
      case _TasksFilter.inbox:
        return widget.database.watchInboxTasks();
      case _TasksFilter.today:
        return widget.database.watchTodayTasks();
      case _TasksFilter.done:
        return widget.database.watchTasks(done: true);
    }
  }

  Future<void> _openEditor({Task? existing}) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TaskEditorSheet(
        database: widget.database,
        existing: existing,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;

    // Same chrome as Calendar / Finance: pagePadding + full-width pill bar.
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
                    Text(
                      l10n.navTasks,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.headlineLarge,
                    ),
                    const SizedBox(height: LumenSpacing.xs),
                    Text(
                      l10n.tasksSubtitle,
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
          child: _FilterBar(
            filter: _filter,
            inboxLabel: l10n.tasksInbox,
            todayLabel: l10n.tasksToday,
            doneLabel: l10n.tasksDone,
            onChanged: (f) => setState(() => _filter = f),
          ),
        ),
        const SizedBox(height: LumenSpacing.md),
        Expanded(
          child: StreamBuilder<List<Task>>(
            stream: _stream,
            builder: (context, snap) {
              final items = snap.data ?? const [];
              if (items.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: LumenSpacing.pagePadding,
                  ),
                  child: Text(
                    l10n.tasksEmpty,
                    style: theme.bodyMedium?.copyWith(
                      color: LumenColors.textMuted,
                    ),
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  LumenSpacing.pagePadding,
                  0,
                  LumenSpacing.pagePadding,
                  120,
                ),
                itemCount: items.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: LumenSpacing.sm),
                itemBuilder: (context, i) {
                  final task = items[i];
                  return GlowCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: LumenSpacing.md,
                      vertical: LumenSpacing.sm,
                    ),
                    onTap: () => _openEditor(existing: task),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => widget.database
                              .setTaskDone(task.id, !task.isDone),
                          icon: Icon(
                            task.isDone
                                ? PhosphorIconsRegular.checkCircle
                                : PhosphorIconsRegular.circle,
                            color: task.isDone
                                ? LumenColors.accentMint
                                : LumenColors.textMuted,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.titleMedium?.copyWith(
                                  decoration: task.isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: task.isDone
                                      ? LumenColors.textMuted
                                      : null,
                                ),
                              ),
                              if (task.dueDate != null)
                                Text(
                                  '${task.dueDate!.day}.${task.dueDate!.month}.${task.dueDate!.year}',
                                  style: theme.labelMedium?.copyWith(
                                    color: LumenColors.textMuted,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              widget.database.deleteTask(task.id),
                          icon: const Icon(
                            PhosphorIconsRegular.trash,
                            color: LumenColors.accentRed,
                          ),
                        ),
                      ],
                    ),
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

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.filter,
    required this.inboxLabel,
    required this.todayLabel,
    required this.doneLabel,
    required this.onChanged,
  });

  final _TasksFilter filter;
  final String inboxLabel;
  final String todayLabel;
  final String doneLabel;
  final ValueChanged<_TasksFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      borderRadius: LumenRadii.pill,
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          for (final entry in [
            (_TasksFilter.inbox, inboxLabel),
            (_TasksFilter.today, todayLabel),
            (_TasksFilter.done, doneLabel),
          ])
            Expanded(
              child: _FilterChip(
                label: entry.$2,
                selected: filter == entry.$1,
                onTap: () => onChanged(entry.$1),
              ),
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: LumenMotion.fast,
      curve: LumenMotion.spring,
      decoration: BoxDecoration(
        borderRadius: LumenRadii.pill,
        color: selected
            ? LumenColors.accentViolet.withValues(alpha: 0.28)
            : Colors.transparent,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: LumenRadii.pill,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: selected ? LumenColors.text : LumenColors.textMuted,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskEditorSheet extends StatefulWidget {
  const _TaskEditorSheet({
    required this.database,
    this.existing,
  });

  final AppDatabase database;
  final Task? existing;

  @override
  State<_TaskEditorSheet> createState() => _TaskEditorSheetState();
}

class _TaskEditorSheetState extends State<_TaskEditorSheet> {
  late final TextEditingController _title;
  late final TextEditingController _notes;
  DateTime? _due;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.existing?.title ?? '');
    _notes = TextEditingController(text: widget.existing?.notes ?? '');
    _due = widget.existing?.dueDate;
  }

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDue() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _due ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) setState(() => _due = picked);
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final title = _title.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.tasksTitleRequired)),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final existing = widget.existing;
      if (existing == null) {
        await widget.database.insertTask(
          title: title,
          dueDate: _due,
          notes: _notes.text.trim(),
        );
      } else {
        await widget.database.updateTask(
          id: existing.id,
          title: title,
          dueDate: _due,
          notes: _notes.text.trim(),
          clearDue: _due == null,
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
              widget.existing == null ? l10n.tasksNew : l10n.tasksEdit,
              style: theme.titleLarge,
            ),
            const SizedBox(height: LumenSpacing.sm),
            TextField(
              controller: _title,
              autofocus: true,
              decoration: InputDecoration(hintText: l10n.tasksTitleHint),
            ),
            const SizedBox(height: LumenSpacing.sm),
            TextField(
              controller: _notes,
              maxLines: 2,
              decoration: InputDecoration(hintText: l10n.tasksNotesHint),
            ),
            const SizedBox(height: LumenSpacing.sm),
            Row(
              children: [
                TextButton.icon(
                  onPressed: _pickDue,
                  icon: const Icon(PhosphorIconsRegular.calendarBlank, size: 16),
                  label: Text(
                    _due == null
                        ? l10n.tasksDue
                        : '${_due!.day}.${_due!.month}.${_due!.year}',
                  ),
                ),
                if (_due != null)
                  TextButton(
                    onPressed: () => setState(() => _due = null),
                    child: Text(l10n.tasksClearDue),
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
