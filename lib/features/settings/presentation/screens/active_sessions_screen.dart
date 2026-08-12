import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../widgets/device_session_data.dart';

/// Lists every device currently signed in to the account, with the
/// ability to sign individual (or all other) sessions out.
class ActiveSessionsScreen extends StatefulWidget {
  const ActiveSessionsScreen({super.key});

  @override
  State<ActiveSessionsScreen> createState() => _ActiveSessionsScreenState();
}

class _ActiveSessionsScreenState extends State<ActiveSessionsScreen> {
  List<DeviceSession> _sessions = List.of(mockDeviceSessions);

  Future<void> _confirmSignOut(DeviceSession session) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.signOutSessionConfirmTitle),
        content: const Text(AppStrings.signOutSessionConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(AppStrings.signOutLabel),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() {
      _sessions = _sessions.where((s) => s.id != session.id).toList();
    });
    context.showSnackBar(AppStrings.sessionSignedOutMessage);
  }

  void _signOutAllOthers() {
    setState(() {
      _sessions = _sessions.where((s) => s.isCurrent).toList();
    });
    context.showSnackBar(AppStrings.allOtherSessionsSignedOutMessage);
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final bool hasOtherSessions = _sessions.any((s) => !s.isCurrent);

    return Scaffold(
      appBar: const AppAppBar(title: AppStrings.activeSessionsScreenTitle),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(responsive.spacing(AppSpacing.xxl)),
          children: [
            for (final session in _sessions) ...[
              _DeviceSessionTile(
                session: session,
                onSignOut: () => _confirmSignOut(session),
              ),
              SizedBox(height: responsive.spacing(AppSpacing.md)),
            ],
            if (hasOtherSessions) ...[
              SizedBox(height: responsive.spacing(AppSpacing.sm)),
              AppButton(
                label: AppStrings.signOutAllOthersLabel,
                variant: AppButtonVariant.outline,
                icon: Icons.logout_rounded,
                onPressed: _signOutAllOthers,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DeviceSessionTile extends StatelessWidget {
  const _DeviceSessionTile({required this.session, required this.onSignOut});

  final DeviceSession session;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return AppCard(
      child: Row(
        children: [
          Container(
            width: responsive.width(44),
            height: responsive.width(44),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius:
                  BorderRadius.circular(responsive.radius(AppRadius.md)),
            ),
            child: Icon(session.icon, color: theme.colorScheme.primary),
          ),
          SizedBox(width: responsive.spacing(AppSpacing.md)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        session.deviceName,
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (session.isCurrent) ...[
                      SizedBox(width: responsive.spacing(AppSpacing.xs)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.15),
                          borderRadius:
                              BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text(
                          AppStrings.thisDeviceLabel,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: responsive.spacing(AppSpacing.xs)),
                Text(
                  '${session.location} · ${session.lastActiveLabel}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (!session.isCurrent)
            IconButton(
              icon: Icon(
                Icons.logout_rounded,
                color: theme.colorScheme.error,
              ),
              onPressed: onSignOut,
            ),
        ],
      ),
    );
  }
}
