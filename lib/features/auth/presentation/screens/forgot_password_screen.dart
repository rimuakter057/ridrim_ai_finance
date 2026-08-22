import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_tip_card.dart';

/// First step of the password-reset flow: collects account email.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool _isSubmitting = false;
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _emailController.dispose();
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
    context.push(AppRoutes.verifyOtp, extra: _emailController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return AuthScaffold(
      icon: Icons.key_outlined,
      title: AppStrings.forgotPasswordTitle,
      subtitle: AppStrings.forgotPasswordSubtitle,
      child: Form(
        key: _formKey,
        autovalidateMode: _autoValidateMode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: AppStrings.emailLabel,
              hint: AppStrings.emailHint,
              prefixIcon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              validator: Validators.email,
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xxl)),
            AppButton(
              label: AppStrings.sendCodeButtonLabel,
              fullWidth: true,
              isLoading: _isSubmitting,
              onPressed: _submit,
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xxl)),
            const AuthTipCard(
              icon: Icons.info_outline_rounded,
              title: 'Tips for password reset',
              message: '• Check your spam or junk folder if the email '
                  "doesn't arrive shortly.\n"
                  '• Make sure to enter the email associated with your '
                  'account.',
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xxl)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Remembered your password?',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextButton(
                  onPressed: () => Navigator.maybePop(context),
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
