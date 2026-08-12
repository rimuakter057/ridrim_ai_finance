import 'package:ai_saas/features/budget/presentation/widgets/summary_state.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../data/datasources/mock/mock_budget_data.dart';
import '../../../../data/repositories/budget_repository_impl.dart';
import '../../../../domain/entities/budget.dart';
import '../../../../domain/repositories/budget_repository.dart';
import '../../../../domain/usecases/get_budgets.dart';
import '../widgets/budget_category_card.dart';
import '../widgets/radial_progress_gauge.dart';


class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final BudgetRepository _repository =
      const BudgetRepositoryImpl(MockBudgetDataSource());
  late final GetBudgets _getBudgets = GetBudgets(_repository);

  List<Budget> _budgets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final List<Budget> budgets = await _getBudgets();
    if (!mounted) return;
    setState(() {
      _budgets = budgets;
      _isLoading = false;
    });
  }

  double get _totalLimit => _budgets.fold(0, (sum, b) => sum + b.limit);
  double get _totalSpent => _budgets.fold(0, (sum, b) => sum + b.spent);
  double get _overallProgress =>
      _totalLimit <= 0 ? 0 : (_totalSpent / _totalLimit).clamp(0, 1);

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return Scaffold(
      appBar: const AppAppBar(title: 'Budget'),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: AppLoading())
            : _budgets.isEmpty
                ? const AppEmptyState(
                    icon: Icons.pie_chart_outline_rounded,
                    title: 'No budgets set yet',
                  )
                : ListView(
                    padding: EdgeInsets.all(responsive.spacing(AppSpacing.lg)),
                    children: [
                      // ── Overall hero gauge ──────────────────────────────
                      Center(
                        child: RadialProgressGauge(
                          size: responsive.width(160),
                          strokeWidth: 14,
                          progress: _overallProgress,
                          color: _overallProgress >= 1
                              ? context.colorScheme.error
                              : context.colorScheme.primary,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${(_overallProgress * 100).round()}%',
                                style: context.textTheme.displaySmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'of budget used',
                                style: context.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: responsive.spacing(AppSpacing.lg)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SummaryStat(
                            label: 'Spent',
                            value: AppHelpers.formatCurrency(_totalSpent),
                          ),
                          SummaryStat(
                            label: 'Budget',
                            value: AppHelpers.formatCurrency(_totalLimit),
                          ),
                          SummaryStat(
                            label: 'Remaining',
                            value: AppHelpers.formatCurrency(
                              (_totalLimit - _totalSpent)
                                  .clamp(0, double.infinity),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: responsive.spacing(AppSpacing.xxl)),
                      Text(
                        'Categories',
                        style: context.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: responsive.spacing(AppSpacing.sm)),
                      for (final budget in _budgets)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: responsive.spacing(AppSpacing.sm),
                          ),
                          child: BudgetCategoryCard(budget: budget),
                        ),
                    ],
                  ),
      ),
    );
  }
}




