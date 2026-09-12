import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/app_database.dart';
import '../../design_system/design_system.dart';
import '../../l10n/app_localizations.dart';
import 'calendar_date_utils.dart';

Future<void> showEventEditorSheet({
  required BuildContext context,
  required AppDatabase database,
  EventWithCalendar? existing,
  DateTime? initialDay,
  TimeOfDay? initialStart,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return EventEditorSheet(
        database: database,
        existing: existing,
        initialDay: initialDay,
        initialStart: initialStart,
      );
    },
  );
}

class EventEditorSheet extends StatefulWidget {
  const EventEditorSheet({
    super.key,
    required this.database,
    this.existing,
    this.initialDay,
    this.initialStart,
  });

  final AppDatabase database;
  final EventWithCalendar? existing;
  final DateTime? initialDay;
  final TimeOfDay? initialStart;

  @override
  State<EventEditorSheet> createState() => _EventEditorSheetState();
}

class _EventEditorSheetState extends State<EventEditorSheet> {
  late final TextEditingController _title;
  late DateTime _day;
  late TimeOfDay _start;
  late TimeOfDay _end;
  List<Calendar> _calendars = const [];
  int? _calendarId;
  bool _saving = false;
  String? _error;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing?.event;
    if (existing != null) {
      _title = TextEditingController(text: existing.title);
      _day = CalendarDateUtils.dateOnly(existing.startsAt);
      _start = TimeOfDay.fromDateTime(existing.startsAt);
      _end = TimeOfDay.fromDateTime(existing.endsAt);
      _calendarId = existing.calendarId;
    } else {
      _title = TextEditingController();
      final day = widget.initialDay ?? DateTime.now();
      _day = CalendarDateUtils.dateOnly(day);
      final start = widget.initialStart ??
          TimeOfDay(
            hour: TimeOfDay.now().hour,
            minute: 0,
          );
      _start = start;
      final endHour = (start.hour + 1).clamp(0, 23);
      _end = TimeOfDay(hour: endHour, minute: start.minute);
    }
    _loadCalendars();
  }

  Future<void> _loadCalendars() async {
    final list = await widget.database.getCalendars();
    if (!mounted) return;
    setState(() {
      _calendars = list;
      _calendarId ??= list.isNotEmpty ? list.first.id : null;
    });
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  DateTime _combine(DateTime day, TimeOfDay time) =>
      DateTime(day.year, day.month, day.day, time.hour, time.minute);

  Future<void> _pickDay() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _day,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: LumenColors.accentBlue,
              surface: LumenColors.surfaceRaised,
              onSurface: LumenColors.text,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _day = CalendarDateUtils.dateOnly(picked));
  }

  Future<void> _pickTime({required bool isStart}) async {
    final initial = isStart ? _start : _end;
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: LumenColors.accentBlue,
              surface: LumenColors.surfaceRaised,
              onSurface: LumenColors.text,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _start = picked;
        final startM = picked.hour * 60 + picked.minute;
        final endM = _end.hour * 60 + _end.minute;
        if (endM <= startM) {
          final next = (startM + 60).clamp(0, 23 * 60 + 59);
          _end = TimeOfDay(hour: next ~/ 60, minute: next % 60);
        }
      } else {
        _end = picked;
      }
    });
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final title = _title.text.trim();
    if (title.isEmpty) {
      setState(() => _error = l10n.eventTitleRequired);
      return;
    }
    if (_calendarId == null) {
      setState(() => _error = l10n.eventCalendarRequired);
      return;
    }
    final startsAt = _combine(_day, _start);
    final endsAt = _combine(_day, _end);
    if (!endsAt.isAfter(startsAt)) {
      setState(() => _error = l10n.eventTimeInvalid);
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      if (_isEdit) {
        await widget.database.updateEvent(
          id: widget.existing!.event.id,
          title: title,
          startsAt: startsAt,
          endsAt: endsAt,
          calendarId: _calendarId!,
        );
      } else {
        await widget.database.insertEvent(
          title: title,
          startsAt: startsAt,
          endsAt: endsAt,
          calendarId: _calendarId!,
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = l10n.eventSaveError;
      });
    }
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: LumenColors.surfaceRaised,
          title: Text(l10n.eventDeleteTitle),
          content: Text(l10n.eventDeleteBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.eventCancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                l10n.eventDelete,
                style: const TextStyle(color: LumenColors.accentRed),
              ),
            ),
          ],
        );
      },
    );
    if (confirm != true || !mounted) return;
    await widget.database.deleteEvent(widget.existing!.event.id);
    if (!mounted) return;
    Navigator.of(context).pop();
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
        fillColor: LumenColors.bgElevated.withValues(alpha: 0.94),
        strokeColor: LumenColors.glassStrokeViolet,
        glowColor: LumenColors.accentViolet,
        padding: const EdgeInsets.fromLTRB(
          LumenSpacing.pagePadding,
          LumenSpacing.md,
          LumenSpacing.pagePadding,
          LumenSpacing.xl,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: LumenColors.textMuted.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: LumenSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _isEdit ? l10n.eventEditTitle : l10n.eventNewTitle,
                      style: theme.titleLarge,
                    ),
                  ),
                  if (_isEdit)
                    IconButton(
                      onPressed: _saving ? null : _delete,
                      icon: const Icon(
                        PhosphorIconsRegular.trash,
                        color: LumenColors.accentRed,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: LumenSpacing.md),
              TextField(
                controller: _title,
                autofocus: !_isEdit,
                style: theme.titleMedium,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: l10n.eventTitleHint,
                  filled: true,
                  fillColor: LumenColors.surfaceRaised,
                  border: OutlineInputBorder(
                    borderRadius: LumenRadii.card,
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: LumenSpacing.md),
              _FieldTile(
                icon: PhosphorIconsRegular.calendarBlank,
                label: l10n.eventDate,
                value:
                    '${CalendarDateUtils.twoDigits(_day.day)}.${CalendarDateUtils.twoDigits(_day.month)}.${_day.year}',
                onTap: _pickDay,
              ),
              const SizedBox(height: LumenSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: _FieldTile(
                      icon: PhosphorIconsRegular.clock,
                      label: l10n.eventStart,
                      value:
                          '${CalendarDateUtils.twoDigits(_start.hour)}:${CalendarDateUtils.twoDigits(_start.minute)}',
                      onTap: () => _pickTime(isStart: true),
                    ),
                  ),
                  const SizedBox(width: LumenSpacing.sm),
                  Expanded(
                    child: _FieldTile(
                      icon: PhosphorIconsRegular.clockAfternoon,
                      label: l10n.eventEnd,
                      value:
                          '${CalendarDateUtils.twoDigits(_end.hour)}:${CalendarDateUtils.twoDigits(_end.minute)}',
                      onTap: () => _pickTime(isStart: false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: LumenSpacing.md),
              Text(l10n.eventCalendar, style: theme.labelLarge),
              const SizedBox(height: LumenSpacing.xs),
              Wrap(
                spacing: LumenSpacing.xs,
                runSpacing: LumenSpacing.xs,
                children: [
                  for (final cal in _calendars)
                    ChoiceChip(
                      selected: _calendarId == cal.id,
                      label: Text(cal.name),
                      avatar: CircleAvatar(
                        backgroundColor: Color(cal.colorArgb),
                        radius: 6,
                      ),
                      selectedColor: Color(cal.colorArgb).withValues(alpha: 0.28),
                      backgroundColor: LumenColors.surfaceRaised,
                      labelStyle: theme.labelLarge?.copyWith(
                        color: LumenColors.text,
                      ),
                      side: BorderSide(
                        color: _calendarId == cal.id
                            ? Color(cal.colorArgb)
                            : LumenColors.glassStroke,
                      ),
                      onSelected: (_) => setState(() => _calendarId = cal.id),
                    ),
                ],
              ),
              if (_error != null) ...[
                const SizedBox(height: LumenSpacing.sm),
                Text(
                  _error!,
                  style: theme.bodySmall?.copyWith(color: LumenColors.accentRed),
                ),
              ],
              const SizedBox(height: LumenSpacing.lg),
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: _saving ? null : _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: LumenColors.accentCream,
                    foregroundColor: LumenColors.bg,
                    shape: const RoundedRectangleBorder(
                      borderRadius: LumenRadii.pill,
                    ),
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          _isEdit ? l10n.eventSave : l10n.eventCreate,
                          style: theme.titleMedium?.copyWith(
                            color: LumenColors.bg,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldTile extends StatelessWidget {
  const _FieldTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return GlowCard(
      onTap: onTap,
      padding: const EdgeInsets.all(LumenSpacing.md),
      child: Row(
        children: [
          Icon(icon, size: 18, color: LumenColors.accentBlue),
          const SizedBox(width: LumenSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.labelSmall?.copyWith(
                    color: LumenColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(value, style: theme.titleMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
