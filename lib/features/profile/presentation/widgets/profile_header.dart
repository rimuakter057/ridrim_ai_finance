import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../domain/entities/user_profile.dart';

/// Displays the user's avatar, name, username, contact details, account
/// type, and how long they've been a member.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.profile});

  final UserProfile profile;

  String get _memberSince {
    final int days = DateTime.now().difference(profile.joinedAt).inDays;
    if (days < 30) return '$days days';
    final int months = (days / 30).floor();
    if (months < 12) return '$months month${months == 1 ? '' : 's'}';
    final int years = (months / 12).floor();
    return '$years year${years == 1 ? '' : 's'}';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: responsive.width(40),
            backgroundColor: AppColors.avatarPurple,
            child: Text(
              profile.name.initials(),
              style: theme.textTheme.headlineMedium?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: responsive.spacing(AppSpacing.md)),
          Text(
            profile.name,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '@${profile.username}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: responsive.spacing(AppSpacing.xs)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_rounded,
                size: 14,
                color: AppColors.verifiedBlue,
              ),
              const SizedBox(width: 4),
              Text(
                AppStrings.verifiedAccount,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.verifiedBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.spacing(AppSpacing.lg)),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: responsive.spacing(AppSpacing.md),
            runSpacing: responsive.spacing(AppSpacing.xs),
            children: [
              _InfoChip(icon: Icons.mail_outline_rounded, label: profile.email),
              _InfoChip(icon: Icons.call_outlined, label: profile.phone),
              _InfoChip(
                icon: Icons.badge_outlined,
                label: profile.accountType,
              ),
              _InfoChip(
                icon: Icons.calendar_today_outlined,
                label: 'Member for $_memberSince',
              ),
            ],
          ),
          SizedBox(height: responsive.spacing(AppSpacing.lg)),
          OutlinedButton.icon(
            onPressed: () => context.push(AppRoutes.profileEdit),
            icon: const Icon(Icons.edit_outlined, size: 16),
            label: const Text(AppStrings.editProfileLabel),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
