import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../../settings/presentation/widgets/settings_group_card.dart';
import '../../../settings/presentation/widgets/settings_option_sheet.dart';
import '../../../settings/presentation/widgets/text_input_sheet.dart';

const List<String> _incomeSources = [
  'Salary', 'Business', 'Freelance', 'Investments', 'Other',
];
const List<String> _employmentTypes = [
  'Full-time', 'Part-time', 'Self-employed', 'Unemployed', 'Retired', 'Student',
];
const List<String> _financialGoals = [
  'Build an emergency fund',
  'Pay off debt',
  'Save for a home',
  'Save for retirement',
  'Grow investments',
  'Save for a big purchase',
];
const List<String> _riskPreferences = ['Conservative', 'Balanced', 'Growth'];
const List<String> _experienceLevels = ['Beginner', 'Intermediate', 'Advanced'];

/// User-editable financial preferences: income, goals, targets, and risk
/// profile -- feeds the AI assistant's personalization (see
/// [AiProfileSection]).
class FinancialProfileSection extends StatefulWidget {
  const FinancialProfileSection({super.key});

  @override
  State<FinancialProfileSection> createState() =>
      _FinancialProfileSectionState();
}

class _FinancialProfileSectionState extends State<FinancialProfileSection> {
  double _monthlyIncome = 6400;
  String _incomeSource = 'Salary';
  String _employmentType = 'Full-time';
  String _financialGoal = 'Build an emergency fund';
  double _savingTarget = 15000;
  double _monthlySavingTarget = 800;
  double _spendingLimit = 3000;
  String _riskPreference = 'Balanced';
  String _experienceLevel = 'Intermediate';

  Future<void> _editAmount({
    required String title,
    required double current,
    required ValueChanged<double> onSaved,
  }) async {
    final String? result = await showTextInputSheet(
      context: context,
      title: title,
      initialValue: current.toStringAsFixed(0),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      prefixText: '\$',
    );
    final double? parsed = double.tryParse(result ?? '');
    if (parsed != null && parsed >= 0) {
      setState(() => onSaved(parsed));
    }
  }

  Future<void> _editOption({
    required String title,
    required String current,
    required List<String> options,
    required ValueChanged<String> onSaved,
  }) async {
    final String? selected = await showSettingsOptionSheet<String>(
      context: context,
      title: title,
      options: options,
      selected: current,
    );
    if (selected != null) setState(() => onSaved(selected));
  }

  @override
  Widget build(BuildContext context) {
    return SettingsGroupCard(
      title: 'Financial Profile',
      items: [
        SettingsTileData(
          icon: Icons.payments_outlined,
          label: 'Monthly Income',
          valueText: AppHelpers.formatCurrency(_monthlyIncome),
          iconBgColor: AppColors.tileGreenBg,
          iconColor: AppColors.tileGreenIcon,
          onTap: () => _editAmount(
            title: 'Monthly Income',
            current: _monthlyIncome,
            onSaved: (v) => _monthlyIncome = v,
          ),
        ),
        SettingsTileData(
          icon: Icons.work_outline_rounded,
          label: 'Income Source',
          valueText: _incomeSource,
          iconBgColor: AppColors.tileSkyBg,
          iconColor: AppColors.tileSkyIcon,
          onTap: () => _editOption(
            title: 'Income Source',
            current: _incomeSource,
            options: _incomeSources,
            onSaved: (v) => _incomeSource = v,
          ),
        ),
        SettingsTileData(
          icon: Icons.badge_outlined,
          label: 'Employment Type',
          valueText: _employmentType,
          iconBgColor: AppColors.tileIndigoBg,
          iconColor: AppColors.tileIndigoIcon,
          onTap: () => _editOption(
            title: 'Employment Type',
            current: _employmentType,
            options: _employmentTypes,
            onSaved: (v) => _employmentType = v,
          ),
        ),
        SettingsTileData(
          icon: Icons.flag_outlined,
          label: 'Financial Goal',
          valueText: _financialGoal,
          iconBgColor: AppColors.tilePurpleBg,
          iconColor: AppColors.tilePurpleIcon,
          onTap: () => _editOption(
            title: 'Financial Goal',
            current: _financialGoal,
            options: _financialGoals,
            onSaved: (v) => _financialGoal = v,
          ),
        ),
        SettingsTileData(
          icon: Icons.savings_outlined,
          label: 'Saving Target',
          valueText: AppHelpers.formatCurrency(_savingTarget),
          iconBgColor: AppColors.tileTealBg,
          iconColor: AppColors.tileTealIcon,
          onTap: () => _editAmount(
            title: 'Saving Target',
            current: _savingTarget,
            onSaved: (v) => _savingTarget = v,
          ),
        ),
        SettingsTileData(
          icon: Icons.calendar_month_outlined,
          label: 'Monthly Saving Target',
          valueText: AppHelpers.formatCurrency(_monthlySavingTarget),
          iconBgColor: AppColors.tileTealBg,
          iconColor: AppColors.tileTealIcon,
          onTap: () => _editAmount(
            title: 'Monthly Saving Target',
            current: _monthlySavingTarget,
            onSaved: (v) => _monthlySavingTarget = v,
          ),
        ),
        SettingsTileData(
          icon: Icons.speed_rounded,
          label: 'Preferred Spending Limit',
          valueText: '${AppHelpers.formatCurrency(_spendingLimit)}/mo',
          iconBgColor: AppColors.tileAmberBg,
          iconColor: AppColors.tileAmberIcon,
          onTap: () => _editAmount(
            title: 'Preferred Spending Limit',
            current: _spendingLimit,
            onSaved: (v) => _spendingLimit = v,
          ),
        ),
        SettingsTileData(
          icon: Icons.shield_moon_outlined,
          label: 'Risk Preference',
          valueText: _riskPreference,
          iconBgColor: AppColors.tileBlueBg,
          iconColor: AppColors.tileBlueIcon,
          onTap: () => _editOption(
            title: 'Risk Preference',
            current: _riskPreference,
            options: _riskPreferences,
            onSaved: (v) => _riskPreference = v,
          ),
        ),
        SettingsTileData(
          icon: Icons.school_outlined,
          label: 'Financial Experience',
          valueText: _experienceLevel,
          iconBgColor: AppColors.tileRoseIcon,
          iconColor: AppColors.tileRoseIcon,
          onTap: () => _editOption(
            title: 'Financial Experience Level',
            current: _experienceLevel,
            options: _experienceLevels,
            onSaved: (v) => _experienceLevel = v,
          ),
        ),
      ],
    );
  }
}
