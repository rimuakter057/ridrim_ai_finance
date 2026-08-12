import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_gradient_button.dart';
import '../widgets/onboarding_dots_indicator.dart';
import '../widgets/onboarding_page_content.dart';
import '../widgets/onboarding_page_data.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  bool get _isLastPage => _currentIndex == onboardingPages.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
    );
  }

  void _goToLogin() {
    context.push(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Header Bar ───────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.spacing(AppSpacing.lg),
                vertical: responsive.spacing(AppSpacing.sm),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Brand Logo Header
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          AppAssets.appLogo,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppStrings.appName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),

                  // Skip Button Pill
                  Visibility(
                    visible: !_isLastPage,
                    maintainState: true,
                    maintainAnimation: true,
                    maintainSize: true,
                    child: GestureDetector(
                      onTap: _goToLogin,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.5),
                          borderRadius:
                              BorderRadius.circular(responsive.radius(AppRadius.pill)),
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant
                                .withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          AppStrings.skip,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Carousel Page View ───────────────────────────────────────────
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingPages.length,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemBuilder: (context, index) {
                  return OnboardingPageContent(data: onboardingPages[index]);
                },
              ),
            ),

            // ── Indicators & Action Button ────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                responsive.spacing(AppSpacing.xxl),
                responsive.spacing(AppSpacing.sm),
                responsive.spacing(AppSpacing.xxl),
                responsive.spacing(AppSpacing.xl),
              ),
              child: Column(
                children: [
                  // Step counter & Glowing Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '0${_currentIndex + 1} / 0${onboardingPages.length}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      OnboardingDotsIndicator(
                        pageCount: onboardingPages.length,
                        currentIndex: _currentIndex,
                      ),
                    ],
                  ),

                  SizedBox(height: responsive.spacing(AppSpacing.lg)),

                  // Next / Get Started Button
                  AppGradientButton(
                    label: _isLastPage
                        ? AppStrings.onboardingGetStarted
                        : AppStrings.next,
                    icon: Icons.arrow_forward_rounded,
                    fullWidth: true,
                    onPressed: _isLastPage ? _goToLogin : _goToNextPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
