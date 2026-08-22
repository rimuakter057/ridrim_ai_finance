import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/transaction_category_style.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../data/datasources/mock/mock_investment_data.dart';
import '../../../../data/repositories/investment_repository_impl.dart';
import '../../../../domain/entities/investment.dart';
import '../../../../domain/repositories/investment_repository.dart';
import '../../../../domain/usecases/get_investments.dart';
import '../widgets/holding_tile.dart';

/// Investment portfolio: total value, gain/loss, asset allocation, and a
/// list of holdings.
class InvestmentsScreen extends StatefulWidget {
  const InvestmentsScreen({super.key});

  @override
  State<InvestmentsScreen> createState() => _InvestmentsScreenState();
}

class _InvestmentsScreenState extends State<InvestmentsScreen> {
  final InvestmentRepository _repository =
      const InvestmentRepositoryImpl(MockInvestmentDataSource());
  late final GetInvestments _getInvestments = GetInvestments(_repository);

  List<Investment> _investments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final List<Investment> investments = await _getInvestments();
    if (!mounted) return;
    setState(() {
      _investments = List.of(investments)
        ..sort((a, b) => b.currentValue.compareTo(a.currentValue));
      _isLoading = false;
    });
  }

  double get _totalValue =>
      _investments.fold(0, (sum, i) => sum + i.currentValue);
  double get _totalCostBasis =>
      _investments.fold(0, (sum, i) => sum + i.costBasis);
  double get _totalGainLoss => _totalValue - _totalCostBasis;
  double get _totalGainLossPercent =>
      _totalCostBasis <= 0 ? 0 : (_totalGainLoss / _totalCostBasis) * 100;

  Investment? get _bestPerformer {
    if (_investments.isEmpty) return null;
    return _investments.reduce(
      (a, b) => a.gainLossPercent > b.gainLossPercent ? a : b,
    );
  }

  Map<InvestmentType, double> get _allocationByType {
    final Map<InvestmentType, double> totals = {};
    for (final Investment i in _investments) {
      totals.update(
        i.type,
        (v) => v + i.currentValue,
        ifAbsent: () => i.currentValue,
      );
    }
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    if (_isLoading) {
      return const Scaffold(body: Center(child: AppLoading()));
    }
    if (_investments.isEmpty) {
      return const Scaffold(
        body: AppEmptyState(
          icon: Icons.candlestick_chart_outlined,
          title: 'No investments yet',
          description: 'Link a brokerage account to see your portfolio here.',
        ),
      );
    }

    final bool isGaining = _totalGainLoss >= 0;
    final Investment? best = _bestPerformer;
    final List<MapEntry<InvestmentType, double>> allocation =
        _allocationByType.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: const AppAppBar(title: 'Investments'),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(responsive.spacing(AppSpacing.lg)),
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: Padding(
                padding: EdgeInsets.all(responsive.spacing(AppSpacing.lg)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PORTFOLIO VALUE',
                      style: context.textTheme.labelSmall
                          ?.copyWith(color: Colors.white70, letterSpacing: 1),
                    ),
                    SizedBox(height: responsive.spacing(AppSpacing.xs)),
                    Text(
                      AppHelpers.formatCurrency(_totalValue),
                      style: context.textTheme.displaySmall
                          ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: responsive.spacing(AppSpacing.xs)),
                    Row(
                      children: [
                        Icon(
                          isGaining
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        Text(
                          '${AppHelpers.formatCurrency(_totalGainLoss.abs())} '
                          '(${_totalGainLossPercent.abs().toStringAsFixed(1)}%) '
                          'all time',
                          style: context.textTheme.bodyMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                    if (best != null) ...[
                      SizedBox(height: responsive.spacing(AppSpacing.sm)),
                      Row(
                        children: [
                          const Icon(Icons.auto_awesome_rounded,
                              color: Colors.white70, size: 14),
                          SizedBox(width: responsive.spacing(AppSpacing.xs)),
                          Expanded(
                            child: Text(
                              '${best.name} is your top performer, up '
                              '${best.gainLossPercent.toStringAsFixed(1)}%.',
                              style: context.textTheme.bodySmall
                                  ?.copyWith(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xl)),
            Text(
              'Asset Allocation',
              style: context.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.sm)),
            AppCard(
              child: Row(
                children: [
                  SizedBox(
                    width: responsive.width(110),
                    height: responsive.width(110),
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: responsive.width(34),
                        sections: [
                          for (final entry in allocation)
                            PieChartSectionData(
                              value: entry.value,
                              color: entry.key.color,
                              radius: responsive.width(18),
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
                        for (final entry in allocation)
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
                                    color: entry.key.color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: responsive.spacing(AppSpacing.xs)),
                                Expanded(
                                  child: Text(
                                    entry.key.label,
                                    style: context.textTheme.bodySmall,
                                  ),
                                ),
                                Text(
                                  '${(entry.value / _totalValue * 100).round()}%',
                                  style: context.textTheme.labelSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xl)),
            Text(
              'Holdings',
              style: context.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.sm)),
            for (final investment in _investments)
              Padding(
                padding: EdgeInsets.only(bottom: responsive.spacing(AppSpacing.sm)),
                child: HoldingTile(investment: investment),
              ),
          ],
        ),
      ),
    );
  }
}
