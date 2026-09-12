import 'package:flutter/material.dart';

import '../data/app_database.dart';
import '../design_system/design_system.dart';
import '../features/calendar/calendar_page.dart';
import '../features/finance/finance_page.dart';
import '../features/more/more_page.dart';
import '../features/tasks/tasks_page.dart';
import '../features/today/today_page.dart';
import '../l10n/app_localizations.dart';

/// Adaptive shell: floating glass tabs on phone, left rail on wide layouts.
class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.database,
    required this.locale,
    required this.onLocaleChanged,
    required this.currencyCode,
    required this.displayName,
  });

  final AppDatabase database;
  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;
  final String currencyCode;
  final String displayName;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final items = lumenNavItems(
      today: l10n.navToday,
      calendar: l10n.navCalendar,
      tasks: l10n.navTasks,
      finance: l10n.navFinance,
      more: l10n.navMore,
    );

    final pages = [
      TodayPage(
        database: widget.database,
        currencyCode: widget.currencyCode,
      ),
      CalendarPage(database: widget.database),
      const TasksPage(),
      FinancePage(
        database: widget.database,
        currencyCode: widget.currencyCode,
      ),
      MorePage(
        database: widget.database,
        locale: widget.locale,
        onLocaleChanged: widget.onLocaleChanged,
        displayName: widget.displayName,
        currencyCode: widget.currencyCode,
      ),
    ];

    final content = AnimatedSwitcher(
      duration: LumenMotion.normal,
      switchInCurve: LumenMotion.spring,
      switchOutCurve: Curves.easeIn,
      child: KeyedSubtree(
        key: ValueKey(_index),
        child: pages[_index],
      ),
    );

    if (wide) {
      return AtmosphereBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          // Rail + pages clear status bar / notch / home indicator.
          body: SafeArea(
            child: Row(
              children: [
                NavigationRail(
                  selectedIndex: _index,
                  onDestinationSelected: (i) => setState(() => _index = i),
                  labelType: NavigationRailLabelType.all,
                  backgroundColor:
                      LumenColors.bgElevated.withValues(alpha: 0.72),
                  destinations: [
                    for (final item in items)
                      NavigationRailDestination(
                        icon: Icon(item.icon),
                        selectedIcon: Icon(item.selectedIcon),
                        label: Text(item.label),
                      ),
                  ],
                ),
                VerticalDivider(
                  width: 1,
                  color: LumenColors.divider,
                ),
                Expanded(child: content),
              ],
            ),
          ),
        ),
      );
    }

    return AtmosphereBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        // Top safe area for Dynamic Island / status bar; bottom left for
        // floating tab bar (it already pads the home indicator).
        body: SafeArea(
          bottom: false,
          child: content,
        ),
        bottomNavigationBar: LumenTabBar(
          items: items,
          currentIndex: _index,
          onSelect: (i) => setState(() => _index = i),
        ),
      ),
    );
  }
}
