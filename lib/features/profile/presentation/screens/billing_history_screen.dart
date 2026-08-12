import 'package:ai_saas/features/profile/presentation/widgets/billing_bar_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_card.dart';

/// Mock invoice item.
class _InvoiceItem {
  const _InvoiceItem({
    required this.id,
    required this.date,
    required this.amount,
    required this.plan,
    required this.status,
  });

  final String id;
  final String date;
  final String amount;
  final String plan;
  final String status;
}

const List<_InvoiceItem> _invoices = [
  _InvoiceItem(
    id: 'INV-2026-008',
    date: 'Aug 01, 2026',
    amount: '\$29.00',
    plan: 'Pro Plan (Monthly)',
    status: 'Paid',
  ),
  _InvoiceItem(
    id: 'INV-2026-007',
    date: 'Jul 01, 2026',
    amount: '\$29.00',
    plan: 'Pro Plan (Monthly)',
    status: 'Paid',
  ),
  _InvoiceItem(
    id: 'INV-2026-006',
    date: 'Jun 01, 2026',
    amount: '\$29.00',
    plan: 'Pro Plan (Monthly)',
    status: 'Paid',
  ),
  _InvoiceItem(
    id: 'INV-2026-005',
    date: 'May 01, 2026',
    amount: '\$29.00',
    plan: 'Pro Plan (Monthly)',
    status: 'Paid',
  ),
  _InvoiceItem(
    id: 'INV-2026-004',
    date: 'Apr 01, 2026',
    amount: '\$19.00',
    plan: 'Starter Plan',
    status: 'Paid',
  ),
];

/// Billing History screen featuring a Bar Chart of monthly spend + Invoice list.
class BillingHistoryScreen extends StatelessWidget {
  const BillingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final Color primary = theme.colorScheme.primary;

    return Scaffold(
      appBar: const AppAppBar(
        title: AppStrings.billingHistoryScreenTitle,
        subtitle: AppStrings.billingHistoryScreenSubtitle,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(responsive.spacing(AppSpacing.lg)),
          children: [
            // ── Total Spent Summary Card ─────────────────────────────────
            AppCard(
              padding: EdgeInsets.all(responsive.spacing(AppSpacing.md)),
              child: Row(
                children: [
                  Container(
                    width: responsive.width(44),
                    height: responsive.width(44),
                    decoration: BoxDecoration(
                      color: AppColors.tileIndigoBg,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      color: AppColors.tileIndigoIcon,
                    ),
                  ),
                  SizedBox(width: responsive.spacing(AppSpacing.md)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.totalSpentLabel,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '\$135.00',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.tileGreenBg,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(
                      AppStrings.allPaidBadge,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.tileGreenIcon,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.lg)),

            // ── Monthly Spend Bar Chart ──────────────────────────────────
            Text(
              AppStrings.monthlySpendingChartLabel,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xs)),
            AppCard(
              padding: EdgeInsets.only(
                top: responsive.spacing(AppSpacing.lg),
                right: responsive.spacing(AppSpacing.md),
                bottom: responsive.spacing(AppSpacing.xs),
              ),
              child: SizedBox(
                height: 180,
                child: BillingBarChart(primary: primary),
              ),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.lg)),

            // ── Invoice List ─────────────────────────────────────────────
            Text(
              AppStrings.pastInvoicesHeader,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xs)),
            for (final inv in _invoices) ...[
              AppCard(
                padding: EdgeInsets.all(responsive.spacing(AppSpacing.md)),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            inv.plan,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${inv.id} • ${inv.date}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          inv.amount,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.download_rounded,
                              size: 14,
                              color: AppColors.tileIndigoIcon,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              'PDF',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColors.tileIndigoIcon,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsive.spacing(AppSpacing.xs)),
            ],
          ],
        ),
      ),
    );
  }
}


