import 'package:flutter/material.dart';

import '../../../../core/routing/app_router.dart';

/// A single quick-link tile on the Dashboard, routing into a finance
/// feature that doesn't have its own bottom-nav tab.
class QuickLinkData {
  const QuickLinkData({
    required this.icon,
    required this.label,
    required this.route,
  });

  final IconData icon;
  final String label;
  final String route;
}

const List<QuickLinkData> quickLinks = [
  QuickLinkData(
    icon: Icons.pie_chart_outline_rounded,
    label: 'Budget',
    route: AppRoutes.budget,
  ),
  QuickLinkData(
    icon: Icons.savings_outlined,
    label: 'Savings',
    route: AppRoutes.savings,
  ),
  QuickLinkData(
    icon: Icons.receipt_long_outlined,
    label: 'Bills',
    route: AppRoutes.bills,
  ),
  QuickLinkData(
    icon: Icons.bar_chart_rounded,
    label: 'Analytics',
    route: AppRoutes.analytics,
  ),
  QuickLinkData(
    icon: Icons.trending_up_rounded,
    label: 'Forecast',
    route: AppRoutes.forecast,
  ),
  QuickLinkData(
    icon: Icons.favorite_border_rounded,
    label: 'Health',
    route: AppRoutes.financialHealth,
  ),
  QuickLinkData(
    icon: Icons.notifications_none_rounded,
    label: 'Alerts',
    route: AppRoutes.alerts,
  ),
  QuickLinkData(
    icon: Icons.more_horiz_rounded,
    label: 'More',
    route: AppRoutes.more,
  ),
];
