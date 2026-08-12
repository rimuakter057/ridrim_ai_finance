import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../settings/presentation/widgets/settings_group_card.dart';


class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return Scaffold(
      appBar: const AppAppBar(title: 'More'),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(responsive.spacing(AppSpacing.lg)),
          children: [
            SettingsGroupCard(
              title: 'Finance',
              items: [
                SettingsTileData(
                  icon: Icons.pie_chart_outline_rounded,
                  label: 'Budget',
                  iconBgColor: AppColors.tileGreenBg,
                  iconColor: AppColors.tileGreenIcon,
                  onTap: () => context.push(AppRoutes.budget),
                ),
                SettingsTileData(
                  icon: Icons.savings_outlined,
                  label: 'Savings',
                  iconBgColor: AppColors.tileTealBg,
                  iconColor: AppColors.tileTealIcon,
                  onTap: () => context.push(AppRoutes.savings),
                ),
                SettingsTileData(
                  icon: Icons.receipt_long_outlined,
                  label: 'Bills',
                  iconBgColor: AppColors.tileAmberBg,
                  iconColor: AppColors.tileAmberIcon,
                  onTap: () => context.push(AppRoutes.bills),
                ),
                SettingsTileData(
                  icon: Icons.bar_chart_rounded,
                  label: 'Analytics',
                  iconBgColor: AppColors.tileIndigoBg,
                  iconColor: AppColors.tileIndigoIcon,
                  onTap: () => context.push(AppRoutes.analytics),
                ),
                SettingsTileData(
                  icon: Icons.trending_up_rounded,
                  label: 'Forecast',
                  iconBgColor: AppColors.tileSkyBg,
                  iconColor: AppColors.tileSkyIcon,
                  onTap: () => context.push(AppRoutes.forecast),
                ),
                SettingsTileData(
                  icon: Icons.favorite_border_rounded,
                  label: 'Financial Health',
                  iconBgColor: AppColors.tilePinkBg,
                  iconColor: AppColors.tilePinkIcon,
                  onTap: () => context.push(AppRoutes.financialHealth),
                ),
                SettingsTileData(
                  icon: Icons.notifications_none_rounded,
                  label: 'Alerts',
                  iconBgColor: AppColors.tileOrangeBg,
                  iconColor: AppColors.tileOrangeIcon,
                  onTap: () => context.push(AppRoutes.alerts),
                ),
                SettingsTileData(
                  icon: Icons.credit_score_outlined,
                  label: 'Debt',
                  iconBgColor: AppColors.tileRedBg,
                  iconColor: AppColors.tileRedIcon,
                  onTap: () => context.push(AppRoutes.debt),
                ),
                SettingsTileData(
                  icon: Icons.candlestick_chart_outlined,
                  label: 'Investments',
                  iconBgColor: AppColors.tileSlateBg,
                  iconColor: AppColors.tileSlateIcon,
                  onTap: () => context.push(AppRoutes.investments),
                ),
              ],
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xl)),
            SettingsGroupCard(
              title: 'Account',
              items: [
                SettingsTileData(
                  icon: Icons.person_outline_rounded,
                  label: 'Profile',
                  iconBgColor: AppColors.tilePurpleBg,
                  iconColor: AppColors.tilePurpleIcon,
                  onTap: () => context.push(AppRoutes.profile),
                ),
                SettingsTileData(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  iconBgColor: AppColors.tileSlateBg,
                  iconColor: AppColors.tileSlateIcon,
                  onTap: () => context.push(AppRoutes.settings),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
