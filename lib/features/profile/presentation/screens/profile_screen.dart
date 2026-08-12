import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/financial_health_calculator.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../data/datasources/mock/mock_account_data.dart';
import '../../../../data/datasources/mock/mock_budget_data.dart';
import '../../../../data/datasources/mock/mock_savings_goal_data.dart';
import '../../../../data/datasources/mock/mock_transaction_data.dart';
import '../../../../data/datasources/mock/mock_user_data.dart';
import '../../../../data/repositories/account_repository_impl.dart';
import '../../../../data/repositories/budget_repository_impl.dart';
import '../../../../data/repositories/savings_goal_repository_impl.dart';
import '../../../../data/repositories/transaction_repository_impl.dart';
import '../../../../data/repositories/user_repository_impl.dart';
import '../../../../domain/entities/account.dart';
import '../../../../domain/entities/budget.dart';
import '../../../../domain/entities/savings_goal.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/entities/user_profile.dart';
import '../../../../domain/repositories/account_repository.dart';
import '../../../../domain/repositories/budget_repository.dart';
import '../../../../domain/repositories/savings_goal_repository.dart';
import '../../../../domain/repositories/transaction_repository.dart';
import '../../../../domain/repositories/user_repository.dart';
import '../../../../domain/usecases/get_accounts.dart';
import '../../../../domain/usecases/get_budgets.dart';
import '../../../../domain/usecases/get_savings_goals.dart';
import '../../../../domain/usecases/get_transactions.dart';
import '../../../../domain/usecases/get_user_profile.dart';
import '../state/profile_screen_actions.dart';
import '../widgets/ai_profile_section.dart';
import '../widgets/financial_overview_grid.dart';
import '../widgets/financial_profile_section.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_plan_card.dart';

/// The signed-in user's profile screen: identity, a real-data financial
/// overview, editable financial preferences, AI personalization, and the
/// account/billing menu.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserRepository _userRepository =
      const UserRepositoryImpl(MockUserDataSource());
  late final GetUserProfile _getUserProfile = GetUserProfile(_userRepository);

  final AccountRepository _accountRepository =
      const AccountRepositoryImpl(MockAccountDataSource());
  late final GetAccounts _getAccounts = GetAccounts(_accountRepository);

  final TransactionRepository _transactionRepository =
      const TransactionRepositoryImpl(MockTransactionDataSource());
  late final GetTransactions _getTransactions =
      GetTransactions(_transactionRepository);

  final BudgetRepository _budgetRepository =
      const BudgetRepositoryImpl(MockBudgetDataSource());
  late final GetBudgets _getBudgets = GetBudgets(_budgetRepository);

  final SavingsGoalRepository _savingsGoalRepository =
      const SavingsGoalRepositoryImpl(MockSavingsGoalDataSource());
  late final GetSavingsGoals _getSavingsGoals =
      GetSavingsGoals(_savingsGoalRepository);

  UserProfile? _profile;
  List<Account> _accounts = [];
  List<Transaction> _transactions = [];
  List<Budget> _budgets = [];
  List<SavingsGoal> _goals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final results = await Future.wait([
      _getUserProfile(),
      _getAccounts(),
      _getTransactions(),
      _getBudgets(),
      _getSavingsGoals(),
    ]);
    if (!mounted) return;
    setState(() {
      _profile = results[0] as UserProfile;
      _accounts = results[1] as List<Account>;
      _transactions = results[2] as List<Transaction>;
      _budgets = results[3] as List<Budget>;
      _goals = results[4] as List<SavingsGoal>;
      _isLoading = false;
    });
  }

  double get _liquidBalance => _accounts
      .where((a) => a.type == AccountType.checking || a.type == AccountType.savings)
      .fold(0.0, (sum, a) => sum + a.balance);

  double get _netWorth => _accounts.fold(0.0, (sum, a) => sum + a.balance);

  double get _totalSavings =>
      _goals.fold(0.0, (sum, g) => sum + g.currentAmount);

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final UserProfile? profile = _profile;

    if (_isLoading || profile == null) {
      return const Scaffold(
        appBar: AppAppBar(title: AppStrings.profileScreenTitle),
        body: Center(child: AppLoading()),
      );
    }

    final double income = FinancialHealthCalculator.monthlyIncome(_transactions);
    final double expense = FinancialHealthCalculator.monthlyExpense(_transactions);
    final double savingsRate =
        income <= 0 ? 0 : ((income - expense) / income * 100).clamp(0, 100);
    final double healthScore = FinancialHealthCalculator.overallScore(
      accounts: _accounts,
      transactions: _transactions,
      budgets: _budgets,
    );

    return Scaffold(
      appBar: const AppAppBar(title: AppStrings.profileScreenTitle),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(responsive.spacing(AppSpacing.xxl)),
          children: [
            ProfileHeader(profile: profile),
            SizedBox(height: responsive.spacing(AppSpacing.xl)),
            const ProfilePlanCard(),
            SizedBox(height: responsive.spacing(AppSpacing.xl)),
            Text(
              'Financial Overview',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.sm)),
            FinancialOverviewGrid(
              totalBalance: _liquidBalance,
              monthlyIncome: income,
              monthlyExpenses: expense,
              totalSavings: _totalSavings,
              savingsRate: savingsRate,
              financialHealthScore: healthScore,
              netWorth: _netWorth,
              activeGoals: _goals.where((g) => !g.isComplete).length,
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xl)),
            const FinancialProfileSection(),
            SizedBox(height: responsive.spacing(AppSpacing.xl)),
            const AiProfileSection(),
            SizedBox(height: responsive.spacing(AppSpacing.xl)),
            for (final group in buildProfileMenuGroups(context)) ...[
              group,
              SizedBox(height: responsive.spacing(AppSpacing.xl)),
            ],
            Center(
              child: Text(
                AppStrings.buildVersionText,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
