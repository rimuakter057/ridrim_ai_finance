import 'package:ai_saas/domain/entities/transaction.dart';
import 'package:ai_saas/features/analytics/controller/analytics_controller.dart';
import 'package:ai_saas/features/analytics/presentation/widget/category_row.dart';
import 'package:ai_saas/features/analytics/presentation/widget/state_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading.dart';


class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with AnalyticsControllerMixin {
  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    if (isLoading) {
      return const Scaffold(body: Center(child: AppLoading()));
    }
    if (transactions.isEmpty) {
      return const Scaffold(
        body: AppEmptyState(
          icon: Icons.bar_chart_rounded,
          title: 'No transactions to analyze yet',
        ),
      );
    }

    final List<double> weekly = weeklyTotals;
    final double maxWeekly = weekly.reduce((a, b) => a > b ? a : b);
    final List<MapEntry<TransactionCategory, double>> ranked =
    totalsByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final double maxCategory = ranked.isEmpty ? 1 : ranked.first.value;

    return Scaffold(
      appBar: const AppAppBar(title: 'Analytics'),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(responsive.spacing(AppSpacing.lg)),
          children: [
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: 'Income',
                    value: AppHelpers.formatCurrency(totalIncome),
                    color: context.colorScheme.primary,
                    icon: Icons.arrow_downward_rounded,
                  ),
                ),
                SizedBox(width: responsive.spacing(AppSpacing.md)),
                Expanded(
                  child: StatCard(
                    label: 'Expense',
                    value: AppHelpers.formatCurrency(totalExpense),
                    color: context.colorScheme.error,
                    icon: Icons.arrow_upward_rounded,
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xl)),
            Text(
              'Weekly Spend Trend',
              style: context.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.sm)),
            AppCard(
              child: SizedBox(
                height: responsive.width(160),
                child: BarChart(
                  BarChartData(
                    maxY: maxWeekly <= 0 ? 1 : maxWeekly * 1.2,
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 24,
                          getTitlesWidget: (value, meta) {
                            final int index = value.toInt();
                            final List<String> labels = [
                              '4w ago', '3w ago', '2w ago', 'This week',
                            ];
                            if (index < 0 || index >= labels.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                labels[index],
                                style: context.textTheme.labelSmall,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: [
                      for (int i = 0; i < weekly.length; i++)
                        BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: weekly[i],
                              width: 28,
                              borderRadius: BorderRadius.circular(6),
                              color: context.colorScheme.primary,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xl)),
            Text(
              'Top Categories',
              style: context.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.sm)),
            AppCard(
              child: Column(
                children: [
                  for (int i = 0; i < ranked.length; i++)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: i == ranked.length - 1
                            ? 0
                            : responsive.spacing(AppSpacing.md),
                      ),
                      child: CategoryRankRow(
                        rank: i + 1,
                        category: ranked[i].key,
                        amount: ranked[i].value,
                        fraction: ranked[i].value / maxCategory,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


