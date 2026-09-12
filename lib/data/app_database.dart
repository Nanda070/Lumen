import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Profiles, Calendars, FinanceCategories])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? _openExecutor());

  @override
  int get schemaVersion => 1;

  Future<Profile?> getProfile() {
    return (select(profiles)..limit(1)).getSingleOrNull();
  }

  Stream<Profile?> watchProfile() {
    return (select(profiles)..limit(1)).watchSingleOrNull();
  }

  /// Creates the local profile and seeds starter calendars / finance categories.
  Future<Profile> completeOnboarding({
    required String displayName,
    required String localeCode,
    required String countryCode,
    required String currencyCode,
  }) {
    return transaction(() async {
      final existing = await getProfile();
      if (existing != null) return existing;

      final profileId = await into(profiles).insert(
        ProfilesCompanion.insert(
          displayName: displayName.trim(),
          localeCode: localeCode,
          countryCode: countryCode,
          currencyCode: currencyCode,
          createdAt: DateTime.now().toUtc(),
        ),
      );

      await _seedStarterData();

      return (select(profiles)..where((t) => t.id.equals(profileId)))
          .getSingle();
    });
  }

  Future<void> updateLocale(String localeCode) async {
    final profile = await getProfile();
    if (profile == null) return;
    await (update(profiles)..where((t) => t.id.equals(profile.id))).write(
      ProfilesCompanion(localeCode: Value(localeCode)),
    );
  }

  Future<void> updateCurrency(String currencyCode) async {
    final profile = await getProfile();
    if (profile == null) return;
    await (update(profiles)..where((t) => t.id.equals(profile.id))).write(
      ProfilesCompanion(currencyCode: Value(currencyCode)),
    );
  }

  Future<void> _seedStarterData() async {
    final calendarCount = await calendars.count().getSingle();
    if (calendarCount == 0) {
      await batch((b) {
        b.insertAll(calendars, [
          CalendarsCompanion.insert(
            name: 'Personal',
            colorArgb: 0xFF8B6CFF,
            isSystem: const Value(true),
            sortOrder: const Value(0),
          ),
          CalendarsCompanion.insert(
            name: 'Lumen',
            colorArgb: 0xFF5B7CFF,
            isSystem: const Value(true),
            sortOrder: const Value(1),
          ),
        ]);
      });
    }

    final categoryCount = await financeCategories.count().getSingle();
    if (categoryCount == 0) {
      await batch((b) {
        b.insertAll(financeCategories, [
          FinanceCategoriesCompanion.insert(
            nameKey: 'food',
            kind: 'expense',
            colorArgb: 0xFFFF6B3D,
            sortOrder: const Value(0),
          ),
          FinanceCategoriesCompanion.insert(
            nameKey: 'transport',
            kind: 'expense',
            colorArgb: 0xFF5B7CFF,
            sortOrder: const Value(1),
          ),
          FinanceCategoriesCompanion.insert(
            nameKey: 'home',
            kind: 'expense',
            colorArgb: 0xFF8B6CFF,
            sortOrder: const Value(2),
          ),
          FinanceCategoriesCompanion.insert(
            nameKey: 'shopping',
            kind: 'expense',
            colorArgb: 0xFFFFB347,
            sortOrder: const Value(3),
          ),
          FinanceCategoriesCompanion.insert(
            nameKey: 'health',
            kind: 'expense',
            colorArgb: 0xFF5ECF9A,
            sortOrder: const Value(4),
          ),
          FinanceCategoriesCompanion.insert(
            nameKey: 'other_expense',
            kind: 'expense',
            colorArgb: 0xFF8B919C,
            sortOrder: const Value(5),
          ),
          FinanceCategoriesCompanion.insert(
            nameKey: 'salary',
            kind: 'income',
            colorArgb: 0xFF5ECF9A,
            sortOrder: const Value(0),
          ),
          FinanceCategoriesCompanion.insert(
            nameKey: 'other_income',
            kind: 'income',
            colorArgb: 0xFF8B919C,
            sortOrder: const Value(1),
          ),
        ]);
      });
    }
  }
}

QueryExecutor _openExecutor() {
  return driftDatabase(
    name: 'lumen',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
      onResult: (result) {
        if (result.missingFeatures.isNotEmpty) {
          debugPrint(
            'Drift web using ${result.chosenImplementation}; '
            'missing: ${result.missingFeatures}',
          );
        }
      },
    ),
  );
}
