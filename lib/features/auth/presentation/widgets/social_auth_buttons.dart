import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';

/// Row of secondary "continue with" social sign-in icon buttons shared by
/// the login and register screens. Handlers are provided by the caller
/// since no auth backend is wired up yet.
class SocialAuthButtons extends StatelessWidget {
  const SocialAuthButtons({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
    this.onFacebookPressed,
  });

  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;
  final VoidCallback? onFacebookPressed;

  @override
  Widget build(BuildContext context) {
    final double gap = ResponsiveHelper.of(context).spacing(AppSpacing.md);

    return Row(
      children: [
        Expanded(
          child: _SocialIconButton(
            assetPath: AppAssets.googleIcon,
            semanticLabel: AppStrings.continueWithGoogle,
            onPressed: onGooglePressed,
          ),
        ),
        SizedBox(width: gap),


        Expanded(
          child: _SocialIconButton(
            assetPath: AppAssets.facebookIcon,
            semanticLabel: AppStrings.continueWithFacebook,
            onPressed: onFacebookPressed,
          ),
        ),
        SizedBox(width: gap),
        Expanded(
          child: _SocialIconButton(
            assetPath: AppAssets.appleIcon,
            semanticLabel: AppStrings.continueWithApple,
            tintWithForeground: true,
            onPressed: onApplePressed,
          ),
        ),


      ],
    );
  }
}

/// A single square, bordered, theme-aware icon button rendering an SVG
/// brand mark from `assets/icons`.
class _SocialIconButton extends StatelessWidget {
  const _SocialIconButton({
    required this.assetPath,
    required this.semanticLabel,
    required this.onPressed,
    this.tintWithForeground = false,
  });

  final String assetPath;
  final String semanticLabel;
  final VoidCallback? onPressed;

  /// Apple's mark ships as a solid dark silhouette -- tint it with the
  /// current foreground color so it stays visible in both themes. Google
  /// and Facebook keep their official brand colors untouched.
  final bool tintWithForeground;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final BorderRadius borderRadius =
        BorderRadius.circular(responsive.radius(AppRadius.md));

    return SizedBox(
      height: responsive.buttonHeight(52),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onPressed,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: Border.all(color: colorScheme.outline),
            ),
            child: SvgPicture.asset(
              assetPath,
              width: responsive.iconSize(22),
              height: responsive.iconSize(22),
              semanticsLabel: semanticLabel,
              colorFilter: tintWithForeground
                  ? ColorFilter.mode(colorScheme.onSurface, BlendMode.srcIn)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
