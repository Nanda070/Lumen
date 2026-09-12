import 'package:dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/app_database.dart';
import '../../design_system/design_system.dart';
import '../../l10n/app_localizations.dart';
import 'dashboard_storage.dart';
import 'today_widget_tiles.dart';
import 'today_widgets_sheet.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({
    super.key,
    required this.database,
    this.currencyCode = 'USD',
  });

  final AppDatabase database;
  final String currencyCode;

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  late final DashboardStorage _storage;
  late DashboardItemController<DashboardItem> _controller;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _storage = DashboardStorage(widget.database);
    _controller = DashboardItemController<DashboardItem>.withDelegate(
      itemStorageDelegate: _storage,
    );
  }

  int _slotCount(BuildContext context) {
    return MediaQuery.sizeOf(context).width > 700 ? 4 : 2;
  }

  void _toggleEdit() {
    setState(() {
      _editing = !_editing;
      try {
        _controller.isEditing = _editing;
      } catch (_) {
        // Dashboard not attached yet.
      }
    });
  }

  Future<void> _openAddSheet() async {
    Set<String> present = {};
    try {
      present = _controller.items.toSet();
    } catch (_) {}
    await showTodayWidgetsSheet(
      context: context,
      database: widget.database,
      presentIds: present,
      onAdd: (id) {
        final item = DashboardStorage.newItem(id, _slotCount(context));
        try {
          _controller.add(item, mountToTop: false);
        } catch (_) {
          // Not attached yet.
        }
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final slotCount = _slotCount(context);

    return Padding(
      padding: const EdgeInsets.only(top: LumenSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: LumenSpacing.pagePadding,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.todayGreeting,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.headlineLarge,
                      ),
                      const SizedBox(height: LumenSpacing.xs),
                      Text(
                        l10n.todaySubtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.bodyMedium?.copyWith(
                          color: LumenColors.textMuted,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: _toggleEdit,
                  child: Text(
                    _editing ? l10n.todayDoneEditing : l10n.todayEditLayout,
                  ),
                ),
                IconButton(
                  tooltip: l10n.todayAddWidget,
                  onPressed: _openAddSheet,
                  icon: const Icon(
                    PhosphorIconsRegular.plusCircle,
                    color: LumenColors.accentMint,
                  ),
                ),
              ],
            ),
          ),
          if (_editing)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                LumenSpacing.pagePadding,
                LumenSpacing.xs,
                LumenSpacing.pagePadding,
                0,
              ),
              child: Text(
                l10n.todayResizeHint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.bodySmall?.copyWith(color: LumenColors.textMuted),
              ),
            ),
          const SizedBox(height: LumenSpacing.sm),
          Expanded(
            child: Dashboard<DashboardItem>(
              key: ValueKey('dash-$slotCount'),
              dashboardItemController: _controller,
              slotCount: slotCount,
              slotHeight: 108,
              padding: const EdgeInsets.symmetric(
                horizontal: LumenSpacing.pagePadding,
                vertical: LumenSpacing.xs,
              ),
              horizontalSpace: 8,
              verticalSpace: 8,
              shrinkToPlace: true,
              slideToTop: false,
              absorbPointer: false,
              animateEverytime: true,
              physics: const BouncingScrollPhysics(),
              itemStyle: ItemStyle(
                color: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(LumenRadii.md),
                ),
              ),
              editModeSettings: EditModeSettings(
                longPressEnabled: true,
                resizeCursorSide: 14,
                paintBackgroundLines: true,
                autoScroll: true,
                draggableOutside: false,
                backgroundStyle: EditModeBackgroundStyle(
                  lineColor: LumenColors.accentViolet.withValues(alpha: 0.35),
                  lineWidth: 1,
                  dualLineHorizontal: false,
                  dualLineVertical: false,
                ),
              ),
              emptyPlaceholder: Center(
                child: Text(
                  l10n.todayWidgetsSubtitle,
                  style: theme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
              itemBuilder: (item) {
                return TodayWidgetTile(
                  identifier: item.identifier,
                  database: widget.database,
                  currencyCode: widget.currencyCode,
                  isEditing: _editing,
                  onDelete: _editing
                      ? () {
                          _controller.delete(item.identifier);
                          setState(() {});
                        }
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
