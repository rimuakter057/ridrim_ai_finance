import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';

/// Shared shell for every auth screen: a teal gradient hero (icon, title,
/// subtitle) with the actual form presented as a rounded card docked to
/// the bottom of the screen, like a permanently-open bottom sheet --
/// replaces the old plain centered-form layout across Login, Register,
/// Forgot Password, Verify OTP, and Reset Password.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.icon = Icons.auto_awesome_rounded,
    this.showBackButton = true,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final IconData icon;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final double heroHeight = responsive.heightPercent(32);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // ── Gradient hero ────────────────────────────────────────────
          Container(
            width: double.infinity,
            height: heroHeight,
            decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.spacing(AppSpacing.xl),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (showBackButton)
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: responsive.spacing(AppSpacing.lg),
                        ),
                        child: const _BackButton(),
                      ),
                    Container(
                      width: responsive.width(56),
                      height: responsive.width(56),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius:
                            BorderRadius.circular(responsive.radius(AppRadius.lg)),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: responsive.iconSize(26),
                      ),
                    ),
                    SizedBox(height: responsive.spacing(AppSpacing.lg)),
                    Text(
                      title,
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: responsive.spacing(AppSpacing.xs)),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Bottom-sheet-style form card ─────────────────────────────
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(responsive.radius(AppRadius.xxl)),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 24,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: responsive.spacing(AppSpacing.sm)),
                  Container(
                    width: responsive.width(40),
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outline,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        responsive.spacing(AppSpacing.xxl),
                        responsive.spacing(AppSpacing.xl),
                        responsive.spacing(AppSpacing.xxl),
                        responsive.spacing(AppSpacing.xxl),
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(maxWidth: responsive.maxContentWidth),
                          child: child,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    if (!Navigator.canPop(context)) return const SizedBox.shrink();
    return SizedBox(
      width: 36,
      height: 36,
      child: IconButton(
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.16),
        ),
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 16,
        ),
        onPressed: () => Navigator.maybePop(context),
      ),
    );
  }
}
