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

/// Local calendars (seeded Personal / Lumen; Google sync later).
class Calendars extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 64)();
  IntColumn get colorArgb => integer()();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

/// Local calendar events (no Google sync in this layer).
class Events extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  DateTimeColumn get startsAt => dateTime()();
  DateTimeColumn get endsAt => dateTime()();
  IntColumn get calendarId => integer().references(Calendars, #id)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

/// Money categories — seeded defaults + user-created.
class FinanceCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  /// Stable i18n key (e.g. food, salary) or `custom` for user-named.
  TextColumn get nameKey => text().withLength(min: 1, max: 48)();
  /// Custom display name; when set, UI prefers this over i18n of [nameKey].
  TextColumn get displayName => text().nullable()();
  /// `expense` | `income`
  TextColumn get kind => text().withLength(min: 1, max: 16)();
  IntColumn get colorArgb => integer()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
}

/// Cash / bank / wallet accounts in the profile currency.
class FinanceAccounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 64)();
  IntColumn get balanceMinor => integer().withDefault(const Constant(0))();
  TextColumn get currencyCode => text().withLength(min: 3, max: 8)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
}

/// Month-level spending limit (one row per year+month).
class MonthlyBudgets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get year => integer()();
  IntColumn get month => integer()();
  IntColumn get totalLimitMinor => integer()();
  DateTimeColumn get updatedAt => dateTime()();
}

/// Per-category allocation inside a month's budget.
class CategoryAllocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get year => integer()();
  IntColumn get month => integer()();
  IntColumn get categoryId =>
      integer().references(FinanceCategories, #id)();
  IntColumn get allocatedMinor => integer()();
}

/// Ledger transactions.
class FinanceTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  /// Always positive; sign comes from [kind].
  IntColumn get amountMinor => integer()();
  /// `expense` | `income`
  TextColumn get kind => text().withLength(min: 1, max: 16)();
  IntColumn get categoryId =>
      integer().references(FinanceCategories, #id)();
  IntColumn get accountId => integer().references(FinanceAccounts, #id)();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

/// Which Today hub widgets are visible / ordered (legacy toggles kept for migration).
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
  /// Comma-separated ids: finance,budget,spend,events (legacy)
  TextColumn get widgetOrder => text().withDefault(
        const Constant('finance,budget,spend,events'),
      )();
  /// JSON map of slotCount → {identifier → DashboardItem.toMap()} for drag/resize grid.
  TextColumn get layoutJson => text().withDefault(const Constant(''))();
}
