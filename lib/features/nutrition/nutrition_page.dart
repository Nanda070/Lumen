import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/app_database.dart';
import '../../design_system/design_system.dart';
import '../../l10n/app_localizations.dart';

/// Nutrition diary — OpenNutriTracker-inspired kcal ring + meal sections.
class NutritionPage extends StatefulWidget {
  const NutritionPage({super.key, required this.database});

  final AppDatabase database;

  @override
  State<NutritionPage> createState() => _NutritionPageState();
}

const _mealTypes = ['breakfast', 'lunch', 'dinner', 'snack'];

class _NutritionPageState extends State<NutritionPage> {
  late DateTime _day;

  @override
  void initState() {
    super.initState();
    _day = AppDatabase.dayOnly(DateTime.now());
  }

  void _shiftDay(int delta) {
    setState(() {
      _day = AppDatabase.dayOnly(_day.add(Duration(days: delta)));
    });
  }

  Future<void> _openEntry({
    required String mealType,
    FoodEntry? existing,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FoodEntrySheet(
        database: widget.database,
        day: _day,
        mealType: mealType,
        existing: existing,
      ),
    );
  }

  Future<void> _openTargets(NutritionTarget targets) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TargetsSheet(
        database: widget.database,
        targets: targets,
      ),
    );
  }

  String _mealLabel(AppLocalizations l10n, String type) {
    return switch (type) {
      'breakfast' => l10n.nutritionBreakfast,
      'lunch' => l10n.nutritionLunch,
      'dinner' => l10n.nutritionDinner,
      _ => l10n.nutritionSnack,
    };
  }

  IconData _mealIcon(String type) {
    return switch (type) {
      'breakfast' => PhosphorIconsRegular.coffee,
      'lunch' => PhosphorIconsRegular.forkKnife,
      'dinner' => PhosphorIconsRegular.cookingPot,
      _ => PhosphorIconsRegular.cookie,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toString();
    final dateFmt = DateFormat.MMMEd(locale);
    final isToday = _day == AppDatabase.dayOnly(DateTime.now());

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
                    Text(l10n.moreNutrition, style: theme.headlineLarge),
                    const SizedBox(height: LumenSpacing.xs),
                    Text(
                      l10n.nutritionSubtitle,
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
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: LumenSpacing.pagePadding,
          ),
          child: GlassSurface(
            borderRadius: LumenRadii.pill,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => _shiftDay(-1),
                  icon: const Icon(PhosphorIconsRegular.caretLeft, size: 18),
                ),
                Expanded(
                  child: Text(
                    isToday ? l10n.nutritionToday : dateFmt.format(_day),
                    textAlign: TextAlign.center,
                    style: theme.titleMedium,
                  ),
                ),
                IconButton(
                  onPressed: () => _shiftDay(1),
                  icon: const Icon(PhosphorIconsRegular.caretRight, size: 18),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: LumenSpacing.md),
        Expanded(
          child: StreamBuilder<NutritionTarget>(
            stream: widget.database.watchNutritionTargets(),
            builder: (context, targetSnap) {
              return StreamBuilder<List<FoodEntry>>(
                stream: widget.database.watchFoodEntriesForDay(_day),
                builder: (context, entrySnap) {
                  if (!targetSnap.hasData || !entrySnap.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: LumenColors.accentViolet,
                      ),
                    );
                  }
                  final targets = targetSnap.data!;
                  final entries = entrySnap.data!;
                  final supplied = entries.fold<int>(
                    0,
                    (s, e) => s + e.caloriesKcal,
                  );
                  final carbs = entries.fold<int>(0, (s, e) => s + e.carbsG);
                  final fat = entries.fold<int>(0, (s, e) => s + e.fatG);
                  final protein =
                      entries.fold<int>(0, (s, e) => s + e.proteinG);
                  final left = targets.caloriesKcal - supplied;
                  final gauge = targets.caloriesKcal <= 0
                      ? 0.0
                      : (supplied / targets.caloriesKcal).clamp(0.0, 1.0);

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(
                      LumenSpacing.pagePadding,
                      0,
                      LumenSpacing.pagePadding,
                      LumenSpacing.xxl,
                    ),
                    children: [
                      GlowCard(
                        violetEdge: true,
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _MiniStat(
                                    icon: PhosphorIconsRegular.arrowDown,
                                    value: '$supplied',
                                    label: l10n.nutritionSupplied,
                                    color: LumenColors.nutriProtein,
                                  ),
                                ),
                                Expanded(
                                  child: _MiniStat(
                                    icon: PhosphorIconsRegular.target,
                                    value: '${targets.caloriesKcal}',
                                    label: l10n.nutritionGoal,
                                    color: LumenColors.nutriCarbs,
                                    trailing: true,
                                    onTap: () => _openTargets(targets),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: LumenSpacing.lg),
                            SizedBox(
                              width: 180,
                              height: 180,
                              child: CustomPaint(
                                painter: _KcalRingPainter(
                                  progress: gauge,
                                  color: left < 0
                                      ? LumenColors.accentRed
                                      : LumenColors.nutriRing,
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${left.abs()}',
                                        style: theme.displaySmall?.copyWith(
                                          height: 1,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        left < 0
                                            ? l10n.nutritionKcalOver
                                            : l10n.nutritionKcalLeft,
                                        style: theme.bodySmall?.copyWith(
                                          color: LumenColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: LumenSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: _MacroTile(
                              label: l10n.nutritionCarbs,
                              intake: carbs,
                              goal: targets.carbsG,
                              color: LumenColors.nutriCarbs,
                            ),
                          ),
                          const SizedBox(width: LumenSpacing.sm),
                          Expanded(
                            child: _MacroTile(
                              label: l10n.nutritionFat,
                              intake: fat,
                              goal: targets.fatG,
                              color: LumenColors.nutriFat,
                            ),
                          ),
                          const SizedBox(width: LumenSpacing.sm),
                          Expanded(
                            child: _MacroTile(
                              label: l10n.nutritionProtein,
                              intake: protein,
                              goal: targets.proteinG,
                              color: LumenColors.nutriProtein,
                            ),
                          ),
                        ],
                      ),
                      if (entries.isEmpty) ...[
                        const SizedBox(height: LumenSpacing.lg),
                        Text(
                          l10n.nutritionEmptyHint,
                          textAlign: TextAlign.center,
                          style: theme.bodyMedium?.copyWith(
                            color: LumenColors.textMuted,
                          ),
                        ),
                      ],
                      for (final meal in _mealTypes) ...[
                        const SizedBox(height: LumenSpacing.lg),
                        _MealSection(
                          title: _mealLabel(l10n, meal),
                          icon: _mealIcon(meal),
                          entries: entries
                              .where((e) => e.mealType == meal)
                              .toList(),
                          onAdd: () => _openEntry(mealType: meal),
                          onEdit: (e) =>
                              _openEntry(mealType: meal, existing: e),
                          onDelete: (e) =>
                              widget.database.deleteFoodEntry(e.id),
                          kcalUnit: l10n.nutritionKcal,
                        ),
                      ],
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

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.trailing = false,
    this.onTap,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final bool trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final child = Column(
      crossAxisAlignment:
          trailing ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.16),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(height: 6),
        Text(value, style: theme.titleMedium),
        Text(
          label,
          style: theme.labelSmall?.copyWith(color: LumenColors.textMuted),
        ),
      ],
    );
    if (onTap == null) return child;
    return GestureDetector(onTap: onTap, child: child);
  }
}

class _MacroTile extends StatelessWidget {
  const _MacroTile({
    required this.label,
    required this.intake,
    required this.goal,
    required this.color,
  });

  final String label;
  final int intake;
  final int goal;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final pct = goal <= 0 ? 0.0 : (intake / goal).clamp(0.0, 1.0);
    return GlowCard(
      padding: const EdgeInsets.all(LumenSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.labelMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: LumenSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 7,
              backgroundColor: LumenColors.surface,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          const SizedBox(height: LumenSpacing.sm),
          Text(
            '$intake/$goal g',
            style: theme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _MealSection extends StatelessWidget {
  const _MealSection({
    required this.title,
    required this.icon,
    required this.entries,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    required this.kcalUnit,
  });

  final String title;
  final IconData icon;
  final List<FoodEntry> entries;
  final VoidCallback onAdd;
  final ValueChanged<FoodEntry> onEdit;
  final ValueChanged<FoodEntry> onDelete;
  final String kcalUnit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final total =
        entries.fold<int>(0, (s, e) => s + e.caloriesKcal);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: LumenColors.accentViolet),
            const SizedBox(width: LumenSpacing.xs),
            Expanded(
              child: Text(title, style: theme.titleMedium),
            ),
            if (entries.isNotEmpty)
              Text(
                '$total $kcalUnit',
                style: theme.labelMedium?.copyWith(
                  color: LumenColors.textMuted,
                ),
              ),
            IconButton(
              onPressed: onAdd,
              icon: const Icon(
                PhosphorIconsRegular.plusCircle,
                color: LumenColors.accentMint,
                size: 22,
              ),
            ),
          ],
        ),
        if (entries.isEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 4),
            child: Text(
              AppLocalizations.of(context).nutritionAddEntry,
              style: theme.bodySmall?.copyWith(color: LumenColors.textMuted),
            ),
          )
        else
          for (final e in entries)
            Padding(
              padding: const EdgeInsets.only(bottom: LumenSpacing.xs),
              child: GlowCard(
                onTap: () => onEdit(e),
                padding: const EdgeInsets.symmetric(
                  horizontal: LumenSpacing.md,
                  vertical: LumenSpacing.sm,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.name, style: theme.titleMedium),
                          Text(
                            '${e.caloriesKcal} $kcalUnit · C${e.carbsG} F${e.fatG} P${e.proteinG}',
                            style: theme.bodySmall?.copyWith(
                              color: LumenColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => onDelete(e),
                      icon: const Icon(
                        PhosphorIconsRegular.trash,
                        size: 18,
                        color: LumenColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}

class _KcalRingPainter extends CustomPainter {
  _KcalRingPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.shortestSide / 2 - 10;
    final track = Paint()
      ..color = LumenColors.surface
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
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
  bool shouldRepaint(covariant _KcalRingPainter old) =>
      old.progress != progress || old.color != color;
}

class _FoodEntrySheet extends StatefulWidget {
  const _FoodEntrySheet({
    required this.database,
    required this.day,
    required this.mealType,
    this.existing,
  });

  final AppDatabase database;
  final DateTime day;
  final String mealType;
  final FoodEntry? existing;

  @override
  State<_FoodEntrySheet> createState() => _FoodEntrySheetState();
}

class _FoodEntrySheetState extends State<_FoodEntrySheet> {
  late final TextEditingController _name;
  late final TextEditingController _kcal;
  late final TextEditingController _carbs;
  late final TextEditingController _fat;
  late final TextEditingController _protein;
  late String _meal;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.name ?? '');
    _kcal = TextEditingController(text: e != null ? '${e.caloriesKcal}' : '');
    _carbs = TextEditingController(text: e != null ? '${e.carbsG}' : '0');
    _fat = TextEditingController(text: e != null ? '${e.fatG}' : '0');
    _protein = TextEditingController(text: e != null ? '${e.proteinG}' : '0');
    _meal = e?.mealType ?? widget.mealType;
  }

  @override
  void dispose() {
    _name.dispose();
    _kcal.dispose();
    _carbs.dispose();
    _fat.dispose();
    _protein.dispose();
    super.dispose();
  }

  int _parse(TextEditingController c) => int.tryParse(c.text.trim()) ?? 0;

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (_name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.nutritionNameRequired)),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final e = widget.existing;
      if (e == null) {
        await widget.database.insertFoodEntry(
          day: widget.day,
          mealType: _meal,
          name: _name.text,
          caloriesKcal: _parse(_kcal),
          carbsG: _parse(_carbs),
          fatG: _parse(_fat),
          proteinG: _parse(_protein),
        );
      } else {
        await widget.database.updateFoodEntry(
          id: e.id,
          mealType: _meal,
          name: _name.text,
          caloriesKcal: _parse(_kcal),
          carbsG: _parse(_carbs),
          fatG: _parse(_fat),
          proteinG: _parse(_protein),
          grams: e.grams,
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
        color: LumenColors.surfaceRaised,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.existing == null
                      ? l10n.nutritionAddEntry
                      : l10n.nutritionEditEntry,
                  style: theme.titleLarge,
                ),
                const SizedBox(height: LumenSpacing.md),
                TextField(
                  controller: _name,
                  decoration: InputDecoration(labelText: l10n.nutritionFoodName),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: LumenSpacing.sm),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final m in _mealTypes)
                      ChoiceChip(
                        label: Text(switch (m) {
                          'breakfast' => l10n.nutritionBreakfast,
                          'lunch' => l10n.nutritionLunch,
                          'dinner' => l10n.nutritionDinner,
                          _ => l10n.nutritionSnack,
                        }),
                        selected: _meal == m,
                        onSelected: (_) => setState(() => _meal = m),
                      ),
                  ],
                ),
                const SizedBox(height: LumenSpacing.sm),
                TextField(
                  controller: _kcal,
                  decoration: InputDecoration(labelText: l10n.nutritionKcal),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: LumenSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _carbs,
                        decoration:
                            InputDecoration(labelText: l10n.nutritionCarbs),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _fat,
                        decoration:
                            InputDecoration(labelText: l10n.nutritionFat),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _protein,
                        decoration:
                            InputDecoration(labelText: l10n.nutritionProtein),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: LumenSpacing.lg),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  child: Text(l10n.financeSave),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TargetsSheet extends StatefulWidget {
  const _TargetsSheet({required this.database, required this.targets});

  final AppDatabase database;
  final NutritionTarget targets;

  @override
  State<_TargetsSheet> createState() => _TargetsSheetState();
}

class _TargetsSheetState extends State<_TargetsSheet> {
  late final TextEditingController _kcal;
  late final TextEditingController _carbs;
  late final TextEditingController _fat;
  late final TextEditingController _protein;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final t = widget.targets;
    _kcal = TextEditingController(text: '${t.caloriesKcal}');
    _carbs = TextEditingController(text: '${t.carbsG}');
    _fat = TextEditingController(text: '${t.fatG}');
    _protein = TextEditingController(text: '${t.proteinG}');
  }

  @override
  void dispose() {
    _kcal.dispose();
    _carbs.dispose();
    _fat.dispose();
    _protein.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await widget.database.updateNutritionTargets(
        caloriesKcal: int.tryParse(_kcal.text) ?? 2000,
        carbsG: int.tryParse(_carbs.text) ?? 250,
        fatG: int.tryParse(_fat.text) ?? 70,
        proteinG: int.tryParse(_protein.text) ?? 150,
      );
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
        color: LumenColors.surfaceRaised,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.nutritionEditGoals, style: theme.titleLarge),
                const SizedBox(height: LumenSpacing.md),
                TextField(
                  controller: _kcal,
                  decoration: InputDecoration(labelText: l10n.nutritionGoal),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _carbs,
                        decoration:
                            InputDecoration(labelText: l10n.nutritionCarbs),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _fat,
                        decoration:
                            InputDecoration(labelText: l10n.nutritionFat),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _protein,
                        decoration:
                            InputDecoration(labelText: l10n.nutritionProtein),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: LumenSpacing.lg),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  child: Text(l10n.financeSave),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
