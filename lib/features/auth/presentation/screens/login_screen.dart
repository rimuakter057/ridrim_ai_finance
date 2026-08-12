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
import '../widgets/auth_header.dart';
import '../widgets/social_auth_buttons.dart';

/// Email/password sign-in screen.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isSubmitting = false;
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
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
    context.showSnackBar(AppStrings.loginSuccessMessage);

    isLoggedInNotifier.value = true;
    context.go(AppRoutes.dashboard);
  }

  void _goToRegister() => context.push(AppRoutes.register);

  void _goToForgotPassword() => context.push(AppRoutes.forgotPassword);

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: responsive.maxContentWidth),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(responsive.spacing(AppSpacing.xxl)),
              child: Form(
                key: _formKey,
                autovalidateMode: _autoValidateMode,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AuthHeader(
                      title: AppStrings.loginTitle,
                      subtitle: AppStrings.loginSubtitle,
                    ),
                    SizedBox(height: responsive.spacing(AppSpacing.section)),
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
                      hint: AppStrings.passwordHintLogin,
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _goToForgotPassword,
                        child: const Text(AppStrings.forgotPasswordLabel),
                      ),
                    ),
                    SizedBox(height: responsive.spacing(AppSpacing.md)),
                    AppButton(
                      label: AppStrings.loginButtonLabel,
                      isLoading: _isSubmitting,
                      onPressed: _submit,
                    ),
                    SizedBox(height: responsive.spacing(AppSpacing.xxl)),
                    const AuthDivider(),
                    SizedBox(height: responsive.spacing(AppSpacing.xxl)),
                    SocialAuthButtons(
                      onGooglePressed: () => context.showSnackBar(
                        AppStrings.googleSignInComingSoon,
                      ),
                      onApplePressed: () => context.showSnackBar(
                        AppStrings.appleSignInComingSoon,
                      ),
                      onFacebookPressed: () => context.showSnackBar(
                        AppStrings.facebookSignInComingSoon,
                      ),
                    ),

                    SizedBox(height: responsive.spacing(AppSpacing.xxl)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.noAccountPrompt,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: _goToRegister,
                          child: const Text(AppStrings.signUpLabel),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
