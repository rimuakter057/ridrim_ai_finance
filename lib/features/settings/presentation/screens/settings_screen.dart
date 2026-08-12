import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/font_scale_notifier.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/theme_mode_notifier.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../data/datasources/mock/mock_account_data.dart';
import '../../../../data/repositories/account_repository_impl.dart';
import '../../../../domain/entities/account.dart';
import '../../../../domain/repositories/account_repository.dart';
import '../../../../domain/usecases/get_accounts.dart';
import '../../../profile/presentation/widgets/profile_menu_tile.dart';
import '../widgets/feedback_sheet.dart';
import '../widgets/settings_group_card.dart';
import '../widgets/settings_option_sheet.dart';
import '../widgets/settings_section_header.dart';
import '../widgets/theme_mode_selector.dart';

/// App preferences, organized as a finance app: appearance, finance
/// preferences, AI settings, notifications, budget/accounts/goals/bills/
/// debt configuration, security & privacy, analytics & reports, general,
/// data & sync, and support & legal.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AccountRepository _accountRepository =
      const AccountRepositoryImpl(MockAccountDataSource());
  late final GetAccounts _getAccounts = GetAccounts(_accountRepository);
  List<Account> _accounts = [];

  bool _soundEffectsEnabled = false;
  bool _autoUpdateAppEnabled = true;

  /// Generic bag for every plain on/off preference added in this pass --
  /// avoids ~35 near-identical field declarations for rows that are just
  /// "label + switch" with no other logic behind them (matches how the
  /// rest of this screen's toggles already behave: local, demo-only
  /// state, no persistence).
  final Map<String, bool> _toggles = {
    // Budget Settings
    'budgetRollover': true,
    'autoBudget': false,
    'aiBudgetOptimization': true,
    // Accounts & Wallets
    'lowBalanceAlert': true,
    'hideArchivedAccounts': false,
    // Goals
    'aiGoalRecommendations': true,
    'goalDeadlineReminders': true,
    // Bills & Subscriptions
    'autoDetectSubscriptions': true,
    // Debt
    'aiDebtStrategy': true,
    // Security & Privacy
    'twoFactorAuth': true,
    'pinLock': false,
    'biometricLogin': true,
    'autoLock': true,
    'newDeviceAlerts': true,
    'aiDataUsage': true,
    'analyticsPermission': true,
    // Appearance
    'showBalance': true,
    'showAccountNames': true,
    // Data & Sync
    'cloudSync': true,
    // Notifications
    'pushNotifications': true,
    'emailNotifications': true,
    'notifNewTransaction': true,
    'notifLargeTransaction': true,
    'notifUnusualSpending': true,
    'notifBudgetWarning': true,
    'notifBudgetExceeded': true,
    'notifWeeklySummary': false,
    'notifBillDueSoon': true,
    'notifBillOverdue': true,
    'notifGoalProgress': true,
    'notifGoalMilestone': true,
    'notifAiInsights': true,
    'notifMonthlyAiReport': false,
    // AI Settings
    'aiEnabled': true,
    'aiSpendingAnalysis': true,
    'aiBudgetSuggestions': true,
    'aiSavingsSuggestions': true,
    'aiExpenseCategorization': true,
    'aiTransactionInsights': true,
    'aiFinancialForecast': true,
    'aiAnomalyDetection': true,
    'aiBillSubscriptionDetection': true,
    'aiPersonalizedAlerts': true,
    'aiVoiceAssistant': false,
    // Analytics & Reports
    'emailWeeklyReport': false,
    'emailMonthlyReport': true,
  };

  /// Generic bag for every "tap to pick one of a fixed list" preference.
  final Map<String, String> _pickers = {
    'currency': 'USD (\$)',
    'currencyFormat': 'Symbol before amount',
    'decimalPlaces': '2',
    'defaultAccount': '—',
    'budgetCycle': 'Monthly',
    'weekStartsOn': 'Sunday',
    'financialYear': 'January',
    'exportFormat': 'PDF',
    'paymentReminder': '3 days before',
    'debtStrategy': 'Avalanche (highest interest first)',
    'dateFormat': 'MM/DD/YYYY',
    'timeFormat': '12-hour',
    'adviceFrequency': 'Weekly',
    'insightFrequency': 'Daily',
    'aiTone': 'Friendly',
  };

  @override
  void initState() {
    super.initState();
    _getAccounts().then((accounts) {
      if (!mounted) return;
      setState(() {
        _accounts = accounts;
        if (accounts.isNotEmpty) _pickers['defaultAccount'] = accounts.first.name;
      });
    });
  }

  bool _toggle(String key) => _toggles[key] ?? false;
  void _setToggle(String key, bool value) => setState(() => _toggles[key] = value);

  SettingsTileData _toggleTile({
    required String key,
    required IconData icon,
    required String label,
    String? subtitle,
    required Color bg,
    required Color color,
  }) {
    return SettingsTileData(
      icon: icon,
      label: label,
      subtitle: subtitle,
      showChevron: false,
      iconBgColor: bg,
      iconColor: color,
      trailing: Switch(
        value: _toggle(key),
        onChanged: (v) => _setToggle(key, v),
      ),
      onTap: () => _setToggle(key, !_toggle(key)),
    );
  }

  Future<void> _pick(String key, String title, List<String> options) async {
    final String? selected = await showSettingsOptionSheet<String>(
      context: context,
      title: title,
      options: options,
      selected: _pickers[key]!,
    );
    if (selected != null) setState(() => _pickers[key] = selected);
  }

  /// Renders a [SettingsTileData] as a [ProfileMenuTile] -- the same
  /// mapping [SettingsGroupCard] does internally, needed here for the two
  /// standalone toggle rows in the Appearance section.
  ProfileMenuTile _tile(SettingsTileData data) {
    return ProfileMenuTile(
      icon: data.icon,
      label: data.label,
      subtitle: data.subtitle,
      badgeText: data.badgeText,
      valueText: data.valueText,
      iconBgColor: data.iconBgColor,
      iconColor: data.iconColor,
      textColor: data.textColor,
      showChevron: data.showChevron,
      trailing: data.trailing,
      onTap: data.onTap,
    );
  }

  SettingsTileData _pickerTile({
    required String key,
    required IconData icon,
    required String label,
    String? subtitle,
    required Color bg,
    required Color color,
    required List<String> options,
  }) {
    return SettingsTileData(
      icon: icon,
      label: label,
      subtitle: subtitle,
      valueText: _pickers[key],
      iconBgColor: bg,
      iconColor: color,
      onTap: () => _pick(key, label, options),
    );
  }

  Future<void> _pickFontSize(BuildContext context) async {
    final FontSizeOption? selected = await showSettingsOptionSheet<FontSizeOption>(
      context: context,
      title: AppStrings.fontSizeLabel,
      options: FontSizeOption.values,
      selected: fontScaleNotifier.value,
      labelBuilder: (option) => option.label,
    );
    if (selected != null) fontScaleNotifier.value = selected;
  }

  void _clearCache(BuildContext context) {
    context.showSnackBar(AppStrings.clearCacheSuccessMessage);
  }

  Future<void> _exportMyData(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.exportDataConfirmTitle),
        content: const Text(AppStrings.exportDataConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(AppStrings.confirm),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.showSnackBar(AppStrings.exportDataRequestedMessage);
    }
  }

  void _backupNow(BuildContext context) {
    context.showSnackBar('Backup started -- this may take a moment.');
  }

  void _confirmResetSettings(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.resetAllSettingsLabel),
        content: const Text(AppStrings.resetAllSettingsConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              setState(() {
                _soundEffectsEnabled = false;
                _autoUpdateAppEnabled = true;
                for (final key in _toggles.keys) {
                  _toggles[key] = true;
                }
              });
              fontScaleNotifier.value = FontSizeOption.medium;
              context.showSnackBar(AppStrings.settingsResetSuccessMessage);
            },
            child: const Text(AppStrings.confirm),
          ),
        ],
      ),
    );
  }

  // ── Section builders ────────────────────────────────────────────────────

  Widget _buildAppearanceSection(ResponsiveHelper responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionHeader(title: AppStrings.appearanceSectionTitle),
        SizedBox(height: responsive.spacing(AppSpacing.sm)),
        ValueListenableBuilder<ThemeMode>(
          valueListenable: themeModeNotifier,
          builder: (context, mode, _) {
            return ThemeModeSelector(
              mode: mode,
              onChanged: (newMode) => themeModeNotifier.value = newMode,
            );
          },
        ),
        SizedBox(height: responsive.spacing(AppSpacing.sm)),
        AppCard(
          padding: EdgeInsets.symmetric(vertical: responsive.spacing(AppSpacing.xs)),
          child: Column(
            children: [
              _tile(_toggleTile(
                key: 'showBalance',
                icon: Icons.visibility_outlined,
                label: 'Show Account Balances',
                bg: AppColors.tileTealBg,
                color: AppColors.tileTealIcon,
              )),
              const Divider(),
              _tile(_toggleTile(
                key: 'showAccountNames',
                icon: Icons.badge_outlined,
                label: 'Show Account Names',
                bg: AppColors.tileIndigoBg,
                color: AppColors.tileIndigoIcon,
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStorageTile(ResponsiveHelper responsive, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.spacing(AppSpacing.sm),
        vertical: responsive.spacing(AppSpacing.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: responsive.width(36),
                height: responsive.width(36),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? AppColors.tileDarkContainer
                      : AppColors.tileIndigoBg,
                  borderRadius:
                      BorderRadius.circular(responsive.radius(AppRadius.sm)),
                ),
                child: Center(
                  child: Icon(
                    Icons.sd_storage_outlined,
                    size: responsive.iconSize(18),
                    color: AppColors.tileIndigoIcon,
                  ),
                ),
              ),
              SizedBox(width: responsive.spacing(AppSpacing.md)),
              Expanded(
                child: Text(
                  AppStrings.storageUsageLabel,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                AppStrings.storageUsageValue,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.spacing(AppSpacing.xs)),
          Padding(
            padding: EdgeInsets.only(left: responsive.width(48)),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(responsive.radius(AppRadius.pill)),
              child: LinearProgressIndicator(
                value: 0.38,
                minHeight: 4,
                backgroundColor: theme.brightness == Brightness.dark
                    ? AppColors.white.withValues(alpha: 0.12)
                    : AppColors.black.withValues(alpha: 0.12),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.progressIndigo,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralSection(
    BuildContext context,
    ResponsiveHelper responsive,
    ThemeData theme,
    FontSizeOption fontSize,
  ) {
    final generalItems = [
      SettingsTileData(
        icon: Icons.language_rounded,
        label: AppStrings.languageLabel,
        valueText: 'English',
        showChevron: false,
        iconBgColor: AppColors.tileSkyBg,
        iconColor: AppColors.tileSkyIcon,
        onTap: () {},
      ),
      _pickerTile(
        key: 'dateFormat',
        icon: Icons.calendar_today_outlined,
        label: 'Date Format',
        bg: AppColors.tileAmberBg,
        color: AppColors.tileAmberIcon,
        options: const ['MM/DD/YYYY', 'DD/MM/YYYY', 'YYYY-MM-DD'],
      ),
      _pickerTile(
        key: 'timeFormat',
        icon: Icons.schedule_outlined,
        label: 'Time Format',
        bg: AppColors.tileSkyBg,
        color: AppColors.tileSkyIcon,
        options: const ['12-hour', '24-hour'],
      ),
      SettingsTileData(
        icon: Icons.format_size_rounded,
        label: AppStrings.fontSizeLabel,
        valueText: fontSize.label,
        iconBgColor: AppColors.tilePurpleBg,
        iconColor: AppColors.tilePurpleIcon,
        onTap: () => _pickFontSize(context),
      ),
      SettingsTileData(
        icon: Icons.volume_up_outlined,
        label: AppStrings.soundEffectsLabel,
        showChevron: false,
        iconBgColor: AppColors.tileSkyBg,
        iconColor: AppColors.tileSkyIcon,
        trailing: Switch(
          value: _soundEffectsEnabled,
          onChanged: (val) => setState(() => _soundEffectsEnabled = val),
        ),
        onTap: () => setState(() => _soundEffectsEnabled = !_soundEffectsEnabled),
      ),
      SettingsTileData(
        icon: Icons.system_update_rounded,
        label: AppStrings.autoUpdateAppLabel,
        showChevron: false,
        iconBgColor: AppColors.tileBlueBg,
        iconColor: AppColors.tileBlueIcon,
        trailing: Switch(
          value: _autoUpdateAppEnabled,
          onChanged: (val) => setState(() => _autoUpdateAppEnabled = val),
        ),
        onTap: () => setState(() => _autoUpdateAppEnabled = !_autoUpdateAppEnabled),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionHeader(title: AppStrings.generalSectionTitle),
        SizedBox(height: responsive.spacing(AppSpacing.xs)),
        AppCard(
          padding: EdgeInsets.symmetric(vertical: responsive.spacing(AppSpacing.xs)),
          child: Column(
            children: [
              for (final item in generalItems) ...[
                _tile(item),
                const Divider(),
              ],
              _buildStorageTile(responsive, theme),
              const Divider(),
              ProfileMenuTile(
                icon: Icons.delete_outline_rounded,
                label: AppStrings.clearCacheLabel,
                iconBgColor: AppColors.tileSlateBg,
                iconColor: AppColors.tileSlateIcon,
                onTap: () => _clearCache(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<SettingsGroupCard> _buildSettingGroups(BuildContext context) {
    return [
      // ── Finance Preferences ──────────────────────────────────────────
      SettingsGroupCard(
        title: 'Finance Preferences',
        items: [
          _pickerTile(
            key: 'currency',
            icon: Icons.attach_money_rounded,
            label: 'Default Currency',
            bg: AppColors.tileGreenBg,
            color: AppColors.tileGreenIcon,
            options: const ['USD (\$)', 'EUR (€)', 'GBP (£)', 'BDT (৳)', 'INR (₹)'],
          ),
          _pickerTile(
            key: 'currencyFormat',
            icon: Icons.text_format_rounded,
            label: 'Currency Format',
            bg: AppColors.tileTealBg,
            color: AppColors.tileTealIcon,
            options: const ['Symbol before amount', 'Symbol after amount'],
          ),
          _pickerTile(
            key: 'decimalPlaces',
            icon: Icons.pin_outlined,
            label: 'Decimal Places',
            bg: AppColors.tileSkyBg,
            color: AppColors.tileSkyIcon,
            options: const ['0', '2'],
          ),
          _pickerTile(
            key: 'defaultAccount',
            icon: Icons.account_balance_wallet_outlined,
            label: 'Default Account',
            bg: AppColors.tileBlueBg,
            color: AppColors.tileBlueIcon,
            options: _accounts.isEmpty
                ? [_pickers['defaultAccount']!]
                : _accounts.map((a) => a.name).toList(),
          ),
          _pickerTile(
            key: 'budgetCycle',
            icon: Icons.event_repeat_rounded,
            label: 'Budget Cycle',
            bg: AppColors.tileAmberBg,
            color: AppColors.tileAmberIcon,
            options: const ['Weekly', 'Monthly'],
          ),
          _pickerTile(
            key: 'weekStartsOn',
            icon: Icons.view_week_outlined,
            label: 'Week Starts On',
            bg: AppColors.tilePurpleBg,
            color: AppColors.tilePurpleIcon,
            options: const ['Sunday', 'Monday'],
          ),
          _pickerTile(
            key: 'financialYear',
            icon: Icons.calendar_month_outlined,
            label: 'Financial Year Starts',
            bg: AppColors.tileIndigoBg,
            color: AppColors.tileIndigoIcon,
            options: const ['January', 'April', 'July', 'October'],
          ),
        ],
      ),

      // ── AI Settings (the big one) ────────────────────────────────────
      SettingsGroupCard(
        title: 'AI Settings',
        items: [
          _toggleTile(
            key: 'aiEnabled',
            icon: Icons.auto_awesome_rounded,
            label: 'Enable AI Features',
            subtitle: 'Master switch for every AI feature below.',
            bg: AppColors.tileTealBg,
            color: AppColors.tileTealIcon,
          ),
          _toggleTile(
            key: 'aiSpendingAnalysis',
            icon: Icons.insights_rounded,
            label: 'AI Spending Analysis',
            bg: AppColors.tileSkyBg,
            color: AppColors.tileSkyIcon,
          ),
          _toggleTile(
            key: 'aiBudgetSuggestions',
            icon: Icons.pie_chart_outline_rounded,
            label: 'AI Budget Suggestions',
            bg: AppColors.tileGreenBg,
            color: AppColors.tileGreenIcon,
          ),
          _toggleTile(
            key: 'aiSavingsSuggestions',
            icon: Icons.savings_outlined,
            label: 'AI Savings Suggestions',
            bg: AppColors.tileAmberBg,
            color: AppColors.tileAmberIcon,
          ),
          _toggleTile(
            key: 'aiExpenseCategorization',
            icon: Icons.label_outline_rounded,
            label: 'AI Expense Categorization',
            bg: AppColors.tilePurpleBg,
            color: AppColors.tilePurpleIcon,
          ),
          _toggleTile(
            key: 'aiTransactionInsights',
            icon: Icons.receipt_long_outlined,
            label: 'AI Transaction Insights',
            bg: AppColors.tileIndigoBg,
            color: AppColors.tileIndigoIcon,
          ),
          _toggleTile(
            key: 'aiFinancialForecast',
            icon: Icons.trending_up_rounded,
            label: 'AI Financial Forecast',
            bg: AppColors.tileBlueBg,
            color: AppColors.tileBlueIcon,
          ),
          _toggleTile(
            key: 'aiAnomalyDetection',
            icon: Icons.warning_amber_rounded,
            label: 'AI Anomaly Detection',
            subtitle: 'Flag unusual spending as soon as it happens.',
            bg: AppColors.tileOrangeBg,
            color: AppColors.tileOrangeIcon,
          ),
          _toggleTile(
            key: 'aiBillSubscriptionDetection',
            icon: Icons.subscriptions_outlined,
            label: 'AI Bill & Subscription Detection',
            bg: AppColors.tilePinkBg,
            color: AppColors.tilePinkIcon,
          ),
          _toggleTile(
            key: 'aiPersonalizedAlerts',
            icon: Icons.notifications_active_outlined,
            label: 'AI Personalized Alerts',
            bg: AppColors.tileRedBg,
            color: AppColors.tileRedIcon,
          ),
          _toggleTile(
            key: 'aiVoiceAssistant',
            icon: Icons.mic_none_rounded,
            label: 'AI Voice Assistant',
            bg: AppColors.tileSlateBg,
            color: AppColors.tileSlateIcon,
          ),
          _pickerTile(
            key: 'adviceFrequency',
            icon: Icons.event_note_outlined,
            label: 'Advice Frequency',
            bg: AppColors.tileTealBg,
            color: AppColors.tileTealIcon,
            options: const ['Daily', 'Weekly', 'Monthly'],
          ),
          _pickerTile(
            key: 'insightFrequency',
            icon: Icons.update_rounded,
            label: 'Insight Frequency',
            bg: AppColors.tileSkyBg,
            color: AppColors.tileSkyIcon,
            options: const ['Real-time', 'Daily', 'Weekly'],
          ),
          _pickerTile(
            key: 'aiTone',
            icon: Icons.forum_outlined,
            label: 'AI Tone',
            bg: AppColors.tilePurpleBg,
            color: AppColors.tilePurpleIcon,
            options: const ['Friendly', 'Professional', 'Concise'],
          ),
        ],
      ),

      // ── Notifications ─────────────────────────────────────────────────
      SettingsGroupCard(
        title: AppStrings.notificationsSectionTitle,
        items: [
          _toggleTile(
            key: 'pushNotifications',
            icon: Icons.notifications_none_rounded,
            label: AppStrings.pushNotificationsLabel,
            subtitle: AppStrings.pushNotificationsDescription,
            bg: AppColors.tileAmberBg,
            color: AppColors.tileAmberIcon,
          ),
          _toggleTile(
            key: 'emailNotifications',
            icon: Icons.mail_outline_rounded,
            label: AppStrings.emailNotificationsLabel,
            subtitle: AppStrings.emailNotificationsDescription,
            bg: AppColors.tilePurpleBg,
            color: AppColors.tilePurpleIcon,
          ),
        ],
      ),
      SettingsGroupCard(
        title: 'Transaction Notifications',
        items: [
          _toggleTile(
            key: 'notifNewTransaction',
            icon: Icons.swap_horiz_rounded,
            label: 'New Transaction',
            bg: AppColors.tileTealBg,
            color: AppColors.tileTealIcon,
          ),
          _toggleTile(
            key: 'notifLargeTransaction',
            icon: Icons.trending_up_rounded,
            label: 'Large Transaction',
            bg: AppColors.tileBlueBg,
            color: AppColors.tileBlueIcon,
          ),
          _toggleTile(
            key: 'notifUnusualSpending',
            icon: Icons.warning_amber_rounded,
            label: 'Unusual Spending',
            bg: AppColors.tileOrangeBg,
            color: AppColors.tileOrangeIcon,
          ),
        ],
      ),
      SettingsGroupCard(
        title: 'Budget Notifications',
        items: [
          _toggleTile(
            key: 'notifBudgetWarning',
            icon: Icons.speed_rounded,
            label: 'Budget Warning',
            bg: AppColors.tileAmberBg,
            color: AppColors.tileAmberIcon,
          ),
          _toggleTile(
            key: 'notifBudgetExceeded',
            icon: Icons.error_outline_rounded,
            label: 'Budget Exceeded',
            bg: AppColors.tileRedBg,
            color: AppColors.tileRedIcon,
          ),
          _toggleTile(
            key: 'notifWeeklySummary',
            icon: Icons.summarize_outlined,
            label: 'Weekly Spending Summary',
            bg: AppColors.tileIndigoBg,
            color: AppColors.tileIndigoIcon,
          ),
        ],
      ),
      SettingsGroupCard(
        title: 'Bill Notifications',
        items: [
          _toggleTile(
            key: 'notifBillDueSoon',
            icon: Icons.schedule_outlined,
            label: 'Bill Due Soon',
            bg: AppColors.tileSkyBg,
            color: AppColors.tileSkyIcon,
          ),
          _toggleTile(
            key: 'notifBillOverdue',
            icon: Icons.event_busy_outlined,
            label: 'Bill Overdue',
            bg: AppColors.tileRedBg,
            color: AppColors.tileRedIcon,
          ),
        ],
      ),
      SettingsGroupCard(
        title: 'Savings Notifications',
        items: [
          _toggleTile(
            key: 'notifGoalProgress',
            icon: Icons.flag_outlined,
            label: 'Goal Progress',
            bg: AppColors.tileGreenBg,
            color: AppColors.tileGreenIcon,
          ),
          _toggleTile(
            key: 'notifGoalMilestone',
            icon: Icons.emoji_events_outlined,
            label: 'Goal Milestone',
            bg: AppColors.tileTealBg,
            color: AppColors.tileTealIcon,
          ),
        ],
      ),
      SettingsGroupCard(
        title: 'AI Notifications',
        items: [
          _toggleTile(
            key: 'notifAiInsights',
            icon: Icons.lightbulb_outline_rounded,
            label: 'AI Insights',
            bg: AppColors.tilePurpleBg,
            color: AppColors.tilePurpleIcon,
          ),
          _toggleTile(
            key: 'notifMonthlyAiReport',
            icon: Icons.assessment_outlined,
            label: 'Monthly AI Report',
            bg: AppColors.tileIndigoBg,
            color: AppColors.tileIndigoIcon,
          ),
        ],
      ),

      // ── Budget Settings ───────────────────────────────────────────────
      SettingsGroupCard(
        title: 'Budget Settings',
        items: [
          _toggleTile(
            key: 'budgetRollover',
            icon: Icons.autorenew_rounded,
            label: 'Budget Rollover',
            subtitle: 'Carry unspent budget into next period.',
            bg: AppColors.tileGreenBg,
            color: AppColors.tileGreenIcon,
          ),
          _toggleTile(
            key: 'autoBudget',
            icon: Icons.auto_fix_high_rounded,
            label: 'Auto Budget',
            subtitle: 'Let AI set your category budgets automatically.',
            bg: AppColors.tileAmberBg,
            color: AppColors.tileAmberIcon,
          ),
          _toggleTile(
            key: 'aiBudgetOptimization',
            icon: Icons.tune_rounded,
            label: 'AI Budget Optimization',
            bg: AppColors.tileTealBg,
            color: AppColors.tileTealIcon,
          ),
        ],
      ),

      // ── Accounts & Wallets ────────────────────────────────────────────
      SettingsGroupCard(
        title: 'Accounts & Wallets',
        items: [
          _toggleTile(
            key: 'lowBalanceAlert',
            icon: Icons.account_balance_wallet_outlined,
            label: 'Low Balance Alert',
            bg: AppColors.tileRedBg,
            color: AppColors.tileRedIcon,
          ),
          _toggleTile(
            key: 'hideArchivedAccounts',
            icon: Icons.visibility_off_outlined,
            label: 'Hide Archived Accounts',
            bg: AppColors.tileSlateBg,
            color: AppColors.tileSlateIcon,
          ),
        ],
      ),

      // ── Goals ────────────────────────────────────────────────────────
      SettingsGroupCard(
        title: 'Goals',
        items: [
          _toggleTile(
            key: 'aiGoalRecommendations',
            icon: Icons.flag_outlined,
            label: 'AI Goal Recommendations',
            bg: AppColors.tileGreenBg,
            color: AppColors.tileGreenIcon,
          ),
          _toggleTile(
            key: 'goalDeadlineReminders',
            icon: Icons.alarm_outlined,
            label: 'Goal Deadline Reminders',
            bg: AppColors.tileTealBg,
            color: AppColors.tileTealIcon,
          ),
        ],
      ),

      // ── Bills & Subscriptions ─────────────────────────────────────────
      SettingsGroupCard(
        title: 'Bills & Subscriptions',
        items: [
          _toggleTile(
            key: 'autoDetectSubscriptions',
            icon: Icons.subscriptions_outlined,
            label: 'Auto-detect Subscriptions',
            subtitle: 'Let AI scan transactions for recurring charges.',
            bg: AppColors.tileIndigoBg,
            color: AppColors.tileIndigoIcon,
          ),
          _pickerTile(
            key: 'paymentReminder',
            icon: Icons.notifications_active_outlined,
            label: 'Payment Reminder',
            bg: AppColors.tileAmberBg,
            color: AppColors.tileAmberIcon,
            options: const ['1 day before', '3 days before', '7 days before'],
          ),
        ],
      ),

      // ── Debt ─────────────────────────────────────────────────────────
      SettingsGroupCard(
        title: 'Debt',
        items: [
          _pickerTile(
            key: 'debtStrategy',
            icon: Icons.credit_score_outlined,
            label: 'Debt Payoff Strategy',
            bg: AppColors.tileRedBg,
            color: AppColors.tileRedIcon,
            options: const [
              'Avalanche (highest interest first)',
              'Snowball (smallest balance first)',
            ],
          ),
          _toggleTile(
            key: 'aiDebtStrategy',
            icon: Icons.auto_awesome_rounded,
            label: 'AI Debt Strategy',
            bg: AppColors.tileTealBg,
            color: AppColors.tileTealIcon,
          ),
        ],
      ),

      // ── Security & Privacy ────────────────────────────────────────────
      SettingsGroupCard(
        title: AppStrings.securitySectionTitle,
        items: [
          _toggleTile(
            key: 'twoFactorAuth',
            icon: Icons.security_rounded,
            label: AppStrings.twoFactorAuthLabel,
            bg: AppColors.tileGreenBg,
            color: AppColors.tileGreenIcon,
          ),
          _toggleTile(
            key: 'pinLock',
            icon: Icons.pin_outlined,
            label: 'PIN Lock',
            bg: AppColors.tileIndigoBg,
            color: AppColors.tileIndigoIcon,
          ),
          _toggleTile(
            key: 'biometricLogin',
            icon: Icons.fingerprint_rounded,
            label: 'Biometric Login',
            bg: AppColors.tileSkyBg,
            color: AppColors.tileSkyIcon,
          ),
          _toggleTile(
            key: 'autoLock',
            icon: Icons.lock_clock_outlined,
            label: 'Auto-Lock',
            bg: AppColors.tilePurpleBg,
            color: AppColors.tilePurpleIcon,
          ),
          _toggleTile(
            key: 'newDeviceAlerts',
            icon: Icons.phonelink_lock_outlined,
            label: 'New Device Alerts',
            bg: AppColors.tileAmberBg,
            color: AppColors.tileAmberIcon,
          ),
          SettingsTileData(
            icon: Icons.devices_rounded,
            label: AppStrings.activeSessionsLabel,
            subtitle: AppStrings.activeSessionsSubtitle,
            iconBgColor: AppColors.tileBlueBg,
            iconColor: AppColors.tileBlueIcon,
            onTap: () => context.push(AppRoutes.settingsSessions),
          ),
          _toggleTile(
            key: 'aiDataUsage',
            icon: Icons.privacy_tip_outlined,
            label: 'AI Data Usage',
            subtitle: 'Allow AI to analyze your financial data.',
            bg: AppColors.tileTealBg,
            color: AppColors.tileTealIcon,
          ),
          _toggleTile(
            key: 'analyticsPermission',
            icon: Icons.query_stats_rounded,
            label: 'Analytics Permission',
            bg: AppColors.tileSlateBg,
            color: AppColors.tileSlateIcon,
          ),
        ],
      ),

      // ── Analytics & Reports ───────────────────────────────────────────
      SettingsGroupCard(
        title: 'Analytics & Reports',
        items: [
          _pickerTile(
            key: 'exportFormat',
            icon: Icons.file_download_outlined,
            label: 'Export Format',
            bg: AppColors.tileIndigoBg,
            color: AppColors.tileIndigoIcon,
            options: const ['PDF', 'CSV', 'Excel'],
          ),
          _toggleTile(
            key: 'emailWeeklyReport',
            icon: Icons.mail_outline_rounded,
            label: 'Email Weekly Report',
            bg: AppColors.tileSkyBg,
            color: AppColors.tileSkyIcon,
          ),
          _toggleTile(
            key: 'emailMonthlyReport',
            icon: Icons.mail_outline_rounded,
            label: 'Email Monthly Report',
            bg: AppColors.tileSkyBg,
            color: AppColors.tileSkyIcon,
          ),
        ],
      ),

      // ── Data & Sync ───────────────────────────────────────────────────
      SettingsGroupCard(
        title: 'Data & Sync',
        items: [
          _toggleTile(
            key: 'cloudSync',
            icon: Icons.cloud_outlined,
            label: 'Cloud Sync',
            bg: AppColors.tileBlueBg,
            color: AppColors.tileBlueIcon,
          ),
          SettingsTileData(
            icon: Icons.backup_outlined,
            label: 'Backup Now',
            subtitle: 'Last backup: never',
            iconBgColor: AppColors.tileTealBg,
            iconColor: AppColors.tileTealIcon,
            onTap: () => _backupNow(context),
          ),
          SettingsTileData(
            icon: Icons.download_rounded,
            label: AppStrings.exportMyDataLabel,
            iconBgColor: AppColors.tilePurpleBg,
            iconColor: AppColors.tilePurpleIcon,
            onTap: () => _exportMyData(context),
          ),
          SettingsTileData(
            icon: Icons.restart_alt_rounded,
            label: AppStrings.resetAllSettingsLabel,
            iconBgColor: AppColors.tileBlueBg,
            iconColor: AppColors.tileBlueIcon,
            onTap: () => _confirmResetSettings(context),
          ),
        ],
      ),

      // ── Support & Legal ───────────────────────────────────────────────
      SettingsGroupCard(
        title: AppStrings.supportLegalSectionTitle,
        items: [
          SettingsTileData(
            icon: Icons.chat_bubble_outline_rounded,
            label: AppStrings.sendFeedbackLabel,
            iconBgColor: AppColors.tilePurpleBg,
            iconColor: AppColors.tilePurpleIcon,
            onTap: () => showFeedbackSheet(context),
          ),
          SettingsTileData(
            icon: Icons.info_outline_rounded,
            label: AppStrings.aboutAppLabel,
            iconBgColor: AppColors.tileSkyBg,
            iconColor: AppColors.tileSkyIcon,
            onTap: () => context.push(AppRoutes.settingsAbout),
          ),
          SettingsTileData(
            icon: Icons.description_outlined,
            label: AppStrings.termsOfServiceLabel,
            iconBgColor: AppColors.tileIndigoBg,
            iconColor: AppColors.tileIndigoIcon,
            onTap: () => context.push(AppRoutes.settingsTerms),
          ),
          SettingsTileData(
            icon: Icons.lock_outline_rounded,
            label: AppStrings.privacyPolicyLabel,
            iconBgColor: AppColors.tileAmberBg,
            iconColor: AppColors.tileAmberIcon,
            onTap: () => context.push(AppRoutes.settingsPrivacy),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    final groups = _buildSettingGroups(context);

    return Scaffold(
      appBar: const AppAppBar(title: AppStrings.settingsScreenTitle),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(responsive.spacing(AppSpacing.xxl)),
          children: [
            _buildAppearanceSection(responsive),
            for (final group in groups) ...[
              SizedBox(height: responsive.spacing(AppSpacing.xl)),
              group,
            ],
            SizedBox(height: responsive.spacing(AppSpacing.xl)),
            ValueListenableBuilder<FontSizeOption>(
              valueListenable: fontScaleNotifier,
              builder: (context, fontSize, _) {
                return _buildGeneralSection(context, responsive, theme, fontSize);
              },
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xxl)),
            Center(
              child: Text(
                AppStrings.buildVersionText,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
