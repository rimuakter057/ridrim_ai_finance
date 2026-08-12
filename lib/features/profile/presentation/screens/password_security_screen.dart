import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../widgets/profile_menu_tile.dart';

/// Password & Security screen for updating password & toggling 2FA.
class PasswordSecurityScreen extends StatefulWidget {
  const PasswordSecurityScreen({super.key});

  @override
  State<PasswordSecurityScreen> createState() => _PasswordSecurityScreenState();
}

class _PasswordSecurityScreenState extends State<PasswordSecurityScreen> {
  final TextEditingController _currentPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  bool _isSaving = false;
  bool _twoFactorEnabled = true;

  @override
  void dispose() {
    _currentPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (_currentPassController.text.isEmpty ||
        _newPassController.text.isEmpty) {
      context.showSnackBar(AppStrings.fieldRequiredMessage);
      return;
    }
    if (_newPassController.text != _confirmPassController.text) {
      context.showSnackBar(AppStrings.passwordsDoNotMatchMessage);
      return;
    }

    context.hideKeyboard();
    setState(() => _isSaving = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isSaving = false);
    _currentPassController.clear();
    _newPassController.clear();
    _confirmPassController.clear();
    context.showSnackBar(AppStrings.passwordUpdatedMessage);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return Scaffold(
      appBar: const AppAppBar(
        title: AppStrings.passwordSecurityScreenTitle,
        subtitle: AppStrings.passwordSecurityScreenSubtitle,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(responsive.spacing(AppSpacing.lg)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── 2FA Toggle Card ──────────────────────────────────────────
              AppCard(
                padding: EdgeInsets.zero,
                child: ProfileMenuTile(
                  icon: Icons.security_rounded,
                  label: AppStrings.twoFactorAuthLabel,
                  subtitle: AppStrings.twoFactorSubtitle,
                  showChevron: false,
                  onTap: () {},
                  trailing: Switch.adaptive(
                    value: _twoFactorEnabled,
                    onChanged: (val) {
                      setState(() => _twoFactorEnabled = val);
                      context.showSnackBar(
                        val
                            ? AppStrings.twoFactorEnabledMessage
                            : AppStrings.twoFactorDisabledMessage,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: responsive.spacing(AppSpacing.xl)),

              // ── Change Password Section ──────────────────────────────────
              Text(
                AppStrings.changePasswordHeader,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: responsive.height(32)),

              AppTextField(
                label: AppStrings.currentPasswordLabel,
                controller: _currentPassController,
                hint: AppStrings.passwordHintLogin,
                obscureText: true,
                prefixIcon: Icons.lock_outline_rounded,
              ),
              SizedBox(height: responsive.spacing(AppSpacing.md)),
              AppTextField(
                label: AppStrings.newPasswordLabel,
                controller: _newPassController,
                hint: AppStrings.newPasswordHint,
                obscureText: true,
                prefixIcon: Icons.lock_reset_rounded,
              ),
              SizedBox(height: responsive.spacing(AppSpacing.md)),
              AppTextField(
                label: AppStrings.confirmNewPasswordLabel,
                controller: _confirmPassController,
                hint: AppStrings.confirmNewPasswordHint,
                obscureText: true,
                prefixIcon: Icons.check_circle_outline_rounded,
              ),
              SizedBox(height: responsive.spacing(AppSpacing.xl)),

              AppButton(
                label: AppStrings.resetPasswordTitle,
                isLoading: _isSaving,
                onPressed: _updatePassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
