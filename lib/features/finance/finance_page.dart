import 'package:flutter/material.dart';

import '../../design_system/design_system.dart';
import '../../l10n/app_localizations.dart';
import '../../shell/module_scaffold.dart';

class FinancePage extends StatelessWidget {
  const FinancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ModuleScaffold(
      title: l10n.navFinance,
      subtitle: l10n.financeSubtitle,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: LumenSpacing.pagePadding,
            ),
            child: GradientMetricCard(
              label: l10n.roomComingSoon,
              value: '0.00',
              suffix: 'USD',
              gradient: LumenColors.gradEmber,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: LumenSpacing.lg)),
        const SliverToBoxAdapter(
          child: TransactionRow(
            title: 'Coffee',
            subtitle: 'Food · sample',
            amountLabel: '−4.50',
            isExpense: true,
          ),
        ),
        const SliverToBoxAdapter(
          child: TransactionRow(
            title: 'Paycheck',
            subtitle: 'Income · sample',
            amountLabel: '+2 400',
            isExpense: false,
          ),
        ),
      ],
    );
  }
}
