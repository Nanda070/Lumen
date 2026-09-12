import 'dart:async';
import 'dart:convert';

import 'package:dashboard/dashboard.dart';

import '../../data/app_database.dart';

/// Widget type identifiers used as [DashboardItem.identifier].
abstract final class TodayWidgetIds {
  static const budgetRing = 'budget_ring';
  static const spent = 'spent';
  static const remaining = 'remaining';
  static const spendToday = 'spend_today';
  static const eventsCount = 'events_count';
  static const eventsList = 'events_list';
  static const categoryDonut = 'category_donut';
  static const cashflow = 'cashflow';
  static const accounts = 'accounts';

  static const all = <String>[
    budgetRing,
    spent,
    remaining,
    spendToday,
    eventsCount,
    eventsList,
    categoryDonut,
    cashflow,
    accounts,
  ];
}

/// Persists dashboard layouts in [TodayPreferences.layoutJson].
///
/// JSON: `{ "v": 3, "2": { id: itemMap }, "4": { ... } }`
class DashboardStorage extends DashboardItemStorageDelegate<DashboardItem> {
  DashboardStorage(this.database);

  final AppDatabase database;

  static const slotCounts = [2, 4];
  static const layoutVersion = 3;

  @override
  bool get cacheItems => true;

  @override
  bool get layoutsBySlotCount => true;

  @override
  FutureOr<List<DashboardItem>> getAllItems(int slotCount) {
    return Future(() async {
      final raw = await database.getDashboardLayoutJson();
      if (raw.trim().isEmpty) {
        return defaultLayout(slotCount);
      }
      try {
        final decoded = jsonDecode(raw);
        if (decoded is! Map) return defaultLayout(slotCount);
        final root = Map<String, dynamic>.from(decoded);
        final v = root['v'];
        if (v is! int || v < layoutVersion) {
          final fresh = defaultLayout(slotCount);
          await _persistSlot(
            slotCount,
            {for (final i in fresh) i.identifier: i},
            version: layoutVersion,
          );
          return fresh;
        }
        final slotMap = root['$slotCount'];
        if (slotMap is! Map || slotMap.isEmpty) {
          return defaultLayout(slotCount);
        }
        return slotMap.values
            .map(
              (value) => DashboardItem.fromMap(
                Map<String, dynamic>.from(value as Map),
              ),
            )
            .toList();
      } catch (_) {
        return defaultLayout(slotCount);
      }
    });
  }

  @override
  FutureOr<void> onItemsUpdated(
    List<DashboardItem> items,
    int slotCount,
  ) async {
    final current = Map<String, DashboardItem>.from(itemsFor(slotCount) ?? {});
    for (final item in items) {
      current[item.identifier] = item;
    }
    await _persistSlot(slotCount, current);
  }

  @override
  FutureOr<void> onItemsAdded(
    List<DashboardItem> items,
    int slotCount,
  ) async {
    for (final sc in slotCounts) {
      final current = Map<String, DashboardItem>.from(
        itemsFor(sc) ??
            {for (final i in defaultLayout(sc)) i.identifier: i},
      );
      for (final item in items) {
        current[item.identifier] = item;
      }
      await _persistSlot(sc, current);
    }
  }

  @override
  FutureOr<void> onItemsDeleted(
    List<DashboardItem> items,
    int slotCount,
  ) async {
    final ids = items.map((e) => e.identifier).toSet();
    for (final sc in slotCounts) {
      final current = Map<String, DashboardItem>.from(
        itemsFor(sc) ??
            {for (final i in defaultLayout(sc)) i.identifier: i},
      );
      current.removeWhere((k, _) => ids.contains(k));
      await _persistSlot(sc, current);
    }
  }

  Future<void> _persistSlot(
    int slotCount,
    Map<String, DashboardItem> items, {
    int version = layoutVersion,
  }) async {
    final raw = await database.getDashboardLayoutJson();
    Map<String, dynamic> root = {'v': version};
    if (raw.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map) {
          root = Map<String, dynamic>.from(decoded);
          root['v'] = version;
        }
      } catch (_) {}
    }
    root['$slotCount'] = items.map((k, v) => MapEntry(k, v.toMap()));
    await database.saveDashboardLayoutJson(jsonEncode(root));
  }

  /// Compact defaults — fewer tall tiles, less scroll depth.
  static List<DashboardItem> defaultLayout(int slotCount) {
    if (slotCount >= 4) {
      return [
        DashboardItem(
          identifier: TodayWidgetIds.budgetRing,
          width: 2,
          height: 2,
          startX: 0,
          startY: 0,
          minWidth: 1,
          minHeight: 1,
        ),
        DashboardItem(
          identifier: TodayWidgetIds.spent,
          width: 1,
          height: 1,
          startX: 2,
          startY: 0,
        ),
        DashboardItem(
          identifier: TodayWidgetIds.remaining,
          width: 1,
          height: 1,
          startX: 3,
          startY: 0,
        ),
        DashboardItem(
          identifier: TodayWidgetIds.spendToday,
          width: 1,
          height: 1,
          startX: 2,
          startY: 1,
        ),
        DashboardItem(
          identifier: TodayWidgetIds.eventsCount,
          width: 1,
          height: 1,
          startX: 3,
          startY: 1,
        ),
        DashboardItem(
          identifier: TodayWidgetIds.eventsList,
          width: 4,
          height: 2,
          startX: 0,
          startY: 2,
          minWidth: 2,
          minHeight: 2,
        ),
      ];
    }

    return [
      DashboardItem(
        identifier: TodayWidgetIds.budgetRing,
        width: 2,
        height: 2,
        startX: 0,
        startY: 0,
        minWidth: 1,
        minHeight: 1,
      ),
      DashboardItem(
        identifier: TodayWidgetIds.spent,
        width: 1,
        height: 1,
        startX: 0,
        startY: 2,
      ),
      DashboardItem(
        identifier: TodayWidgetIds.remaining,
        width: 1,
        height: 1,
        startX: 1,
        startY: 2,
      ),
      DashboardItem(
        identifier: TodayWidgetIds.spendToday,
        width: 1,
        height: 1,
        startX: 0,
        startY: 3,
      ),
      DashboardItem(
        identifier: TodayWidgetIds.eventsCount,
        width: 1,
        height: 1,
        startX: 1,
        startY: 3,
      ),
      DashboardItem(
        identifier: TodayWidgetIds.eventsList,
        width: 2,
        height: 2,
        startX: 0,
        startY: 4,
        minWidth: 1,
        minHeight: 2,
      ),
    ];
  }

  static DashboardItem newItem(String id, int slotCount) {
    final w = slotCount.clamp(2, 4);
    switch (id) {
      case TodayWidgetIds.budgetRing:
        return DashboardItem(
          identifier: id,
          width: 2,
          height: 2,
          minWidth: 1,
          minHeight: 1,
        );
      case TodayWidgetIds.categoryDonut:
      case TodayWidgetIds.cashflow:
        return DashboardItem(
          identifier: id,
          width: 2,
          height: 2,
          minWidth: 1,
          minHeight: 1,
        );
      case TodayWidgetIds.eventsList:
        return DashboardItem(
          identifier: id,
          width: w,
          height: 2,
          minWidth: 1,
          minHeight: 2,
        );
      case TodayWidgetIds.accounts:
        return DashboardItem(
          identifier: id,
          width: w,
          height: 1,
          minWidth: 1,
          minHeight: 1,
        );
      default:
        return DashboardItem(
          identifier: id,
          width: 1,
          height: 1,
          minWidth: 1,
          minHeight: 1,
        );
    }
  }
}
