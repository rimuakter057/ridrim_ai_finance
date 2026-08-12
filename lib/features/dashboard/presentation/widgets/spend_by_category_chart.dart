import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/transaction_category_style.dart';
import '../../../../domain/entities/transaction.dart';

/// Donut chart of this month's spend, one slice per [TransactionCategory],
/// with a totals legend below.
class SpendByCategoryChart extends StatelessWidget {
  const SpendByCategoryChart({super.key, required this.totalsByCategory});

  /// Total spend per category this period. Zero/absent categories are
  /// omitted from the chart.
  final Map<TransactionCategory, double> totalsByCategory;

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final List<MapEntry<TransactionCategory, double>> entries =
        totalsByCategory.entries.where((e) => e.value > 0).toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }

    final double total = entries.fold(0, (sum, e) => sum + e.value);

    return Row(
      children: [
        SizedBox(
          width: responsive.width(120),
          height: responsive.width(120),
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: responsive.width(38),
              sections: [
                for (final entry in entries)
                  PieChartSectionData(
                    value: entry.value,
                    color: entry.key.iconColor,
                    radius: responsive.width(20),
                    showTitle: false,
                  ),
              ],
            ),
          ),
        ),
        SizedBox(width: responsive.spacing(AppSpacing.lg)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final entry in entries.take(5))
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: responsive.spacing(AppSpacing.xs) / 2,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: entry.key.iconColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: responsive.spacing(AppSpacing.xs)),
                      Expanded(
                        child: Text(
                          entry.key.label,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${(entry.value / total * 100).round()}%',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
