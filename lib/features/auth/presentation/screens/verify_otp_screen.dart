import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_button.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_tip_card.dart';
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

    return AuthScaffold(
      icon: Icons.sms_outlined,
      title: AppStrings.verifyCodeTitle,
      subtitle: AppStrings.otpSentTo(AppConstants.otpLength, widget.email),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OtpInputField(
            length: AppConstants.otpLength,
            onChanged: (code) => setState(() => _code = code),
            onCompleted: (code) => setState(() => _code = code),
          ),
          SizedBox(height: responsive.spacing(AppSpacing.xxl)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppStrings.noCodePrompt, style: theme.textTheme.bodyMedium),
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
            fullWidth: true,
            isLoading: _isSubmitting,
            onPressed: _isCodeComplete ? _submit : null,
          ),
          SizedBox(height: responsive.spacing(AppSpacing.xxl)),
          const AuthTipCard(
            icon: Icons.shield_outlined,
            title: 'Security Note',
            message: 'Never share your verification code with anyone. Our '
                'support team will never ask for your code.',
          ),
          SizedBox(height: responsive.spacing(AppSpacing.xxl)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Entered wrong email?', style: theme.textTheme.bodyMedium),
              TextButton(
                onPressed: () => Navigator.maybePop(context),
                child: const Text('Change Email'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
