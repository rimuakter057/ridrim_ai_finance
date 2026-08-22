import 'package:ridrim/features/dashboard/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../accounts/presentation/widgets/account_card.dart';
import '../../../transactions/presentation/widgets/transaction_tile.dart';
import '../../controller/dashboard_controller.dart';
import '../widgets/ai_insight_card.dart';
import '../widgets/budget_progress_list.dart';
import '../widgets/quick_link_card.dart';
import '../widgets/quick_link_data.dart';
import '../widgets/spend_by_category_chart.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with DashboardLogicMixin {
  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final String displayName = profile?.name.split(' ').first ?? 'there';

    if (isLoading) {
      return const Scaffold(body: Center(child: AppLoading()));
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(responsive.spacing(AppSpacing.lg)),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, $displayName',
                        style: context.textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Here's your financial snapshot",
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => context.push(AppRoutes.profile),
                  icon: CircleAvatar(
                    radius: responsive.width(20),
                    backgroundColor: context.colorScheme.primary,
                    child: Text(
                      displayName.isNotEmpty ? displayName[0] : '?',
                      style: context.textTheme.titleMedium
                          ?.copyWith(color: context.colorScheme.onPrimary),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.spacing(AppSpacing.lg)),

            AiInsightCard(insight: aiInsight, sparklineValues: sparklineValues),
            SizedBox(height: responsive.spacing(AppSpacing.lg)),

            AppCard(
              onTap: () => context.push(AppRoutes.aiChat),
              radius: AppRadius.pill,
              padding: EdgeInsets.symmetric(
                horizontal: responsive.spacing(AppSpacing.lg),
                vertical: responsive.spacing(AppSpacing.sm),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    size: responsive.iconSize(20),
                    color: context.colorScheme.primary,
                  ),
                  SizedBox(width: responsive.spacing(AppSpacing.md)),
                  Expanded(
                    child: Text(
                      'Ask your AI assistant about your money...',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: responsive.iconSize(18),
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xl)),

            Text(
              'Net Worth',
              style: context.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.sm)),
            AppCard(
              child: Text(
                AppHelpers.formatCurrency(netWorth),
                style: context.textTheme.displaySmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xl)),

            SectionHeader(
              title: 'Accounts',
              onSeeAll: () => context.push(AppRoutes.accounts),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.sm)),
            IntrinsicHeight(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int i = 0; i < accounts.length; i++) ...[
                      if (i > 0)
                        SizedBox(width: responsive.spacing(AppSpacing.sm)),
                      AccountCard(
                        account: accounts[i],
                        compact: true,
                        onTap: () =>
                            context.push('/accounts/${accounts[i].id}'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xl)),

            Text(
              'Spending This Month',
              style: context.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.sm)),
            AppCard(
              child: SpendByCategoryChart(
                totalsByCategory: monthlySpendByCategory,
              ),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xl)),

            SectionHeader(
              title: 'Budgets',
              onSeeAll: () => context.push(AppRoutes.budget),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.sm)),
            AppCard(child: BudgetProgressList(budgets: topBudgets)),
            SizedBox(height: responsive.spacing(AppSpacing.xl)),

            Text(
              'Quick Links',
              style: context.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.sm)),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: responsive.spacing(AppSpacing.xs),
                mainAxisSpacing: responsive.spacing(AppSpacing.xs),
                childAspectRatio: 0.88,
              ),
              itemCount: quickLinks.length,
              itemBuilder: (context, index) {
                final QuickLinkData link = quickLinks[index];
                return QuickLinkCard(
                  data: link,
                  onTap: () => context.push(link.route),
                );
              },
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xl)),

            SectionHeader(
              title: 'Recent Transactions',
              onSeeAll: () => context.push(AppRoutes.transactions),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.sm)),
            for (final t in recentTransactions)
              Padding(
                padding: EdgeInsets.only(bottom: responsive.spacing(AppSpacing.xs)),
                child: TransactionTile(
                  transaction: t,
                  onTap: () =>
                      context.push(AppRoutes.transactionDetail(t.id)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

