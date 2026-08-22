import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../data/datasources/mock/mock_debt_data.dart';
import '../../../../data/repositories/debt_repository_impl.dart';
import '../../../../domain/entities/debt.dart';
import '../../../../domain/repositories/debt_repository.dart';
import '../../../../domain/usecases/get_debts.dart';
import '../widgets/debt_card.dart';

/// Debt tracking: total owed, a simple AI payoff forecast (avalanche --
/// highest interest first), and per-debt payoff progress.
class DebtScreen extends StatefulWidget {
  const DebtScreen({super.key});

  @override
  State<DebtScreen> createState() => _DebtScreenState();
}

class _DebtScreenState extends State<DebtScreen> {
  final DebtRepository _repository = const DebtRepositoryImpl(MockDebtDataSource());
  late final GetDebts _getDebts = GetDebts(_repository);

  List<Debt> _debts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final List<Debt> debts = await _getDebts();
    if (!mounted) return;
    setState(() {
      // Avalanche order: highest interest rate first.
      _debts = List.of(debts)
        ..sort((a, b) => b.interestRate.compareTo(a.interestRate));
      _isLoading = false;
    });
  }

  double get _totalBalance => _debts.fold(0, (sum, d) => sum + d.balance);
  double get _totalMinPayment =>
      _debts.fold(0, (sum, d) => sum + d.minimumPayment);
  double get _avgInterestRate {
    if (_debts.isEmpty) return 0;
    final double weighted =
        _debts.fold(0.0, (sum, d) => sum + d.interestRate * d.balance);
    return _totalBalance <= 0 ? 0 : weighted / _totalBalance;
  }

  int get _monthsToDebtFree {
    if (_totalMinPayment <= 0) return 0;
    return (_totalBalance / _totalMinPayment).ceil();
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    if (_isLoading) {
      return const Scaffold(body: Center(child: AppLoading()));
    }
    if (_debts.isEmpty) {
      return const Scaffold(
        body: AppEmptyState(
          icon: Icons.credit_score_outlined,
          title: "You're debt-free",
          description: 'No debts are being tracked right now.',
        ),
      );
    }

    final DateTime debtFreeDate = DateTime(
      DateTime.now().year,
      DateTime.now().month + _monthsToDebtFree,
      DateTime.now().day,
    );

    return Scaffold(
      appBar: const AppAppBar(title: 'Debt'),
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
                      'TOTAL DEBT',
                      style: context.textTheme.labelSmall
                          ?.copyWith(color: Colors.white70, letterSpacing: 1),
                    ),
                    SizedBox(height: responsive.spacing(AppSpacing.xs)),
                    Text(
                      AppHelpers.formatCurrency(_totalBalance),
                      style: context.textTheme.displaySmall
                          ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: responsive.spacing(AppSpacing.sm)),
                    Row(
                      children: [
                        Icon(Icons.auto_awesome_rounded,
                            color: Colors.white70, size: 14),
                        SizedBox(width: responsive.spacing(AppSpacing.xs)),
                        Expanded(
                          child: Text(
                            'Paying minimums only, avalanche order, you\'ll '
                            'be debt-free around ${_monthLabel(debtFreeDate)}.',
                            style: context.textTheme.bodySmall
                                ?.copyWith(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.lg)),
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Monthly Payments', style: context.textTheme.bodySmall),
                        Text(
                          AppHelpers.formatCurrency(_totalMinPayment),
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
                        Text('Avg. Interest Rate', style: context.textTheme.bodySmall),
                        Text(
                          '${_avgInterestRate.toStringAsFixed(1)}%',
                          style: context.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xl)),
            Text(
              'Payoff Order (Avalanche)',
              style: context.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.sm)),
            for (final debt in _debts)
              Padding(
                padding: EdgeInsets.only(bottom: responsive.spacing(AppSpacing.sm)),
                child: DebtCard(debt: debt),
              ),
          ],
        ),
      ),
    );
  }

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _monthLabel(DateTime date) => '${_months[date.month - 1]} ${date.year}';
}
