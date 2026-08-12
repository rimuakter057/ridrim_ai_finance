import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_button.dart';
import '../widgets/auth_header.dart';
import '../widgets/otp_input_field.dart';

/// Second step of the password-reset flow: collects the OTP sent to
/// [email], with a resend cooldown. Simulates verification before moving
/// on to [ResetPasswordScreen].
class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key, required this.email});

  final String email;

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  String _code = '';
  bool _isSubmitting = false;
  Timer? _cooldownTimer;
  int _secondsRemaining = AppConstants.otpResendCooldown.inSeconds;

  bool get _isCodeComplete => _code.length == AppConstants.otpLength;

  @override
  void initState() {
    super.initState();
    _startCooldown();
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    setState(() => _secondsRemaining = AppConstants.otpResendCooldown.inSeconds);
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() => _secondsRemaining = 0);
        return;
      }
      setState(() => _secondsRemaining -= 1);
    });
  }

  void _resendCode() {
    context.showSnackBar(AppStrings.otpResentTo(widget.email));
    _startCooldown();
  }

  Future<void> _submit() async {
    if (!_isCodeComplete) return;

    context.hideKeyboard();
    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    setState(() => _isSubmitting = false);
    context.push(AppRoutes.resetPassword);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final bool canResend = _secondsRemaining == 0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.maybePop(context),
              )
            : null,
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: responsive.maxContentWidth),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.spacing(AppSpacing.xxl),
                vertical: responsive.spacing(AppSpacing.lg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: responsive.spacing(AppSpacing.lg)),
                  AuthHeader(
                    title: AppStrings.verifyCodeTitle,
                    subtitle: AppStrings.otpSentTo(
                      AppConstants.otpLength,
                      widget.email,
                    ),
                  ),
                  SizedBox(height: responsive.spacing(AppSpacing.section)),
                  OtpInputField(
                    length: AppConstants.otpLength,
                    onChanged: (code) => setState(() => _code = code),
                    onCompleted: (code) => setState(() => _code = code),
                  ),
                  SizedBox(height: responsive.spacing(AppSpacing.xxl)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.noCodePrompt,
                        style: theme.textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: canResend ? _resendCode : null,
                        child: Text(
                          canResend
                              ? AppStrings.resendLabel
                              : AppStrings.resendInSeconds(_secondsRemaining),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: responsive.spacing(AppSpacing.lg)),
                  AppButton(
                    label: AppStrings.verifyButtonLabel,
                    isLoading: _isSubmitting,
                    onPressed: _isCodeComplete ? _submit : null,
                  ),
                  SizedBox(height: responsive.spacing(AppSpacing.xxl)),
                  // ── Security Tip Card ──────────────────────────────────
                  Container(
                    padding: EdgeInsets.all(responsive.spacing(AppSpacing.lg)),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.4),
                      borderRadius:
                          BorderRadius.circular(responsive.radius(AppRadius.md)),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        SizedBox(width: responsive.spacing(AppSpacing.md)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Security Note',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Never share your verification code with anyone. Our support team will never ask for your code.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: responsive.spacing(AppSpacing.xxl)),
                  // ── Bottom Link ──────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Entered wrong email?',
                        style: theme.textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () => Navigator.maybePop(context),
                        child: const Text('Change Email'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
