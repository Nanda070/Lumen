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
