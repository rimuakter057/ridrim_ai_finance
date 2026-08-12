import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../settings/presentation/widgets/settings_group_card.dart';

class _AiToggle {
  _AiToggle(this.icon, this.label, this.color, this.bgColor);

  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  bool value = true;
}

/// AI personalization toggles shown on the Profile screen -- what the AI
/// assistant is allowed to do with this user's data. The deeper AI
/// feature-by-feature controls live in Settings > AI Settings.
class AiProfileSection extends StatefulWidget {
  const AiProfileSection({super.key});

  @override
  State<AiProfileSection> createState() => _AiProfileSectionState();
}

class _AiProfileSectionState extends State<AiProfileSection> {
  final List<_AiToggle> _toggles = [
    _AiToggle(
      Icons.support_agent_rounded,
      'AI Financial Coach',
      AppColors.tileTealIcon,
      AppColors.tileTealBg,
    ),
    _AiToggle(
      Icons.tune_rounded,
      'AI Personalization',
      AppColors.tilePurpleIcon,
      AppColors.tilePurpleBg,
    ),
    _AiToggle(
      Icons.insights_rounded,
      'AI Spending Insights',
      AppColors.tileSkyIcon,
      AppColors.tileSkyBg,
    ),
    _AiToggle(
      Icons.pie_chart_outline_rounded,
      'AI Budget Recommendations',
      AppColors.tileGreenIcon,
      AppColors.tileGreenBg,
    ),
    _AiToggle(
      Icons.savings_outlined,
      'AI Savings Recommendations',
      AppColors.tileAmberIcon,
      AppColors.tileAmberBg,
    ),
    _AiToggle(
      Icons.summarize_outlined,
      'AI Financial Reports',
      AppColors.tileIndigoIcon,
      AppColors.tileIndigoBg,
    ),
    _AiToggle(
      Icons.trending_up_rounded,
      'AI Forecasting',
      AppColors.tileBlueIcon,
      AppColors.tileBlueBg,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SettingsGroupCard(
      title: 'AI Profile',
      items: [
        for (final toggle in _toggles)
          SettingsTileData(
            icon: toggle.icon,
            label: toggle.label,
            showChevron: false,
            iconBgColor: toggle.bgColor,
            iconColor: toggle.color,
            trailing: Switch(
              value: toggle.value,
              onChanged: (v) => setState(() => toggle.value = v),
            ),
            onTap: () => setState(() => toggle.value = !toggle.value),
          ),
      ],
    );
  }
}
