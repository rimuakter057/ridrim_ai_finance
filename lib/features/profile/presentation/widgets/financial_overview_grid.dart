import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_card.dart';

class FinancialOverviewStat {
  const FinancialOverviewStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
}

/// A 2-column grid of key financial stats -- the Profile screen's
/// replacement for the old generic "API calls / generations / projects"
/// SaaS metrics row.
class FinancialOverviewGrid extends StatelessWidget {
  const FinancialOverviewGrid({
    required this.totalBalance,
    required this.monthlyIncome,
    required this.monthlyExpenses,
    required this.totalSavings,
    required this.savingsRate,
    required this.financialHealthScore,
    required this.netWorth,
    required this.activeGoals,
    super.key,
  });

  final double totalBalance;
  final double monthlyIncome;
  final double monthlyExpenses;
  final double totalSavings;
  final double savingsRate;
  final double financialHealthScore;
  final double netWorth;
  final int activeGoals;

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final List<FinancialOverviewStat> stats = [
      FinancialOverviewStat(
        label: 'Total Balance',
        value: AppHelpers.formatCurrency(totalBalance),
        icon: Icons.account_balance_wallet_outlined,
        color: AppColors.tileTealIcon,
        onTap: () => context.push(AppRoutes.accounts),
      ),
      FinancialOverviewStat(
        label: 'Net Worth',
        value: AppHelpers.formatCurrency(netWorth),
        icon: Icons.stacked_line_chart_rounded,
        color: AppColors.tileIndigoIcon,
      ),
      FinancialOverviewStat(
        label: 'Monthly Income',
        value: AppHelpers.formatCurrency(monthlyIncome),
        icon: Icons.arrow_downward_rounded,
        color: AppColors.tileGreenIcon,
      ),
      FinancialOverviewStat(
        label: 'Monthly Expenses',
        value: AppHelpers.formatCurrency(monthlyExpenses),
        icon: Icons.arrow_upward_rounded,
        color: AppColors.tileRedIcon,
      ),
      FinancialOverviewStat(
        label: 'Total Savings',
        value: AppHelpers.formatCurrency(totalSavings),
        icon: Icons.savings_outlined,
        color: AppColors.tileSkyIcon,
        onTap: () => context.push(AppRoutes.savings),
      ),
      FinancialOverviewStat(
        label: 'Savings Rate',
        value: '${savingsRate.round()}%',
        icon: Icons.percent_rounded,
        color: AppColors.tileAmberIcon,
      ),
      FinancialOverviewStat(
        label: 'Health Score',
        value: financialHealthScore.round().toString(),
        icon: Icons.favorite_border_rounded,
        color: AppColors.tilePinkIcon,
        onTap: () => context.push(AppRoutes.financialHealth),
      ),
      FinancialOverviewStat(
        label: 'Active Goals',
        value: activeGoals.toString(),
        icon: Icons.flag_outlined,
        color: AppColors.tilePurpleIcon,
        onTap: () => context.push(AppRoutes.savings),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: responsive.spacing(AppSpacing.sm),
        mainAxisSpacing: responsive.spacing(AppSpacing.sm),
        childAspectRatio: 1.35,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final FinancialOverviewStat stat = stats[index];
        return AppCard(
          onTap: stat.onTap,
          padding: EdgeInsets.all(responsive.spacing(AppSpacing.sm)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: responsive.width(28),
                height: responsive.width(28),
                decoration: BoxDecoration(
                  color: stat.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(stat.icon, size: 14, color: stat.color),
              ),
              SizedBox(height: responsive.spacing(AppSpacing.xs) / 2),
              Text(
                stat.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                stat.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodySmall,
              ),
            ],
          ),
        );
      },
    );
  }
}
