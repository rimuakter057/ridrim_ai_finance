import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';

/// Static content for a single onboarding slide.
class OnboardingPageData {
  const OnboardingPageData({
    required this.index,
    required this.tag,
    required this.icon,
    required this.title,
    required this.description,
  });

  final int index;
  final String tag;
  final IconData icon;
  final String title;
  final String description;
}

/// The onboarding carousel's sample slides.
const List<OnboardingPageData> onboardingPages = [
  OnboardingPageData(
    index: 0,
    tag: AppStrings.onboardingTag1,
    icon: Icons.forum_outlined,
    title: AppStrings.onboardingTitle1,
    description: AppStrings.onboardingDescription1,
  ),
  OnboardingPageData(
    index: 1,
    tag: AppStrings.onboardingTag2,
    icon: Icons.auto_awesome_outlined,
    title: AppStrings.onboardingTitle2,
    description: AppStrings.onboardingDescription2,
  ),
  OnboardingPageData(
    index: 2,
    tag: AppStrings.onboardingTag3,
    icon: Icons.rocket_launch_outlined,
    title: AppStrings.onboardingTitle3,
    description: AppStrings.onboardingDescription3,
  ),
];
