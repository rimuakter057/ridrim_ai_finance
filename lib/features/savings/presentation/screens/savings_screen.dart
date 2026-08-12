import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../data/datasources/mock/mock_savings_goal_data.dart';
import '../../../../data/repositories/savings_goal_repository_impl.dart';
import '../../../../domain/entities/savings_goal.dart';
import '../../../../domain/repositories/savings_goal_repository.dart';
import '../../../../domain/usecases/add_savings_goal.dart';
import '../../../../domain/usecases/contribute_to_goal.dart';
import '../../../../domain/usecases/get_savings_goals.dart';
import '../widgets/add_funds_sheet.dart';
import '../widgets/add_goal_sheet.dart';
import '../widgets/savings_goal_card.dart';

/// Savings goals: target vs. progress, with the ability to create a goal
/// and log contributions toward it.
class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  final SavingsGoalRepository _repository =
      const SavingsGoalRepositoryImpl(MockSavingsGoalDataSource());
  late final GetSavingsGoals _getGoals = GetSavingsGoals(_repository);
  late final AddSavingsGoal _addGoal = AddSavingsGoal(_repository);
  late final ContributeToGoal _contribute = ContributeToGoal(_repository);

  List<SavingsGoal> _goals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final List<SavingsGoal> goals = await _getGoals();
    if (!mounted) return;
    setState(() {
      _goals = goals;
      _isLoading = false;
    });
  }

  Future<void> _handleAddFunds(SavingsGoal goal) async {
    final double? amount = await showAddFundsSheet(context, goal.name);
    if (amount == null) return;
    await _contribute(goal.id, amount);
    if (!mounted) return;
    context.showSnackBar('Added ${AppHelpers.formatCurrency(amount)} to ${goal.name}');
    _load();
  }

  Future<void> _handleAddGoal() async {
    final NewGoalInput? input = await showAddGoalSheet(context);
    if (input == null) return;
    final DateTime now = DateTime.now();
    await _addGoal(
      SavingsGoal(
        id: AppHelpers.generateId(),
        name: input.name,
        targetAmount: input.targetAmount,
        currentAmount: 0,
        targetDate: DateTime(now.year, now.month + input.months, now.day),
        iconKey: input.iconKey,
      ),
    );
    if (!mounted) return;
    context.showSnackBar('${input.name} goal created');
    _load();
  }

  double get _totalSaved => _goals.fold(0, (sum, g) => sum + g.currentAmount);
  double get _totalTarget => _goals.fold(0, (sum, g) => sum + g.targetAmount);

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return Scaffold(
      appBar: AppAppBar(
        title: 'Savings',
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: _handleAddGoal,
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: AppLoading())
            : _goals.isEmpty
                ? AppEmptyState(
                    icon: Icons.savings_outlined,
                    title: 'No savings goals yet',
                    description: 'Create a goal and start tracking progress.',
                    actionLabel: 'New Goal',
                    onActionPressed: _handleAddGoal,
                  )
                : ListView(
                    padding: EdgeInsets.all(responsive.spacing(AppSpacing.lg)),
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF042F2E), Color(0xFF0D9488)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(responsive.spacing(AppSpacing.lg)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TOTAL SAVED',
                                style: context.textTheme.labelSmall?.copyWith(
                                  color: Colors.white70,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(height: responsive.spacing(AppSpacing.xs)),
                              Text(
                                AppHelpers.formatCurrency(_totalSaved),
                                style: context.textTheme.displaySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'of ${AppHelpers.formatCurrency(_totalTarget)} across '
                                '${_goals.length} goal${_goals.length == 1 ? '' : 's'}',
                                style: context.textTheme.bodySmall
                                    ?.copyWith(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: responsive.spacing(AppSpacing.xl)),
                      for (final goal in _goals)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: responsive.spacing(AppSpacing.md),
                          ),
                          child: SavingsGoalCard(
                            goal: goal,
                            onAddFunds: () => _handleAddFunds(goal),
                          ),
                        ),
                    ],
                  ),
      ),
    );
  }
}
