import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/auth_state_notifier.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../widgets/auth_divider.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/social_auth_buttons.dart';

/// User sign-up screen, presented as a bottom-sheet-style card docked
/// under the teal gradient hero (see [AuthScaffold]).
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isSubmitting = false;
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
    context.showSnackBar(AppStrings.registerSuccessMessage);

    isLoggedInNotifier.value = true;
    context.go(AppRoutes.dashboard);
  }

  void _goToLogin() {
    if (Navigator.of(context).canPop()) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return AuthScaffold(
      icon: Icons.person_add_alt_1_rounded,
      title: AppStrings.registerTitle,
      subtitle: AppStrings.registerSubtitle,
      child: Form(
        key: _formKey,
        autovalidateMode: _autoValidateMode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: AppStrings.fullNameLabel,
              hint: AppStrings.fullNameHint,
              prefixIcon: Icons.person_outline,
              controller: _nameController,
              validator: Validators.required,
            ),
            SizedBox(height: responsive.spacing(AppSpacing.lg)),
            AppTextField(
              label: AppStrings.emailLabel,
              hint: AppStrings.emailHint,
              prefixIcon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              validator: Validators.email,
            ),
            SizedBox(height: responsive.spacing(AppSpacing.lg)),
            AppTextField(
              label: AppStrings.passwordLabel,
              hint: AppStrings.passwordHintRegister,
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
            SizedBox(height: responsive.spacing(AppSpacing.xl)),
            AppButton(
              label: AppStrings.registerButtonLabel,
              fullWidth: true,
              isLoading: _isSubmitting,
              onPressed: _submit,
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xxl)),
            const AuthDivider(),
            SizedBox(height: responsive.spacing(AppSpacing.xxl)),
            const SocialAuthButtons(),
            SizedBox(height: responsive.spacing(AppSpacing.xxl)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.alreadyHaveAccountPrompt,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextButton(
                  onPressed: _goToLogin,
                  child: const Text(AppStrings.signInLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
