import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_glass_card.dart';

/// Hero AI-insight card: a generated one-line takeaway over the user's
/// spending, plus a 14-day net-cash-flow sparkline. The signature
/// "AI-first" surface on the Dashboard.
class AiInsightCard extends StatelessWidget {
  const AiInsightCard({
    super.key,
    required this.insight,
    required this.sparklineValues,
  });

  final String insight;

  /// Net cash flow per day, oldest first.
  final List<double> sparklineValues;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: AppGlassCard(
        showShadow: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(responsive.spacing(AppSpacing.xs)),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: responsive.iconSize(16),
                  ),
                ),
                SizedBox(width: responsive.spacing(AppSpacing.sm)),
                Text(
                  'AI Insight',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.spacing(AppSpacing.md)),
            Text(
              insight,
              style: theme.textTheme.titleMedium?.copyWith(
                color:Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.lg)),
            SizedBox(
              height: responsive.width(48),
              child: _Sparkline(values: sparklineValues),
            ),
          ],
        ),
      ),
    );
  }
}

class _Sparkline extends StatelessWidget {
  const _Sparkline({required this.values});

  final List<double> values;

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const SizedBox.shrink();

    final double minY = values.reduce((a, b) => a < b ? a : b);
    final double maxY = values.reduce((a, b) => a > b ? a : b);
    final double pad = ((maxY - minY).abs() * 0.15).clamp(1, double.infinity);

    return LineChart(
      LineChartData(
        minY: minY - pad,
        maxY: maxY + pad,
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (int i = 0; i < values.length; i++)
                FlSpot(i.toDouble(), values[i]),
            ],
            isCurved: true,
            color: Colors.white,
            barWidth: 2.5,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.white.withValues(alpha: 0.18),
            ),
          ),
        ],
      ),
    );
  }
}
