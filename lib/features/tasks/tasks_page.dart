import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../shell/module_scaffold.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ComingSoonRoom(
      title: l10n.navTasks,
      subtitle: l10n.tasksSubtitle,
    );
  }
}
