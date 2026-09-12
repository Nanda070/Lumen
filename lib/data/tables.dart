import 'package:drift/drift.dart';

/// Single local user profile created at the end of onboarding.
class Profiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get displayName => text().withLength(min: 1, max: 64)();
  TextColumn get localeCode => text().withLength(min: 2, max: 8)();
  TextColumn get countryCode => text().withLength(min: 2, max: 8)();
  TextColumn get currencyCode => text().withLength(min: 3, max: 8)();
  DateTimeColumn get createdAt => dateTime()();
}

/// Local calendars (seeded Personal / Lumen; optional Google link).
class Calendars extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 64)();
  IntColumn get colorArgb => integer()();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  /// Google Calendar id when linked (e.g. primary).
  TextColumn get googleCalendarId => text().nullable()();
  TextColumn get googleSyncToken => text().nullable()();
}

/// Local calendar events (+ optional Google Event id).
class Events extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  DateTimeColumn get startsAt => dateTime()();
  DateTimeColumn get endsAt => dateTime()();
  IntColumn get calendarId => integer().references(Calendars, #id)();
  TextColumn get googleEventId => text().nullable()();
  /// Google ETag for last-write-wins.
  TextColumn get googleEtag => text().nullable()();
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

/// Google account link + sync status (at most one row).
class GoogleSyncState extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get accountEmail => text().nullable()();
  BoolColumn get connected => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
  TextColumn get lastError => text().nullable()();
}

/// Tasks inbox / today.
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
  DateTimeColumn get dueDate => dateTime().nullable()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

/// Money categories — seeded defaults + user-created.
class FinanceCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nameKey => text().withLength(min: 1, max: 48)();
  TextColumn get displayName => text().nullable()();
  TextColumn get kind => text().withLength(min: 1, max: 16)();
  IntColumn get colorArgb => integer()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
}

class FinanceAccounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 64)();
  IntColumn get balanceMinor => integer().withDefault(const Constant(0))();
  TextColumn get currencyCode => text().withLength(min: 3, max: 8)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
}

class MonthlyBudgets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get year => integer()();
  IntColumn get month => integer()();
  IntColumn get totalLimitMinor => integer()();
  DateTimeColumn get updatedAt => dateTime()();
}

class CategoryAllocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get year => integer()();
  IntColumn get month => integer()();
  IntColumn get categoryId =>
      integer().references(FinanceCategories, #id)();
  IntColumn get allocatedMinor => integer()();
}

class FinanceTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get amountMinor => integer()();
  TextColumn get kind => text().withLength(min: 1, max: 16)();
  IntColumn get categoryId =>
      integer().references(FinanceCategories, #id)();
  IntColumn get accountId => integer().references(FinanceAccounts, #id)();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class TodayPreferences extends Table {
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get showFinanceSummary =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get showBudgetStatus =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get showTodaySpend =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get showTodayEvents =>
      boolean().withDefault(const Constant(true))();
  TextColumn get widgetOrder => text().withDefault(
        const Constant('finance,budget,spend,events'),
      )();
  TextColumn get layoutJson => text().withDefault(const Constant(''))();
}

/// Habit definition (mhabit-style daily / weekly frequency).
class Habits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 120)();
  /// `daily` | `weekly` | `custom`
  TextColumn get frequency =>
      text().withLength(min: 1, max: 16).withDefault(const Constant('daily'))();
  /// Times per period (e.g. 3× per week).
  IntColumn get timesPerPeriod => integer().withDefault(const Constant(1))();
  /// Period length in days for custom (default 7).
  IntColumn get periodDays => integer().withDefault(const Constant(7))();
  IntColumn get colorArgb => integer()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

/// One check-in per habit per calendar day.
class HabitLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get habitId => integer().references(Habits, #id)();
  /// Date-only (local midnight).
  DateTimeColumn get day => dateTime()();
  /// `done` | `skip`
  TextColumn get status =>
      text().withLength(min: 1, max: 16).withDefault(const Constant('done'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {habitId, day},
      ];
}

/// Named daily routine template (FocusForce-style).
class Routines extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 120)();
  /// Minutes from midnight for start.
  IntColumn get startMinutes => integer().withDefault(const Constant(8 * 60))();
  /// Bitmask Mon=1 … Sun=64.
  IntColumn get weekdaysMask => integer().withDefault(const Constant(127))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

/// Ordered timed slots inside a routine.
class RoutineSlots extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get routineId => integer().references(Routines, #id)();
  TextColumn get title => text().withLength(min: 1, max: 120)();
  IntColumn get durationMinutes => integer().withDefault(const Constant(15))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

/// Per-day slot completion.
class RoutineSlotLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get slotId => integer().references(RoutineSlots, #id)();
  DateTimeColumn get day => dateTime()();
  BoolColumn get isDone => boolean().withDefault(const Constant(true))();
  DateTimeColumn get completedAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {slotId, day},
      ];
}

/// Daily calorie / macro goals (single active row).
class NutritionTargets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get caloriesKcal => integer().withDefault(const Constant(2000))();
  IntColumn get carbsG => integer().withDefault(const Constant(250))();
  IntColumn get fatG => integer().withDefault(const Constant(70))();
  IntColumn get proteinG => integer().withDefault(const Constant(150))();
  DateTimeColumn get updatedAt => dateTime()();
}

/// Logged food item for a meal on a calendar day (OpenNutriTracker-style diary).
class FoodEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  /// Date-only (local midnight).
  DateTimeColumn get day => dateTime()();
  /// `breakfast` | `lunch` | `dinner` | `snack`
  TextColumn get mealType => text().withLength(min: 1, max: 16)();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  IntColumn get caloriesKcal => integer().withDefault(const Constant(0))();
  IntColumn get carbsG => integer().withDefault(const Constant(0))();
  IntColumn get fatG => integer().withDefault(const Constant(0))();
  IntColumn get proteinG => integer().withDefault(const Constant(0))();
  IntColumn get grams => integer().withDefault(const Constant(100))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

/// Workout template / routine (GymMane-style).
class Workouts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 120)();
  TextColumn get notes => text().withDefault(const Constant(''))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

/// Exercise rows inside a workout template.
class WorkoutExercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workoutId => integer().references(Workouts, #id)();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  IntColumn get targetSets => integer().withDefault(const Constant(3))();
  IntColumn get targetReps => integer().withDefault(const Constant(10))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  TextColumn get notes => text().withDefault(const Constant(''))();
}

/// Logged training session.
class WorkoutSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workoutId => integer().nullable().references(Workouts, #id)();
  TextColumn get title => text().withLength(min: 1, max: 120)();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  TextColumn get notes => text().withDefault(const Constant(''))();
}

/// Sets logged during a session (reps × weight).
class SessionSets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(WorkoutSessions, #id)();
  TextColumn get exerciseName => text().withLength(min: 1, max: 120)();
  IntColumn get setIndex => integer().withDefault(const Constant(1))();
  IntColumn get reps => integer().withDefault(const Constant(0))();
  /// Weight in grams (minor units) to avoid floats — UI shows kg.
  IntColumn get weightGrams => integer().withDefault(const Constant(0))();
  BoolColumn get isDone => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
}
