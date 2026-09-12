import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';

import 'tables.dart';

part 'app_database.g.dart';

/// Event joined with its calendar color/name for UI.
typedef EventWithCalendar = ({Event event, Calendar calendar});

/// Transaction joined with category + account for ledger UI.
typedef TxWithMeta = ({
  FinanceTransaction tx,
  FinanceCategory category,
  FinanceAccount account,
});

@DriftDatabase(
  tables: [
    Profiles,
    Calendars,
    FinanceCategories,
    Events,
    FinanceAccounts,
    MonthlyBudgets,
    CategoryAllocations,
    FinanceTransactions,
    TodayPreferences,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? _openExecutor());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(events);
          }
          if (from < 3) {
            await m.addColumn(financeCategories, financeCategories.displayName);
            await m.addColumn(financeCategories, financeCategories.isSystem);
            await m.addColumn(financeCategories, financeCategories.isArchived);
            await m.createTable(financeAccounts);
            await m.createTable(monthlyBudgets);
            await m.createTable(categoryAllocations);
            await m.createTable(financeTransactions);
            await m.createTable(todayPreferences);
            await customStatement(
              'UPDATE finance_categories SET is_system = 1 '
              "WHERE name_key IN ('food','transport','home','shopping',"
              "'health','other_expense','salary','other_income')",
            );
          }
        },
        beforeOpen: (details) async {
          await _ensureFinanceBootstrap();
        },
      );

  // ── Profile ──────────────────────────────────────────────────────────────

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

      await _seedStarterData(currencyCode: currencyCode);
      await _ensureFinanceBootstrap();

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
    // Keep non-archived accounts on profile currency for v1 simplicity.
    await (update(financeAccounts)
          ..where((t) => t.isArchived.equals(false)))
        .write(FinanceAccountsCompanion(currencyCode: Value(currencyCode)));
  }

  // ── Calendars / events ───────────────────────────────────────────────────

  Future<List<Calendar>> getCalendars() {
    return (select(calendars)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  Stream<List<Calendar>> watchCalendars() {
    return (select(calendars)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch();
  }

  Stream<List<EventWithCalendar>> watchEventsInRange(
    DateTime rangeStart,
    DateTime rangeEnd,
  ) {
    final query = select(events).join([
      innerJoin(calendars, calendars.id.equalsExp(events.calendarId)),
    ])
      ..where(
        events.startsAt.isBiggerOrEqualValue(rangeStart) &
            events.startsAt.isSmallerThanValue(rangeEnd),
      )
      ..orderBy([OrderingTerm.asc(events.startsAt)]);

    return query.watch().map((rows) {
      return rows
          .map(
            (row) => (
              event: row.readTable(events),
              calendar: row.readTable(calendars),
            ),
          )
          .toList();
    });
  }

  Stream<List<EventWithCalendar>> watchEventsForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return watchEventsInRange(start, end);
  }

  Future<int> insertEvent({
    required String title,
    required DateTime startsAt,
    required DateTime endsAt,
    required int calendarId,
  }) {
    final now = DateTime.now().toUtc();
    return into(events).insert(
      EventsCompanion.insert(
        title: title.trim(),
        startsAt: startsAt,
        endsAt: endsAt,
        calendarId: calendarId,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<bool> updateEvent({
    required int id,
    required String title,
    required DateTime startsAt,
    required DateTime endsAt,
    required int calendarId,
  }) async {
    final rows = await (update(events)..where((t) => t.id.equals(id))).write(
      EventsCompanion(
        title: Value(title.trim()),
        startsAt: Value(startsAt),
        endsAt: Value(endsAt),
        calendarId: Value(calendarId),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
    return rows > 0;
  }

  Future<bool> deleteEvent(int id) async {
    final rows = await (delete(events)..where((t) => t.id.equals(id))).go();
    return rows > 0;
  }

  // ── Finance categories ───────────────────────────────────────────────────

  Stream<List<FinanceCategory>> watchCategories({
    bool includeArchived = false,
    String? kind,
  }) {
    final query = select(financeCategories)
      ..orderBy([
        (t) => OrderingTerm.asc(t.kind),
        (t) => OrderingTerm.asc(t.sortOrder),
        (t) => OrderingTerm.asc(t.id),
      ]);
    if (!includeArchived) {
      query.where((t) => t.isArchived.equals(false));
    }
    if (kind != null) {
      query.where((t) => t.kind.equals(kind));
    }
    return query.watch();
  }

  Future<List<FinanceCategory>> getCategories({
    bool includeArchived = false,
    String? kind,
  }) {
    final query = select(financeCategories)
      ..orderBy([
        (t) => OrderingTerm.asc(t.kind),
        (t) => OrderingTerm.asc(t.sortOrder),
        (t) => OrderingTerm.asc(t.id),
      ]);
    if (!includeArchived) {
      query.where((t) => t.isArchived.equals(false));
    }
    if (kind != null) {
      query.where((t) => t.kind.equals(kind));
    }
    return query.get();
  }

  Future<int> insertCategory({
    required String displayName,
    required String kind,
    required int colorArgb,
  }) async {
    final maxOrder = await (selectOnly(financeCategories)
          ..addColumns([financeCategories.sortOrder.max()])
          ..where(financeCategories.kind.equals(kind)))
        .map((row) => row.read(financeCategories.sortOrder.max()) ?? -1)
        .getSingle();
    return into(financeCategories).insert(
      FinanceCategoriesCompanion.insert(
        nameKey: 'custom',
        displayName: Value(displayName.trim()),
        kind: kind,
        colorArgb: colorArgb,
        sortOrder: Value(maxOrder + 1),
        isSystem: const Value(false),
      ),
    );
  }

  Future<bool> updateCategory({
    required int id,
    required String displayName,
    required int colorArgb,
    required String kind,
  }) async {
    final rows =
        await (update(financeCategories)..where((t) => t.id.equals(id))).write(
      FinanceCategoriesCompanion(
        displayName: Value(displayName.trim()),
        colorArgb: Value(colorArgb),
        kind: Value(kind),
      ),
    );
    return rows > 0;
  }

  Future<bool> archiveCategory(int id) async {
    final rows =
        await (update(financeCategories)..where((t) => t.id.equals(id))).write(
      const FinanceCategoriesCompanion(isArchived: Value(true)),
    );
    return rows > 0;
  }

  Future<bool> deleteCategory(int id) async {
    final cat = await (select(financeCategories)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (cat == null) return false;
    if (cat.isSystem) {
      return archiveCategory(id);
    }
    final txCount = await (selectOnly(financeTransactions)
          ..addColumns([financeTransactions.id.count()])
          ..where(financeTransactions.categoryId.equals(id)))
        .map((r) => r.read(financeTransactions.id.count()) ?? 0)
        .getSingle();
    if (txCount > 0) {
      return archiveCategory(id);
    }
    await (delete(categoryAllocations)
          ..where((t) => t.categoryId.equals(id)))
        .go();
    final rows =
        await (delete(financeCategories)..where((t) => t.id.equals(id))).go();
    return rows > 0;
  }

  // ── Accounts ─────────────────────────────────────────────────────────────

  Stream<List<FinanceAccount>> watchAccounts({bool includeArchived = false}) {
    final query = select(financeAccounts)
      ..orderBy([
        (t) => OrderingTerm.asc(t.sortOrder),
        (t) => OrderingTerm.asc(t.id),
      ]);
    if (!includeArchived) {
      query.where((t) => t.isArchived.equals(false));
    }
    return query.watch();
  }

  Future<List<FinanceAccount>> getAccounts({bool includeArchived = false}) {
    final query = select(financeAccounts)
      ..orderBy([
        (t) => OrderingTerm.asc(t.sortOrder),
        (t) => OrderingTerm.asc(t.id),
      ]);
    if (!includeArchived) {
      query.where((t) => t.isArchived.equals(false));
    }
    return query.get();
  }

  Future<int> insertAccount({
    required String name,
    required String currencyCode,
    int balanceMinor = 0,
  }) async {
    final maxOrder = await (selectOnly(financeAccounts)
          ..addColumns([financeAccounts.sortOrder.max()]))
        .map((row) => row.read(financeAccounts.sortOrder.max()) ?? -1)
        .getSingle();
    return into(financeAccounts).insert(
      FinanceAccountsCompanion.insert(
        name: name.trim(),
        balanceMinor: Value(balanceMinor),
        currencyCode: currencyCode,
        sortOrder: Value(maxOrder + 1),
        createdAt: DateTime.now().toUtc(),
      ),
    );
  }

  Future<bool> updateAccount({
    required int id,
    required String name,
    required int balanceMinor,
  }) async {
    final rows =
        await (update(financeAccounts)..where((t) => t.id.equals(id))).write(
      FinanceAccountsCompanion(
        name: Value(name.trim()),
        balanceMinor: Value(balanceMinor),
      ),
    );
    return rows > 0;
  }

  Future<bool> archiveAccount(int id) async {
    final active = await getAccounts();
    if (active.length <= 1 && active.any((a) => a.id == id)) {
      return false;
    }
    final rows =
        await (update(financeAccounts)..where((t) => t.id.equals(id))).write(
      const FinanceAccountsCompanion(isArchived: Value(true)),
    );
    return rows > 0;
  }

  // ── Budget ───────────────────────────────────────────────────────────────

  Stream<MonthlyBudget?> watchMonthlyBudget(int year, int month) {
    return (select(monthlyBudgets)
          ..where((t) => t.year.equals(year) & t.month.equals(month))
          ..limit(1))
        .watchSingleOrNull();
  }

  Future<MonthlyBudget?> getMonthlyBudget(int year, int month) {
    return (select(monthlyBudgets)
          ..where((t) => t.year.equals(year) & t.month.equals(month))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> upsertMonthlyBudget({
    required int year,
    required int month,
    required int totalLimitMinor,
  }) async {
    final existing = await getMonthlyBudget(year, month);
    final now = DateTime.now().toUtc();
    if (existing == null) {
      await into(monthlyBudgets).insert(
        MonthlyBudgetsCompanion.insert(
          year: year,
          month: month,
          totalLimitMinor: totalLimitMinor,
          updatedAt: now,
        ),
      );
    } else {
      await (update(monthlyBudgets)..where((t) => t.id.equals(existing.id)))
          .write(
        MonthlyBudgetsCompanion(
          totalLimitMinor: Value(totalLimitMinor),
          updatedAt: Value(now),
        ),
      );
    }
  }

  Stream<List<CategoryAllocation>> watchAllocations(int year, int month) {
    return (select(categoryAllocations)
          ..where((t) => t.year.equals(year) & t.month.equals(month)))
        .watch();
  }

  Future<List<CategoryAllocation>> getAllocations(int year, int month) {
    return (select(categoryAllocations)
          ..where((t) => t.year.equals(year) & t.month.equals(month)))
        .get();
  }

  Future<void> upsertCategoryAllocation({
    required int year,
    required int month,
    required int categoryId,
    required int allocatedMinor,
  }) async {
    final existing = await (select(categoryAllocations)
          ..where(
            (t) =>
                t.year.equals(year) &
                t.month.equals(month) &
                t.categoryId.equals(categoryId),
          )
          ..limit(1))
        .getSingleOrNull();
    if (allocatedMinor <= 0) {
      if (existing != null) {
        await (delete(categoryAllocations)
              ..where((t) => t.id.equals(existing.id)))
            .go();
      }
      return;
    }
    if (existing == null) {
      await into(categoryAllocations).insert(
        CategoryAllocationsCompanion.insert(
          year: year,
          month: month,
          categoryId: categoryId,
          allocatedMinor: allocatedMinor,
        ),
      );
    } else {
      await (update(categoryAllocations)
            ..where((t) => t.id.equals(existing.id)))
          .write(
        CategoryAllocationsCompanion(allocatedMinor: Value(allocatedMinor)),
      );
    }
  }

  // ── Transactions ─────────────────────────────────────────────────────────

  Stream<List<TxWithMeta>> watchTransactionsInRange(
    DateTime rangeStart,
    DateTime rangeEnd, {
    String? kind,
    int? categoryId,
  }) {
    final query = select(financeTransactions).join([
      innerJoin(
        financeCategories,
        financeCategories.id.equalsExp(financeTransactions.categoryId),
      ),
      innerJoin(
        financeAccounts,
        financeAccounts.id.equalsExp(financeTransactions.accountId),
      ),
    ])
      ..where(
        financeTransactions.occurredAt.isBiggerOrEqualValue(rangeStart) &
            financeTransactions.occurredAt.isSmallerThanValue(rangeEnd),
      )
      ..orderBy([OrderingTerm.desc(financeTransactions.occurredAt)]);

    if (kind != null) {
      query.where(financeTransactions.kind.equals(kind));
    }
    if (categoryId != null) {
      query.where(financeTransactions.categoryId.equals(categoryId));
    }

    return query.watch().map((rows) {
      return rows
          .map(
            (row) => (
              tx: row.readTable(financeTransactions),
              category: row.readTable(financeCategories),
              account: row.readTable(financeAccounts),
            ),
          )
          .toList();
    });
  }

  Stream<List<TxWithMeta>> watchMonthTransactions(
    int year,
    int month, {
    String? kind,
    int? categoryId,
  }) {
    final start = DateTime(year, month);
    final end = DateTime(year, month + 1);
    return watchTransactionsInRange(
      start,
      end,
      kind: kind,
      categoryId: categoryId,
    );
  }

  Future<int> insertTransaction({
    required int amountMinor,
    required String kind,
    required int categoryId,
    required int accountId,
    required DateTime occurredAt,
    String note = '',
  }) {
    return transaction(() async {
      final now = DateTime.now().toUtc();
      final id = await into(financeTransactions).insert(
        FinanceTransactionsCompanion.insert(
          amountMinor: amountMinor,
          kind: kind,
          categoryId: categoryId,
          accountId: accountId,
          occurredAt: occurredAt,
          note: Value(note.trim()),
          createdAt: now,
          updatedAt: now,
        ),
      );
      await _applyBalanceDelta(accountId, _signedAmount(kind, amountMinor));
      return id;
    });
  }

  Future<bool> updateTransaction({
    required int id,
    required int amountMinor,
    required String kind,
    required int categoryId,
    required int accountId,
    required DateTime occurredAt,
    String note = '',
  }) {
    return transaction(() async {
      final existing = await (select(financeTransactions)
            ..where((t) => t.id.equals(id)))
          .getSingleOrNull();
      if (existing == null) return false;

      await _applyBalanceDelta(
        existing.accountId,
        -_signedAmount(existing.kind, existing.amountMinor),
      );

      await (update(financeTransactions)..where((t) => t.id.equals(id))).write(
        FinanceTransactionsCompanion(
          amountMinor: Value(amountMinor),
          kind: Value(kind),
          categoryId: Value(categoryId),
          accountId: Value(accountId),
          occurredAt: Value(occurredAt),
          note: Value(note.trim()),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );

      await _applyBalanceDelta(accountId, _signedAmount(kind, amountMinor));
      return true;
    });
  }

  Future<bool> deleteTransaction(int id) {
    return transaction(() async {
      final existing = await (select(financeTransactions)
            ..where((t) => t.id.equals(id)))
          .getSingleOrNull();
      if (existing == null) return false;
      await _applyBalanceDelta(
        existing.accountId,
        -_signedAmount(existing.kind, existing.amountMinor),
      );
      final rows =
          await (delete(financeTransactions)..where((t) => t.id.equals(id)))
              .go();
      return rows > 0;
    });
  }

  int _signedAmount(String kind, int amountMinor) {
    return kind == 'income' ? amountMinor : -amountMinor;
  }

  Future<void> _applyBalanceDelta(int accountId, int delta) async {
    final account = await (select(financeAccounts)
          ..where((t) => t.id.equals(accountId)))
        .getSingleOrNull();
    if (account == null) return;
    await (update(financeAccounts)..where((t) => t.id.equals(accountId)))
        .write(
      FinanceAccountsCompanion(
        balanceMinor: Value(account.balanceMinor + delta),
      ),
    );
  }

  // ── Month aggregates (streams for reactive UI) ───────────────────────────

  Stream<MonthFinanceSummary> watchMonthSummary(int year, int month) {
    final start = DateTime(year, month);
    final end = DateTime(year, month + 1);
    return watchTransactionsInRange(start, end).asyncMap((txs) async {
      final budget = await getMonthlyBudget(year, month);
      final allocations = await getAllocations(year, month);
      var spent = 0;
      var income = 0;
      final byCategory = <int, int>{};
      final byDayExpense = <int, int>{};

      for (final item in txs) {
        final day = item.tx.occurredAt.day;
        if (item.tx.kind == 'expense') {
          spent += item.tx.amountMinor;
          byCategory[item.tx.categoryId] =
              (byCategory[item.tx.categoryId] ?? 0) + item.tx.amountMinor;
          byDayExpense[day] = (byDayExpense[day] ?? 0) + item.tx.amountMinor;
        } else {
          income += item.tx.amountMinor;
        }
      }

      final limit = budget?.totalLimitMinor ?? 0;
      final remaining = limit > 0 ? limit - spent : null;
      final allocMap = {
        for (final a in allocations) a.categoryId: a.allocatedMinor,
      };

      return MonthFinanceSummary(
        year: year,
        month: month,
        spentMinor: spent,
        incomeMinor: income,
        budgetLimitMinor: limit,
        remainingMinor: remaining,
        spentByCategory: byCategory,
        spentByDay: byDayExpense,
        allocationByCategory: allocMap,
        transactionCount: txs.length,
      );
    });
  }

  Stream<int> watchDaySpend(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return watchTransactionsInRange(start, end, kind: 'expense').map((txs) {
      var total = 0;
      for (final t in txs) {
        total += t.tx.amountMinor;
      }
      return total;
    });
  }

  // ── Today preferences ────────────────────────────────────────────────────

  Stream<TodayPreference?> watchTodayPreferences() {
    return (select(todayPreferences)..limit(1)).watchSingleOrNull();
  }

  Future<TodayPreference> getOrCreateTodayPreferences() async {
    final existing =
        await (select(todayPreferences)..limit(1)).getSingleOrNull();
    if (existing != null) return existing;
    final id = await into(todayPreferences).insert(
      TodayPreferencesCompanion.insert(),
    );
    return (select(todayPreferences)..where((t) => t.id.equals(id)))
        .getSingle();
  }

  Future<void> updateTodayPreferences({
    bool? showFinanceSummary,
    bool? showBudgetStatus,
    bool? showTodaySpend,
    bool? showTodayEvents,
    String? widgetOrder,
  }) async {
    final prefs = await getOrCreateTodayPreferences();
    await (update(todayPreferences)..where((t) => t.id.equals(prefs.id)))
        .write(
      TodayPreferencesCompanion(
        showFinanceSummary: showFinanceSummary == null
            ? const Value.absent()
            : Value(showFinanceSummary),
        showBudgetStatus: showBudgetStatus == null
            ? const Value.absent()
            : Value(showBudgetStatus),
        showTodaySpend:
            showTodaySpend == null ? const Value.absent() : Value(showTodaySpend),
        showTodayEvents: showTodayEvents == null
            ? const Value.absent()
            : Value(showTodayEvents),
        widgetOrder:
            widgetOrder == null ? const Value.absent() : Value(widgetOrder),
      ),
    );
  }

  // ── Seed / bootstrap ─────────────────────────────────────────────────────

  Future<void> _ensureFinanceBootstrap() async {
    final profile = await getProfile();
    if (profile == null) return;

    final categoryCount = await financeCategories.count().getSingle();
    if (categoryCount == 0) {
      await _seedCategories();
    } else {
      await customStatement(
        'UPDATE finance_categories SET is_system = 1 '
        "WHERE name_key IN ('food','transport','home','shopping',"
        "'health','other_expense','salary','other_income') "
        'AND is_system = 0',
      );
    }

    final accountCount = await financeAccounts.count().getSingle();
    if (accountCount == 0) {
      await into(financeAccounts).insert(
        FinanceAccountsCompanion.insert(
          name: 'Cash',
          currencyCode: profile.currencyCode,
          sortOrder: const Value(0),
          createdAt: DateTime.now().toUtc(),
        ),
      );
    }

    final prefsCount = await todayPreferences.count().getSingle();
    if (prefsCount == 0) {
      await into(todayPreferences).insert(TodayPreferencesCompanion.insert());
    }
  }

  Future<void> _seedStarterData({required String currencyCode}) async {
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

    await _seedCategories();

    final accountCount = await financeAccounts.count().getSingle();
    if (accountCount == 0) {
      await into(financeAccounts).insert(
        FinanceAccountsCompanion.insert(
          name: 'Cash',
          currencyCode: currencyCode,
          sortOrder: const Value(0),
          createdAt: DateTime.now().toUtc(),
        ),
      );
    }

    final prefsCount = await todayPreferences.count().getSingle();
    if (prefsCount == 0) {
      await into(todayPreferences).insert(TodayPreferencesCompanion.insert());
    }
  }

  Future<void> _seedCategories() async {
    final categoryCount = await financeCategories.count().getSingle();
    if (categoryCount > 0) return;
    await batch((b) {
      b.insertAll(financeCategories, [
        FinanceCategoriesCompanion.insert(
          nameKey: 'food',
          kind: 'expense',
          colorArgb: 0xFFFF6B3D,
          sortOrder: const Value(0),
          isSystem: const Value(true),
        ),
        FinanceCategoriesCompanion.insert(
          nameKey: 'transport',
          kind: 'expense',
          colorArgb: 0xFF5B7CFF,
          sortOrder: const Value(1),
          isSystem: const Value(true),
        ),
        FinanceCategoriesCompanion.insert(
          nameKey: 'home',
          kind: 'expense',
          colorArgb: 0xFF8B6CFF,
          sortOrder: const Value(2),
          isSystem: const Value(true),
        ),
        FinanceCategoriesCompanion.insert(
          nameKey: 'shopping',
          kind: 'expense',
          colorArgb: 0xFFFFB347,
          sortOrder: const Value(3),
          isSystem: const Value(true),
        ),
        FinanceCategoriesCompanion.insert(
          nameKey: 'health',
          kind: 'expense',
          colorArgb: 0xFF5ECF9A,
          sortOrder: const Value(4),
          isSystem: const Value(true),
        ),
        FinanceCategoriesCompanion.insert(
          nameKey: 'other_expense',
          kind: 'expense',
          colorArgb: 0xFF8B919C,
          sortOrder: const Value(5),
          isSystem: const Value(true),
        ),
        FinanceCategoriesCompanion.insert(
          nameKey: 'salary',
          kind: 'income',
          colorArgb: 0xFF5ECF9A,
          sortOrder: const Value(0),
          isSystem: const Value(true),
        ),
        FinanceCategoriesCompanion.insert(
          nameKey: 'other_income',
          kind: 'income',
          colorArgb: 0xFF8B919C,
          sortOrder: const Value(1),
          isSystem: const Value(true),
        ),
      ]);
    });
  }
}

/// Aggregated month finance snapshot for overview / Today widgets.
class MonthFinanceSummary {
  const MonthFinanceSummary({
    required this.year,
    required this.month,
    required this.spentMinor,
    required this.incomeMinor,
    required this.budgetLimitMinor,
    required this.remainingMinor,
    required this.spentByCategory,
    required this.spentByDay,
    required this.allocationByCategory,
    required this.transactionCount,
  });

  final int year;
  final int month;
  final int spentMinor;
  final int incomeMinor;
  final int budgetLimitMinor;
  final int? remainingMinor;
  final Map<int, int> spentByCategory;
  final Map<int, int> spentByDay;
  final Map<int, int> allocationByCategory;
  final int transactionCount;

  /// ok | warning | overspend | none
  String get budgetStatus {
    if (budgetLimitMinor <= 0) return 'none';
    final rem = remainingMinor ?? 0;
    if (rem < 0) return 'overspend';
    if (rem <= budgetLimitMinor * 0.15) return 'warning';
    return 'ok';
  }

  double get spentRatio {
    if (budgetLimitMinor <= 0) return 0;
    return (spentMinor / budgetLimitMinor).clamp(0.0, 2.0);
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
