import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/auth_state_notifier.dart';
import '../../../../core/utils/extensions.dart';
import '../../../settings/presentation/widgets/settings_group_card.dart';

// ── Navigation helpers ───────────────────────────────────────────────────────

void openHelp(BuildContext context) => context.push(AppRoutes.help);

void openSubscription(BuildContext context) =>
    context.push(AppRoutes.subscription);

void openSettings(BuildContext context) => context.push(AppRoutes.settings);

// ── Dialogs ──────────────────────────────────────────────────────────────────

/// Shows a confirmation dialog and returns to [AppRoutes.login] on confirm.
Future<void> confirmSignOut(BuildContext context) async {
  final bool? confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text(AppStrings.signOutConfirmTitle),
      content: const Text(AppStrings.signOutConfirmMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text(AppStrings.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text(AppStrings.menuSignOut),
        ),
      ],
    ),
  );

  if (confirmed != true || !context.mounted) return;

  isLoggedInNotifier.value = false;
  context.go(AppRoutes.login);
}

/// Shows a confirmation dialog and shows a snackbar on confirm.
Future<void> confirmDeleteAccount(BuildContext context) async {
  final bool? confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text(AppStrings.deleteAccountLabel),
      content: const Text(
        'Are you sure you want to delete your account? This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text(AppStrings.cancel),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text(AppStrings.delete),
        ),
      ],
    ),
  );

  if (confirmed != true || !context.mounted) return;
  context.showSnackBar('Account deletion requested.');
}

// ── Menu data ────────────────────────────────────────────────────────────────

/// Builds the list of [SettingsGroupCard] sections shown in [ProfileScreen].
List<SettingsGroupCard> buildProfileMenuGroups(BuildContext context) {
  return [
    SettingsGroupCard(
      title: AppStrings.accountSectionTitle,
      items: [
        SettingsTileData(
          icon: Icons.person_outline_rounded,
          label: AppStrings.editProfileLabel,
          iconBgColor: AppColors.tilePurpleBg,
          iconColor: AppColors.tilePurpleIcon,
          onTap: () => context.push(AppRoutes.profileEdit),
        ),
        SettingsTileData(
          icon: Icons.lock_outline_rounded,
          label: AppStrings.passwordSecurityLabel,
          iconBgColor: AppColors.tileOrangeBg,
          iconColor: AppColors.tileOrangeIcon,
          onTap: () => context.push(AppRoutes.profilePasswordSecurity),
        ),
      ],
    ),
    SettingsGroupCard(
      title: AppStrings.billingSectionTitle,
      items: [
        SettingsTileData(
          icon: Icons.credit_card_outlined,
          label: AppStrings.paymentMethodsLabel,
          iconBgColor: AppColors.tileTealBg,
          iconColor: AppColors.tileTealIcon,
          onTap: () => context.push(AppRoutes.profilePaymentMethods),
        ),
        SettingsTileData(
          icon: Icons.receipt_long_outlined,
          label: AppStrings.billingHistoryLabel,
          iconBgColor: AppColors.tileIndigoBg,
          iconColor: AppColors.tileIndigoIcon,
          onTap: () => context.push(AppRoutes.profileBillingHistory),
        ),
        SettingsTileData(
          icon: Icons.star_outline_rounded,
          label: AppStrings.manageSubscriptionLabel,
          iconBgColor: AppColors.tileYellowBg,
          iconColor: AppColors.tileYellowIcon,
          onTap: () => openSubscription(context),
        ),
      ],
    ),
    SettingsGroupCard(
      items: [
        SettingsTileData(
          icon: Icons.settings_outlined,
          label: AppStrings.menuSettings,
          subtitle: AppStrings.settingsSubtitle,
          iconBgColor: AppColors.tilePurpleBg,
          iconColor: AppColors.tilePurpleIcon,
          onTap: () => openSettings(context),
        ),
        SettingsTileData(
          icon: Icons.help_outline_rounded,
          label: AppStrings.menuHelp,
          iconBgColor: AppColors.tilePinkBg,
          iconColor: AppColors.tilePinkIcon,
          onTap: () => openHelp(context),
        ),
      ],
    ),
    SettingsGroupCard(
      items: [
        SettingsTileData(
          icon: Icons.logout_rounded,
          label: AppStrings.menuSignOut,
          iconBgColor: AppColors.tileBlueBg,
          iconColor: AppColors.tileBlueIcon,
          onTap: () => confirmSignOut(context),
        ),
        SettingsTileData(
          icon: Icons.delete_outline_rounded,
          label: AppStrings.deleteAccountLabel,
          textColor: AppColors.tileRedIcon,
          iconBgColor: AppColors.tileRedBg,
          iconColor: AppColors.tileRedIcon,
          onTap: () => confirmDeleteAccount(context),
        ),
      ],
    ),
  ];
}
