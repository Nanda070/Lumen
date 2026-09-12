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

/// Default money categories seeded with the profile.
class FinanceCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  /// Stable i18n key (e.g. food, salary) — localize in UI later.
  TextColumn get nameKey => text().withLength(min: 1, max: 48)();
  /// `expense` | `income`
  TextColumn get kind => text().withLength(min: 1, max: 16)();
  IntColumn get colorArgb => integer()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}
