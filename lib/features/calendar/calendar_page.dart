import 'dart:async';

import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/app_database.dart';
import '../../design_system/design_system.dart';
import '../../l10n/app_localizations.dart';
import 'calendar_date_utils.dart';
import 'event_editor_sheet.dart';

enum CalendarViewMode { day, week, month }

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key, required this.database});

  final AppDatabase database;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarViewMode _mode = CalendarViewMode.week;
  late DateTime _focusDay;

  @override
  void initState() {
    super.initState();
    _focusDay = CalendarDateUtils.dateOnly(DateTime.now());
  }

  (DateTime, DateTime) get _range {
    switch (_mode) {
      case CalendarViewMode.day:
        final start = _focusDay;
        return (start, start.add(const Duration(days: 1)));
      case CalendarViewMode.week:
        final start = CalendarDateUtils.startOfWeek(_focusDay);
        return (start, start.add(const Duration(days: 7)));
      case CalendarViewMode.month:
        return (
          CalendarDateUtils.monthGridStart(_focusDay),
          CalendarDateUtils.monthGridEnd(_focusDay),
        );
    }
  }

  void _shift(int delta) {
    setState(() {
      switch (_mode) {
        case CalendarViewMode.day:
          _focusDay = _focusDay.add(Duration(days: delta));
        case CalendarViewMode.week:
          _focusDay = _focusDay.add(Duration(days: 7 * delta));
        case CalendarViewMode.month:
          _focusDay = DateTime(_focusDay.year, _focusDay.month + delta, 1);
      }
    });
  }

  Future<void> _openEditor({
    EventWithCalendar? existing,
    DateTime? day,
    TimeOfDay? start,
  }) {
    return showEventEditorSheet(
      context: context,
      database: widget.database,
      existing: existing,
      initialDay: day ?? _focusDay,
      initialStart: start,
    );
  }

  String _headerSubtitle(AppLocalizations l10n) {
    final months = [
      l10n.monthJan,
      l10n.monthFeb,
      l10n.monthMar,
      l10n.monthApr,
      l10n.monthMay,
      l10n.monthJun,
      l10n.monthJul,
      l10n.monthAug,
      l10n.monthSep,
      l10n.monthOct,
      l10n.monthNov,
      l10n.monthDec,
    ];
    switch (_mode) {
      case CalendarViewMode.day:
        return '${_focusDay.day} ${months[_focusDay.month - 1]} ${_focusDay.year}';
      case CalendarViewMode.week:
        final start = CalendarDateUtils.startOfWeek(_focusDay);
        final end = start.add(const Duration(days: 6));
        if (start.month == end.month) {
          return '${start.day}–${end.day} ${months[start.month - 1]} ${start.year}';
        }
        return '${start.day} ${months[start.month - 1]} – ${end.day} ${months[end.month - 1]}';
      case CalendarViewMode.month:
        return '${months[_focusDay.month - 1]} ${_focusDay.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final range = _range;

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                LumenSpacing.pagePadding,
                LumenSpacing.xl,
                LumenSpacing.pagePadding,
                LumenSpacing.sm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.navCalendar, style: theme.headlineLarge),
                        const SizedBox(height: LumenSpacing.xxs),
                        AnimatedSwitcher(
                          duration: LumenMotion.fast,
                          child: Text(
                            _headerSubtitle(l10n),
                            key: ValueKey(_headerSubtitle(l10n)),
                            style: theme.bodyMedium?.copyWith(
                              color: LumenColors.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _NavIcon(
                    icon: PhosphorIconsRegular.caretLeft,
                    onTap: () => _shift(-1),
                  ),
                  const SizedBox(width: LumenSpacing.xxs),
                  _NavIcon(
                    icon: PhosphorIconsRegular.caretRight,
                    onTap: () => _shift(1),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: LumenSpacing.pagePadding,
              ),
              child: _ViewModeBar(
                mode: _mode,
                onChanged: (m) => setState(() => _mode = m),
                dayLabel: l10n.calendarViewDay,
                weekLabel: l10n.calendarViewWeek,
                monthLabel: l10n.calendarViewMonth,
              ),
            ),
            const SizedBox(height: LumenSpacing.md),
            Expanded(
              child: StreamBuilder<List<EventWithCalendar>>(
                stream: widget.database.watchEventsInRange(range.$1, range.$2),
                builder: (context, snapshot) {
                  final events = snapshot.data ?? const [];
                  return AnimatedSwitcher(
                    duration: LumenMotion.normal,
                    switchInCurve: LumenMotion.spring,
                    child: KeyedSubtree(
                      key: ValueKey('${_mode.name}-${_focusDay.toIso8601String()}'),
                      child: switch (_mode) {
                        CalendarViewMode.day => _DayTimeline(
                            day: _focusDay,
                            events: events,
                            onEventTap: (e) => _openEditor(existing: e),
                            onSlotTap: (t) => _openEditor(
                              day: _focusDay,
                              start: t,
                            ),
                          ),
                        CalendarViewMode.week => _WeekTimeline(
                            focusDay: _focusDay,
                            events: events,
                            weekdayLabels: _weekdayShort(l10n),
                            onSelectDay: (d) => setState(() {
                              _focusDay = d;
                              _mode = CalendarViewMode.day;
                            }),
                            onEventTap: (e) => _openEditor(existing: e),
                            onSlotTap: (day, t) => _openEditor(
                              day: day,
                              start: t,
                            ),
                          ),
                        CalendarViewMode.month => _MonthGrid(
                            focusDay: _focusDay,
                            events: events,
                            weekdayLabels: _weekdayShort(l10n),
                            onSelectDay: (d) => setState(() {
                              _focusDay = d;
                              _mode = CalendarViewMode.day;
                            }),
                            onEventTap: (e) => _openEditor(existing: e),
                          ),
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
        Positioned(
          right: LumenSpacing.pagePadding,
          bottom: 108,
          child: _QuickAddButton(
            label: l10n.eventQuickAdd,
            onTap: () => _openEditor(day: _focusDay),
          ),
        ),
      ],
    );
  }

  List<String> _weekdayShort(AppLocalizations l10n) => [
        l10n.weekdayMon,
        l10n.weekdayTue,
        l10n.weekdayWed,
        l10n.weekdayThu,
        l10n.weekdayFri,
        l10n.weekdaySat,
        l10n.weekdaySun,
      ];
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: LumenColors.surfaceRaised.withValues(alpha: 0.9),
      borderRadius: LumenRadii.pill,
      child: InkWell(
        onTap: onTap,
        borderRadius: LumenRadii.pill,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 18, color: LumenColors.text),
        ),
      ),
    );
  }
}

class _ViewModeBar extends StatelessWidget {
  const _ViewModeBar({
    required this.mode,
    required this.onChanged,
    required this.dayLabel,
    required this.weekLabel,
    required this.monthLabel,
  });

  final CalendarViewMode mode;
  final ValueChanged<CalendarViewMode> onChanged;
  final String dayLabel;
  final String weekLabel;
  final String monthLabel;

  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      borderRadius: LumenRadii.pill,
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          for (final entry in [
            (CalendarViewMode.day, dayLabel),
            (CalendarViewMode.week, weekLabel),
            (CalendarViewMode.month, monthLabel),
          ])
            Expanded(
              child: _ModeChip(
                label: entry.$2,
                selected: mode == entry.$1,
                onTap: () => onChanged(entry.$1),
              ),
            ),
        ],
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
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
        gradient: selected ? LumenColors.gradDusk : null,
        boxShadow: selected
            ? [
                BoxShadow(
                  color: LumenColors.accentViolet.withValues(alpha: 0.28),
                  blurRadius: 16,
                ),
              ]
            : null,
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

class _QuickAddButton extends StatelessWidget {
  const _QuickAddButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: LumenColors.accentCream,
      borderRadius: LumenRadii.pill,
      elevation: 0,
      shadowColor: LumenColors.accentCream.withValues(alpha: 0.35),
      child: InkWell(
        onTap: onTap,
        borderRadius: LumenRadii.pill,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(PhosphorIconsRegular.plus, size: 18, color: LumenColors.bg),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: LumenColors.bg,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// —— Day / Week timeline ——

const double _hourHeight = 56;
const double _timeGutter = 52;
const int _startHour = 0;
const int _endHour = 24;

class _DayTimeline extends StatefulWidget {
  const _DayTimeline({
    required this.day,
    required this.events,
    required this.onEventTap,
    required this.onSlotTap,
  });

  final DateTime day;
  final List<EventWithCalendar> events;
  final ValueChanged<EventWithCalendar> onEventTap;
  final ValueChanged<TimeOfDay> onSlotTap;

  @override
  State<_DayTimeline> createState() => _DayTimelineState();
}

class _DayTimelineState extends State<_DayTimeline> {
  final _scroll = ScrollController();
  Timer? _tick;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      final target = (_now.hour * _hourHeight) - 80;
      _scroll.jumpTo(target.clamp(0, _scroll.position.maxScrollExtent));
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalHeight = (_endHour - _startHour) * _hourHeight;
    final showNow = CalendarDateUtils.isSameDay(widget.day, _now);

    return ListView(
      controller: _scroll,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        LumenSpacing.pagePadding,
        0,
        LumenSpacing.pagePadding,
        LumenSpacing.xxl,
      ),
      children: [
        SizedBox(
          height: totalHeight,
          child: Stack(
            children: [
              Column(
                children: [
                  for (var h = _startHour; h < _endHour; h++)
                    SizedBox(
                      height: _hourHeight,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: _timeGutter,
                            child: Text(
                              CalendarDateUtils.formatHourLabel(h),
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: LumenColors.textMuted,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => widget.onSlotTap(TimeOfDay(hour: h, minute: 0)),
                              child: Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: LumenColors.divider),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              ...widget.events.map((item) {
                final startM = CalendarDateUtils.minutesSinceMidnight(item.event.startsAt);
                final endM = CalendarDateUtils.minutesSinceMidnight(item.event.endsAt);
                final top = (startM / 60) * _hourHeight;
                final height = ((endM - startM) / 60 * _hourHeight).clamp(28.0, double.infinity);
                return Positioned(
                  left: _timeGutter + 4,
                  right: 0,
                  top: top,
                  height: height,
                  child: _TimelineEventBlock(
                    item: item,
                    onTap: () => widget.onEventTap(item),
                  ),
                );
              }),
              if (showNow)
                Positioned(
                  left: _timeGutter - 6,
                  right: 0,
                  top: (CalendarDateUtils.minutesSinceMidnight(_now) / 60) * _hourHeight,
                  child: const _NowLine(),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeekTimeline extends StatefulWidget {
  const _WeekTimeline({
    required this.focusDay,
    required this.events,
    required this.weekdayLabels,
    required this.onSelectDay,
    required this.onEventTap,
    required this.onSlotTap,
  });

  final DateTime focusDay;
  final List<EventWithCalendar> events;
  final List<String> weekdayLabels;
  final ValueChanged<DateTime> onSelectDay;
  final ValueChanged<EventWithCalendar> onEventTap;
  final void Function(DateTime day, TimeOfDay time) onSlotTap;

  @override
  State<_WeekTimeline> createState() => _WeekTimelineState();
}

class _WeekTimelineState extends State<_WeekTimeline> {
  final _scroll = ScrollController();
  Timer? _tick;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      final target = (_now.hour * _hourHeight) - 60;
      _scroll.jumpTo(target.clamp(0, _scroll.position.maxScrollExtent));
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weekStart = CalendarDateUtils.startOfWeek(widget.focusDay);
    final days = List.generate(7, (i) => weekStart.add(Duration(days: i)));
    final totalHeight = (_endHour - _startHour) * _hourHeight;
    final theme = Theme.of(context).textTheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            LumenSpacing.pagePadding + _timeGutter,
            0,
            LumenSpacing.pagePadding,
            LumenSpacing.sm,
          ),
          child: Row(
            children: [
              for (var i = 0; i < 7; i++)
                Expanded(
                  child: GestureDetector(
                    onTap: () => widget.onSelectDay(days[i]),
                    child: Column(
                      children: [
                        Text(
                          widget.weekdayLabels[i],
                          style: theme.labelSmall?.copyWith(
                            color: LumenColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedContainer(
                          duration: LumenMotion.fast,
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: CalendarDateUtils.isToday(days[i])
                                ? LumenColors.gradDusk
                                : null,
                            color: CalendarDateUtils.isSameDay(days[i], widget.focusDay) &&
                                    !CalendarDateUtils.isToday(days[i])
                                ? LumenColors.surfaceRaised
                                : null,
                          ),
                          child: Text(
                            '${days[i].day}',
                            style: theme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: CalendarDateUtils.isToday(days[i])
                                  ? LumenColors.text
                                  : LumenColors.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            controller: _scroll,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              LumenSpacing.pagePadding,
              0,
              LumenSpacing.pagePadding,
              LumenSpacing.xxl,
            ),
            children: [
              SizedBox(
                height: totalHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: _timeGutter,
                      child: Column(
                        children: [
                          for (var h = _startHour; h < _endHour; h++)
                            SizedBox(
                              height: _hourHeight,
                              child: Text(
                                CalendarDateUtils.formatHourLabel(h),
                                style: theme.labelSmall?.copyWith(
                                  color: LumenColors.textMuted,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    for (final day in days)
                      Expanded(
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                for (var h = _startHour; h < _endHour; h++)
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => widget.onSlotTap(
                                      day,
                                      TimeOfDay(hour: h, minute: 0),
                                    ),
                                    child: Container(
                                      height: _hourHeight,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: const BorderSide(
                                            color: LumenColors.divider,
                                          ),
                                          left: BorderSide(
                                            color: LumenColors.divider
                                                .withValues(alpha: 0.6),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            ...widget.events
                                .where(
                                  (e) => CalendarDateUtils.isSameDay(
                                    e.event.startsAt,
                                    day,
                                  ),
                                )
                                .map((item) {
                              final startM = CalendarDateUtils.minutesSinceMidnight(
                                item.event.startsAt,
                              );
                              final endM = CalendarDateUtils.minutesSinceMidnight(
                                item.event.endsAt,
                              );
                              final top = (startM / 60) * _hourHeight;
                              final height =
                                  ((endM - startM) / 60 * _hourHeight)
                                      .clamp(22.0, double.infinity);
                              return Positioned(
                                left: 2,
                                right: 2,
                                top: top,
                                height: height,
                                child: _TimelineEventBlock(
                                  item: item,
                                  compact: true,
                                  onTap: () => widget.onEventTap(item),
                                ),
                              );
                            }),
                            if (CalendarDateUtils.isSameDay(day, _now))
                              Positioned(
                                left: 0,
                                right: 0,
                                top: (CalendarDateUtils.minutesSinceMidnight(_now) /
                                        60) *
                                    _hourHeight,
                                child: const _NowLine(compact: true),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.focusDay,
    required this.events,
    required this.weekdayLabels,
    required this.onSelectDay,
    required this.onEventTap,
  });

  final DateTime focusDay;
  final List<EventWithCalendar> events;
  final List<String> weekdayLabels;
  final ValueChanged<DateTime> onSelectDay;
  final ValueChanged<EventWithCalendar> onEventTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final gridStart = CalendarDateUtils.monthGridStart(focusDay);
    final days = List.generate(42, (i) => gridStart.add(Duration(days: i)));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: LumenSpacing.pagePadding),
      child: Column(
        children: [
          Row(
            children: [
              for (final label in weekdayLabels)
                Expanded(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: theme.labelSmall?.copyWith(
                      color: LumenColors.textMuted,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: LumenSpacing.xs),
          Expanded(
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                childAspectRatio: 0.72,
              ),
              itemCount: 42,
              itemBuilder: (context, index) {
                final day = days[index];
                final inMonth = day.month == focusDay.month;
                final dayEvents = events
                    .where((e) => CalendarDateUtils.isSameDay(e.event.startsAt, day))
                    .toList();
                final isToday = CalendarDateUtils.isToday(day);

                return GestureDetector(
                  onTap: () => onSelectDay(day),
                  child: GlassSurface(
                    borderRadius: BorderRadius.circular(14),
                    blur: 18,
                    fillColor: inMonth
                        ? LumenColors.glassFill
                        : LumenColors.glassFill.withValues(alpha: 0.04),
                    strokeColor: isToday
                        ? LumenColors.accentBlue.withValues(alpha: 0.45)
                        : LumenColors.glassStroke,
                    glowColor: isToday ? LumenColors.accentBlue : null,
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${day.day}',
                          style: theme.labelLarge?.copyWith(
                            color: inMonth
                                ? (isToday
                                    ? LumenColors.accentBlue
                                    : LumenColors.text)
                                : LumenColors.textMuted.withValues(alpha: 0.45),
                            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: Column(
                            children: [
                              for (final item in dayEvents.take(3))
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  child: GestureDetector(
                                    onTap: () => onEventTap(item),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(item.calendar.colorArgb)
                                            .withValues(alpha: 0.28),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: Color(item.calendar.colorArgb)
                                              .withValues(alpha: 0.5),
                                        ),
                                      ),
                                      child: Text(
                                        item.event.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.labelSmall?.copyWith(
                                          color: LumenColors.text,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (dayEvents.length > 3)
                                Text(
                                  '+${dayEvents.length - 3}',
                                  style: theme.labelSmall?.copyWith(
                                    color: LumenColors.textMuted,
                                    fontSize: 10,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineEventBlock extends StatelessWidget {
  const _TimelineEventBlock({
    required this.item,
    required this.onTap,
    this.compact = false,
  });

  final EventWithCalendar item;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = Color(item.calendar.colorArgb);
    final theme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: color.withValues(alpha: 0.22),
            border: Border.all(color: color.withValues(alpha: 0.55)),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.18),
                blurRadius: 14,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 4 : 10,
              vertical: compact ? 4 : 8,
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                compact
                    ? item.event.title
                    : '${item.event.title}\n${CalendarDateUtils.formatTimeRange(item.event.startsAt, item.event.endsAt)}',
                maxLines: compact ? 2 : 3,
                overflow: TextOverflow.ellipsis,
                style: theme.labelLarge?.copyWith(
                  color: LumenColors.text,
                  fontSize: compact ? 11 : 13,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NowLine extends StatelessWidget {
  const _NowLine({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: compact ? 6 : 8,
          height: compact ? 6 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: LumenColors.accentRed,
            boxShadow: [
              BoxShadow(
                color: LumenColors.accentRed.withValues(alpha: 0.55),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  LumenColors.accentRed,
                  LumenColors.accentRed.withValues(alpha: 0.15),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: LumenColors.accentRed.withValues(alpha: 0.35),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
