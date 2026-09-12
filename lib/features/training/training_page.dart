import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/app_database.dart';
import '../../design_system/design_system.dart';
import '../../l10n/app_localizations.dart';

/// Training hub — GymMane-inspired focus hero, routines, live session.
class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key, required this.database});

  final AppDatabase database;

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  Future<void> _openWorkoutEditor({Workout? existing}) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _WorkoutEditorSheet(
        database: widget.database,
        existing: existing,
      ),
    );
  }

  Future<void> _startWorkout(Workout workout) async {
    final exercises =
        await widget.database.getWorkoutExercises(workout.id);
    final sessionId = await widget.database.startWorkoutSession(
      workoutId: workout.id,
      title: workout.title,
    );
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AtmosphereBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: _SessionView(
                database: widget.database,
                sessionId: sessionId,
                title: workout.title,
                exerciseNames: exercises.map((e) => e.name).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _startQuick() async {
    final l10n = AppLocalizations.of(context);
    final sessionId = await widget.database.startWorkoutSession(
      title: l10n.trainingQuickSession,
    );
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AtmosphereBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: _SessionView(
                database: widget.database,
                sessionId: sessionId,
                title: l10n.trainingQuickSession,
                exerciseNames: const [],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _resumeSession(WorkoutSession session) async {
    final exercises = session.workoutId != null
        ? await widget.database.getWorkoutExercises(session.workoutId!)
        : <WorkoutExercise>[];
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AtmosphereBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: _SessionView(
                database: widget.database,
                sessionId: session.id,
                title: session.title,
                exerciseNames: exercises.map((e) => e.name).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toString();
    final now = DateTime.now();
    final dateLabel = DateFormat.MMMEd(locale).format(now);
    final weekStart = AppDatabase.dayOnly(
      now.subtract(Duration(days: now.weekday - 1)),
    );

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
                      l10n.trainingTodayLabel.toUpperCase(),
                      style: theme.labelSmall?.copyWith(
                        color: LumenColors.textMuted,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(dateLabel, style: theme.headlineSmall),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(PhosphorIconsRegular.x),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<WorkoutSession?>(
            stream: widget.database.watchActiveSession(),
            builder: (context, activeSnap) {
              return StreamBuilder<List<Workout>>(
                stream: widget.database.watchWorkouts(),
                builder: (context, workoutSnap) {
                  return StreamBuilder<List<WorkoutSession>>(
                    stream: widget.database.watchSessionsInRange(
                      weekStart,
                      weekStart.add(const Duration(days: 6)),
                    ),
                    builder: (context, sessionSnap) {
                      final workouts = workoutSnap.data ?? [];
                      final weekSessions = sessionSnap.data ?? [];
                      final active = activeSnap.data;
                      final doneDays = <int>{};
                      for (final s in weekSessions) {
                        final local = s.startedAt.toLocal();
                        doneDays.add(local.weekday);
                      }
                      final setsToday = weekSessions
                          .where((s) {
                            final d = AppDatabase.dayOnly(
                              s.startedAt.toLocal(),
                            );
                            return d == AppDatabase.dayOnly(now);
                          })
                          .length;

                      return ListView(
                        padding: const EdgeInsets.fromLTRB(
                          LumenSpacing.pagePadding,
                          LumenSpacing.sm,
                          LumenSpacing.pagePadding,
                          LumenSpacing.xxl,
                        ),
                        children: [
                          if (active != null) ...[
                            _ActiveBanner(
                              title: active.title,
                              onResume: () => _resumeSession(active),
                            ),
                            const SizedBox(height: LumenSpacing.md),
                          ],
                          _FocusHero(
                            title: l10n.trainingFocusTitle,
                            subtitle: workouts.isEmpty
                                ? l10n.trainingFirstHint
                                : l10n.trainingFocusSubtitle(
                                    workouts.length,
                                  ),
                            cta: l10n.trainingStartWorkout,
                            onStart: workouts.isEmpty
                                ? _startQuick
                                : () => _startWorkout(workouts.first),
                          ),
                          const SizedBox(height: LumenSpacing.lg),
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: LumenColors.gymRaised,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: LumenColors.gymBorder),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                for (var i = 1; i <= 7; i++)
                                  _WeekDayDot(
                                    weekday: i,
                                    done: doneDays.contains(i),
                                    isToday: now.weekday == i,
                                    label: DateFormat.E(locale)
                                        .format(
                                          weekStart.add(Duration(days: i - 1)),
                                        )
                                        .characters
                                        .first
                                        .toUpperCase(),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: LumenSpacing.lg),
                          Text(
                            l10n.trainingThisWeek.toUpperCase(),
                            style: theme.labelMedium?.copyWith(
                              color: LumenColors.textMuted,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: LumenSpacing.sm),
                          Row(
                            children: [
                              Expanded(
                                child: _StatCard(
                                  label: l10n.trainingSessions,
                                  value: '${weekSessions.length}',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _StatCard(
                                  label: l10n.trainingTodaySessions,
                                  value: '$setsToday',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: LumenSpacing.lg),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  l10n.trainingYourWorkouts.toUpperCase(),
                                  style: theme.labelMedium?.copyWith(
                                    color: LumenColors.textMuted,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => _openWorkoutEditor(),
                                icon: const Icon(
                                  PhosphorIconsRegular.plusCircle,
                                  color: LumenColors.gymAccent,
                                ),
                              ),
                            ],
                          ),
                          if (workouts.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Text(
                                l10n.trainingEmpty,
                                textAlign: TextAlign.center,
                                style: theme.bodyMedium?.copyWith(
                                  color: LumenColors.textMuted,
                                ),
                              ),
                            )
                          else
                            for (final w in workouts)
                              _WorkoutCard(
                                workout: w,
                                database: widget.database,
                                onOpen: () => _openWorkoutEditor(existing: w),
                                onStart: () => _startWorkout(w),
                              ),
                          const SizedBox(height: LumenSpacing.md),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: LumenColors.gymEmber,
                                foregroundColor: LumenColors.gymOnEmber,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () => _openWorkoutEditor(),
                              child: Text(l10n.trainingNewWorkout),
                            ),
                          ),
                        ],
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

class _FocusHero extends StatelessWidget {
  const _FocusHero({
    required this.title,
    required this.subtitle,
    required this.cta,
    required this.onStart,
  });

  final String title;
  final String subtitle;
  final String cta;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: LumenColors.gymRaised,
          border: Border.all(color: LumenColors.gymBorder),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            Positioned(
              left: -40,
              bottom: -40,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: LumenColors.gymAccent.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)
                        .trainingTodaysFocus
                        .toUpperCase(),
                    style: theme.labelMedium?.copyWith(
                      color: LumenColors.gymBrass,
                      letterSpacing: 2.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: theme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: theme.bodyMedium?.copyWith(
                      color: LumenColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: LumenColors.gymEmber,
                        foregroundColor: LumenColors.gymOnEmber,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: onStart,
                      icon: const Icon(PhosphorIconsFill.play, size: 18),
                      label: Text(cta),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveBanner extends StatelessWidget {
  const _ActiveBanner({required this.title, required this.onResume});

  final String title;
  final VoidCallback onResume;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    return Material(
      color: LumenColors.gymRaised2,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onResume,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: LumenColors.gymAccent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.trainingInProgress.toUpperCase(),
                      style: theme.labelSmall?.copyWith(
                        color: LumenColors.gymAccent,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(title, style: theme.titleMedium),
                  ],
                ),
              ),
              Icon(
                PhosphorIconsFill.play,
                color: LumenColors.gymEmber,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeekDayDot extends StatelessWidget {
  const _WeekDayDot({
    required this.weekday,
    required this.done,
    required this.isToday,
    required this.label,
  });

  final int weekday;
  final bool done;
  final bool isToday;
  final String label;

  @override
  Widget build(BuildContext context) {
    Color fill = LumenColors.gymRaised2;
    Border? border;
    if (done) {
      fill = LumenColors.gymEmber;
    } else if (isToday) {
      border = Border.all(color: LumenColors.gymEmber, width: 2);
    } else {
      border = Border.all(color: LumenColors.textMuted.withValues(alpha: 0.4));
    }

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isToday ? LumenColors.gymAccent : LumenColors.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: fill,
            shape: BoxShape.circle,
            border: border,
          ),
          child: done
              ? const Icon(
                  PhosphorIconsBold.check,
                  size: 14,
                  color: LumenColors.gymOnEmber,
                )
              : null,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LumenColors.gymRaised,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: LumenColors.gymBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: theme.labelSmall?.copyWith(
              color: LumenColors.textMuted,
              letterSpacing: 1,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  const _WorkoutCard({
    required this.workout,
    required this.database,
    required this.onOpen,
    required this.onStart,
  });

  final Workout workout;
  final AppDatabase database;
  final VoidCallback onOpen;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);
    return StreamBuilder<List<WorkoutExercise>>(
      stream: database.watchWorkoutExercises(workout.id),
      builder: (context, snap) {
        final n = snap.data?.length ?? 0;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Material(
            color: LumenColors.gymRaised,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: onOpen,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: LumenColors.gymBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: LumenColors.gymEmberSoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        PhosphorIconsRegular.listChecks,
                        color: LumenColors.gymAccent,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(workout.title, style: theme.titleMedium),
                          Text(
                            l10n.trainingExerciseCount(n),
                            style: theme.bodySmall?.copyWith(
                              color: LumenColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (n > 0)
                      GestureDetector(
                        onTap: onStart,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: LumenColors.gymEmber,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            PhosphorIconsFill.play,
                            size: 18,
                            color: LumenColors.gymOnEmber,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SessionView extends StatefulWidget {
  const _SessionView({
    required this.database,
    required this.sessionId,
    required this.title,
    required this.exerciseNames,
  });

  final AppDatabase database;
  final int sessionId;
  final String title;
  final List<String> exerciseNames;

  @override
  State<_SessionView> createState() => _SessionViewState();
}

class _SessionViewState extends State<_SessionView> {
  late List<String> _names;
  late DateTime _started;

  @override
  void initState() {
    super.initState();
    _names = List.of(widget.exerciseNames);
    _started = DateTime.now();
  }

  String _elapsed() {
    final d = DateTime.now().difference(_started);
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _addExercise() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return AlertDialog(
          backgroundColor: LumenColors.gymRaised,
          title: Text(l10n.trainingAddExercise),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(hintText: l10n.trainingExerciseHint),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.tasksClearDue),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: Text(l10n.financeSave),
            ),
          ],
        );
      },
    );
    if (name != null && name.isNotEmpty) {
      setState(() => _names.add(name));
    }
  }

  Future<void> _logSet(String exercise) async {
    final repsCtrl = TextEditingController(text: '10');
    final kgCtrl = TextEditingController(text: '0');
    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        final bottom = MediaQuery.viewInsetsOf(context).bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: bottom),
          child: Material(
            color: LumenColors.gymRaised,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(exercise, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: repsCtrl,
                            decoration:
                                InputDecoration(labelText: l10n.trainingReps),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: kgCtrl,
                            decoration:
                                InputDecoration(labelText: l10n.trainingWeightKg),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: LumenColors.gymEmber,
                        foregroundColor: LumenColors.gymOnEmber,
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(l10n.trainingLogSet),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    if (ok != true) return;
    final reps = int.tryParse(repsCtrl.text) ?? 0;
    final kg = double.tryParse(kgCtrl.text.replaceAll(',', '.')) ?? 0;
    await widget.database.addSessionSet(
      sessionId: widget.sessionId,
      exerciseName: exercise,
      reps: reps,
      weightGrams: (kg * 1000).round(),
    );
  }

  Future<void> _finish() async {
    await widget.database.finishWorkoutSession(widget.sessionId);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;

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
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: LumenColors.gymAccent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.trainingInProgress.toUpperCase(),
                style: theme.labelMedium?.copyWith(
                  color: LumenColors.gymAccent,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (_, _) => Text(
                  _elapsed(),
                  style: theme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(PhosphorIconsRegular.x),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: LumenSpacing.pagePadding,
          ),
          child: Text(
            widget.title,
            style: theme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: LumenSpacing.md),
        Expanded(
          child: StreamBuilder<List<SessionSet>>(
            stream: widget.database.watchSessionSets(widget.sessionId),
            builder: (context, snap) {
              final sets = snap.data ?? [];
              final names = {
                ..._names,
                ...sets.map((s) => s.exerciseName),
              }.toList();

              return ListView(
                padding: const EdgeInsets.fromLTRB(
                  LumenSpacing.pagePadding,
                  0,
                  LumenSpacing.pagePadding,
                  LumenSpacing.xxl,
                ),
                children: [
                  if (names.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Text(
                        l10n.trainingAddExerciseHint,
                        textAlign: TextAlign.center,
                        style: theme.bodyMedium?.copyWith(
                          color: LumenColors.textMuted,
                        ),
                      ),
                    ),
                  for (final name in names)
                    _ExerciseBlock(
                      name: name,
                      sets: sets.where((s) => s.exerciseName == name).toList(),
                      onAddSet: () => _logSet(name),
                      onDeleteSet: (id) =>
                          widget.database.deleteSessionSet(id),
                      repsLabel: l10n.trainingReps,
                      kgLabel: l10n.trainingWeightKg,
                    ),
                  TextButton.icon(
                    onPressed: _addExercise,
                    icon: const Icon(PhosphorIconsRegular.plus),
                    label: Text(l10n.trainingAddExercise),
                  ),
                  const SizedBox(height: LumenSpacing.md),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: LumenColors.gymEmber,
                      foregroundColor: LumenColors.gymOnEmber,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _finish,
                    child: Text(l10n.trainingFinish),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ExerciseBlock extends StatelessWidget {
  const _ExerciseBlock({
    required this.name,
    required this.sets,
    required this.onAddSet,
    required this.onDeleteSet,
    required this.repsLabel,
    required this.kgLabel,
  });

  final String name;
  final List<SessionSet> sets;
  final VoidCallback onAddSet;
  final ValueChanged<int> onDeleteSet;
  final String repsLabel;
  final String kgLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LumenColors.gymRaised,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: LumenColors.gymBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                onPressed: onAddSet,
                icon: const Icon(
                  PhosphorIconsRegular.plusCircle,
                  color: LumenColors.gymAccent,
                ),
              ),
            ],
          ),
          if (sets.isEmpty)
            Text(
              '—',
              style: theme.bodySmall?.copyWith(color: LumenColors.textMuted),
            )
          else
            for (final s in sets)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Text(
                      '#${s.setIndex}',
                      style: theme.labelMedium?.copyWith(
                        color: LumenColors.gymBrass,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${s.reps} $repsLabel × ${(s.weightGrams / 1000).toStringAsFixed(s.weightGrams % 1000 == 0 ? 0 : 1)} $kgLabel',
                        style: theme.bodyMedium,
                      ),
                    ),
                    IconButton(
                      onPressed: () => onDeleteSet(s.id),
                      icon: const Icon(
                        PhosphorIconsRegular.trash,
                        size: 16,
                        color: LumenColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}

class _WorkoutEditorSheet extends StatefulWidget {
  const _WorkoutEditorSheet({required this.database, this.existing});

  final AppDatabase database;
  final Workout? existing;

  @override
  State<_WorkoutEditorSheet> createState() => _WorkoutEditorSheetState();
}

class _ExerciseDraft {
  _ExerciseDraft({this.name = '', this.sets = 3, this.reps = 10});
  String name;
  int sets;
  int reps;
}

class _WorkoutEditorSheetState extends State<_WorkoutEditorSheet> {
  late final TextEditingController _title;
  final List<_ExerciseDraft> _exercises = [];
  bool _saving = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.existing?.title ?? '');
    if (widget.existing != null) {
      _loading = true;
      widget.database.getWorkoutExercises(widget.existing!.id).then((list) {
        if (!mounted) return;
        setState(() {
          _exercises
            ..clear()
            ..addAll(
              list.map(
                (e) => _ExerciseDraft(
                  name: e.name,
                  sets: e.targetSets,
                  reps: e.targetReps,
                ),
              ),
            );
          if (_exercises.isEmpty) _exercises.add(_ExerciseDraft());
          _loading = false;
        });
      });
    } else {
      _exercises.add(_ExerciseDraft());
    }
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (_title.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.trainingTitleRequired)),
      );
      return;
    }
    final ex = _exercises
        .where((e) => e.name.trim().isNotEmpty)
        .map(
          (e) => (
            name: e.name.trim(),
            targetSets: e.sets,
            targetReps: e.reps,
          ),
        )
        .toList();
    setState(() => _saving = true);
    try {
      final existing = widget.existing;
      if (existing == null) {
        await widget.database.insertWorkout(
          title: _title.text,
          exercises: ex,
        );
      } else {
        await widget.database.updateWorkout(
          id: existing.id,
          title: _title.text,
          exercises: ex,
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
      child: Material(
        color: LumenColors.gymRaised,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: _loading
                ? const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.existing == null
                            ? l10n.trainingNewWorkout
                            : l10n.trainingEditWorkout,
                        style: theme.titleLarge,
                      ),
                      const SizedBox(height: LumenSpacing.md),
                      TextField(
                        controller: _title,
                        decoration: InputDecoration(
                          hintText: l10n.trainingTitleHint,
                        ),
                      ),
                      const SizedBox(height: LumenSpacing.md),
                      Text(l10n.trainingExercises, style: theme.titleMedium),
                      const SizedBox(height: LumenSpacing.sm),
                      for (var i = 0; i < _exercises.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  initialValue: _exercises[i].name,
                                  onChanged: (v) => _exercises[i].name = v,
                                  decoration: InputDecoration(
                                    hintText: l10n.trainingExerciseHint,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 52,
                                child: TextFormField(
                                  initialValue: '${_exercises[i].sets}',
                                  onChanged: (v) => _exercises[i].sets =
                                      int.tryParse(v) ?? 3,
                                  decoration: InputDecoration(
                                    labelText: l10n.trainingSetsShort,
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 52,
                                child: TextFormField(
                                  initialValue: '${_exercises[i].reps}',
                                  onChanged: (v) => _exercises[i].reps =
                                      int.tryParse(v) ?? 10,
                                  decoration: InputDecoration(
                                    labelText: l10n.trainingRepsShort,
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() => _exercises.removeAt(i));
                                },
                                icon: const Icon(
                                  PhosphorIconsRegular.trash,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      TextButton.icon(
                        onPressed: () =>
                            setState(() => _exercises.add(_ExerciseDraft())),
                        icon: const Icon(PhosphorIconsRegular.plus),
                        label: Text(l10n.trainingAddExercise),
                      ),
                      const SizedBox(height: LumenSpacing.md),
                      Row(
                        children: [
                          if (widget.existing != null)
                            TextButton(
                              onPressed: () async {
                                await widget.database
                                    .deleteWorkout(widget.existing!.id);
                                if (context.mounted) Navigator.pop(context);
                              },
                              child: Text(
                                l10n.trainingDelete,
                                style: const TextStyle(
                                  color: LumenColors.accentRed,
                                ),
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
      ),
    );
  }
}
