import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_tip_card.dart';

/// Final step of the password-reset flow: sets a new password.
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSubmitting = false;
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    context.hideKeyboard();
    if (!_formKey.currentState!.validate()) {
      setState(() => _autoValidateMode = AutovalidateMode.onUserInteraction);
      return;
    }

    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    setState(() => _isSubmitting = false);
    context.showSnackBar(AppStrings.resetPasswordSuccessMessage);

    // Pop Reset Password -> Verify OTP -> Forgot Password, back to Login.
    final NavigatorState navigator = Navigator.of(context);
    navigator
      ..pop()
      ..pop()
      ..pop();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return AuthScaffold(
      icon: Icons.lock_reset_rounded,
      title: AppStrings.resetPasswordTitle,
      subtitle: AppStrings.resetPasswordSubtitle,
      child: Form(
        key: _formKey,
        autovalidateMode: _autoValidateMode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: AppStrings.newPasswordLabel,
              hint: AppStrings.newPasswordHint,
              prefixIcon: Icons.lock_outline,
              obscureText: _obscurePassword,
              suffixIcon: _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              onSuffixIconTap: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              controller: _passwordController,
              validator: Validators.password,
            ),
            SizedBox(height: responsive.spacing(AppSpacing.lg)),
            AppTextField(
              label: AppStrings.confirmNewPasswordLabel,
              hint: AppStrings.confirmNewPasswordHint,
              prefixIcon: Icons.lock_outline,
              obscureText: _obscureConfirmPassword,
              suffixIcon: _obscureConfirmPassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              onSuffixIconTap: () => setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword,
              ),
              controller: _confirmPasswordController,
              validator: Validators.matches(_passwordController.text),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xxl)),
            AppButton(
              label: AppStrings.resetPasswordTitle,
              fullWidth: true,
              isLoading: _isSubmitting,
              onPressed: _submit,
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xxl)),
            const AuthTipCard(
              icon: Icons.lock_reset_rounded,
              title: 'Password Guidelines',
              message: '• Must be at least 8 characters long.\n'
                  '• Both passwords must match exactly.\n'
                  '• Avoid using common or easily guessable words.',
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xxl)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Back to', style: theme.textTheme.bodyMedium),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                  child: const Text('Log In'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
