import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_glass_card.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../data/datasources/mock/mock_account_data.dart';
import '../../../../data/datasources/mock/mock_transaction_data.dart';
import '../../../../data/repositories/account_repository_impl.dart';
import '../../../../data/repositories/transaction_repository_impl.dart';
import '../../../../domain/entities/account.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/repositories/account_repository.dart';
import '../../../../domain/repositories/transaction_repository.dart';
import '../../../../domain/usecases/get_accounts.dart';
import '../../../../domain/usecases/get_transactions.dart';

const List<String> _monthAbbrev = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// AI-projected balance over the next 6 months, extrapolated from the
/// user's recent average net cash flow.
class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  final AccountRepository _accountRepository =
      const AccountRepositoryImpl(MockAccountDataSource());
  late final GetAccounts _getAccounts = GetAccounts(_accountRepository);

  final TransactionRepository _transactionRepository =
      const TransactionRepositoryImpl(MockTransactionDataSource());
  late final GetTransactions _getTransactions =
      GetTransactions(_transactionRepository);

  List<Account> _accounts = [];
  List<Transaction> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final List<Account> accounts = await _getAccounts();
    final List<Transaction> transactions = await _getTransactions();
    if (!mounted) return;
    setState(() {
      _accounts = accounts;
      _transactions = transactions;
      _isLoading = false;
    });
  }

  double get _currentBalance => _accounts.fold(0, (sum, a) => sum + a.balance);

  /// Average net cash flow per day over the last 30 days, scaled to a
  /// 30-day month.
  double get _avgMonthlyNet {
    final DateTime cutoff = DateTime.now().subtract(const Duration(days: 30));
    final List<Transaction> recent =
        _transactions.where((t) => t.date.isAfter(cutoff)).toList();
    if (recent.isEmpty) return 0;
    final double net = recent.fold(0.0, (sum, t) => sum + t.signedAmount);
    return net;
  }

  List<double> get _projectedBalances {
    final double start = _currentBalance;
    final double monthlyNet = _avgMonthlyNet;
    return [for (int m = 0; m <= 6; m++) start + (monthlyNet * m)];
  }

  List<String> get _projectedLabels {
    final DateTime now = DateTime.now();
    return [
      for (int m = 0; m <= 6; m++) _monthAbbrev[(now.month - 1 + m) % 12],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    if (_isLoading) {
      return const Scaffold(body: Center(child: AppLoading()));
    }

    final List<double> balances = _projectedBalances;
    final List<String> labels = _projectedLabels;
    final double monthlyNet = _avgMonthlyNet;
    final bool trendingUp = monthlyNet >= 0;
    final double minY = balances.reduce((a, b) => a < b ? a : b);
    final double maxY = balances.reduce((a, b) => a > b ? a : b);
    final double pad = ((maxY - minY).abs() * 0.2).clamp(50, double.infinity);

    return Scaffold(
      appBar: const AppAppBar(title: 'Forecast'),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(responsive.spacing(AppSpacing.lg)),
          children: [
            AppGlassCard(
              showShadow: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        trendingUp
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        color: trendingUp
                            ? context.colorScheme.primary
                            : context.colorScheme.error,
                      ),
                      SizedBox(width: responsive.spacing(AppSpacing.sm)),
                      Expanded(
                        child: Text(
                          trendingUp
                              ? "At this rate, you'll have "
                                  '${AppHelpers.formatCurrency(balances.last)} '
                                  'by ${labels.last}.'
                              : "At this rate, you'll drop to "
                                  '${AppHelpers.formatCurrency(balances.last)} '
                                  'by ${labels.last}.',
                          style: context.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xl)),
            Text(
              '6-Month Balance Projection',
              style: context.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.sm)),
            AppCard(
              child: SizedBox(
                height: responsive.width(220),
                child: LineChart(
                  LineChartData(
                    minY: minY - pad,
                    maxY: maxY + pad,
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    lineTouchData: const LineTouchData(enabled: false),
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
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            final int index = value.round();
                            if (index != value ||
                                index < 0 ||
                                index >= labels.length) {
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
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          for (int i = 0; i < balances.length; i++)
                            FlSpot(i.toDouble(), balances[i]),
                        ],
                        isCurved: true,
                        color: trendingUp
                            ? context.colorScheme.primary
                            : context.colorScheme.error,
                        barWidth: 3,
                        dashArray: const [6, 4],
                        dotData: FlDotData(
                          getDotPainter: (spot, percent, bar, index) =>
                              FlDotCirclePainter(
                            radius: index == 0 ? 5 : 3,
                            color: bar.color ?? context.colorScheme.primary,
                            strokeWidth: 0,
                          ),
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: (trendingUp
                                  ? context.colorScheme.primary
                                  : context.colorScheme.error)
                              .withValues(alpha: 0.12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xl)),
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Current Balance', style: context.textTheme.bodySmall),
                        Text(
                          AppHelpers.formatCurrency(_currentBalance),
                          style: context.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: responsive.spacing(AppSpacing.md)),
                Expanded(
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Avg. Monthly Net', style: context.textTheme.bodySmall),
                        Text(
                          '${monthlyNet >= 0 ? '+' : ''}'
                          '${AppHelpers.formatCurrency(monthlyNet)}',
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: trendingUp
                                ? context.colorScheme.primary
                                : context.colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
