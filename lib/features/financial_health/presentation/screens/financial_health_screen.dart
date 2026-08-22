import 'package:ridrim/features/financial_health/controller/finance_health_controller.dart';
import 'package:ridrim/features/financial_health/presentation/widget/factor_card.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../budget/presentation/widgets/radial_progress_gauge.dart';

class FinancialHealthScreen extends StatefulWidget {
  const FinancialHealthScreen({super.key});

  @override
  State<FinancialHealthScreen> createState() => _FinancialHealthScreenState();
}

class _FinancialHealthScreenState extends State<FinancialHealthScreen>
    with FinancialHealthControllerMixin {
  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    if (isLoading) {
      return const Scaffold(body: Center(child: AppLoading()));
    }

    final double score = overallScore;
    final (String label, Color color) = ratingFor(score, context);

    return Scaffold(
      appBar: const AppAppBar(title: 'Financial Health'),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(responsive.spacing(AppSpacing.lg)),
          children: [
            Center(
              child: RadialProgressGauge(
                size: responsive.width(180),
                strokeWidth: 16,
                progress: score / 100,
                color: color,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      score.round().toString(),
                      style: context.textTheme.displayMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      label,
                      style: context.textTheme.labelLarge
                          ?.copyWith(color: color, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xxl)),
            Text(
              'What makes up your score',
              style: context.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.sm)),
            FactorCard(
              icon: Icons.pie_chart_outline_rounded,
              title: 'Budget Adherence',
              description: 'How many of your budgets are within limit.',
              score: budgetAdherenceScore,
            ),
            SizedBox(height: responsive.spacing(AppSpacing.sm)),
            FactorCard(
              icon: Icons.savings_outlined,
              title: 'Savings Rate',
              description: 'Share of income kept after expenses this month.',
              score: savingsRateScore,
            ),
            SizedBox(height: responsive.spacing(AppSpacing.sm)),
            FactorCard(
              icon: Icons.shield_outlined,
              title: 'Emergency Fund Coverage',
              description: 'Months of expenses covered by your savings.',
              score: emergencyFundScore,
            ),
          ],
        ),
      ),
    );
  }
}