import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../shell/module_scaffold.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ComingSoonRoom(
      title: l10n.navCalendar,
      subtitle: l10n.calendarSubtitle,
    );
  }
}
