import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../profile/presentation/widgets/profile_menu_tile.dart';
import 'settings_section_header.dart';

/// Data model representing a single setting/profile tile item.
class SettingsTileData {
  const SettingsTileData({
    required this.icon,
    required this.label,
    this.subtitle,
    this.badgeText,
    this.valueText,
    required this.iconBgColor,
    required this.iconColor,
    this.textColor,
    this.showChevron = true,
    this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final String? badgeText;
  final String? valueText;
  final Color iconBgColor;
  final Color iconColor;
  final Color? textColor;
  final bool showChevron;
  final Widget? trailing;
  final VoidCallback onTap;
}

/// Reusable card component displaying an optional section title and a list
/// of setting tiles separated by dividers.
class SettingsGroupCard extends StatelessWidget {
  const SettingsGroupCard({
    super.key,
    this.title,
    required this.items,
  });

  final String? title;
  final List<SettingsTileData> items;

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) ...[
          SettingsSectionHeader(title: title!),
          SizedBox(height: responsive.spacing(AppSpacing.xs)),
        ],
        AppCard(
          padding: EdgeInsets.symmetric(
            vertical: responsive.spacing(AppSpacing.xs),
          ),
          child: Column(
            children: [
              for (int i = 0; i < items.length; i++) ...[
                if (i > 0) const Divider(),
                ProfileMenuTile(
                  icon: items[i].icon,
                  label: items[i].label,
                  subtitle: items[i].subtitle,
                  badgeText: items[i].badgeText,
                  valueText: items[i].valueText,
                  iconBgColor: items[i].iconBgColor,
                  iconColor: items[i].iconColor,
                  textColor: items[i].textColor,
                  showChevron: items[i].showChevron,
                  trailing: items[i].trailing,
                  onTap: items[i].onTap,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
