import '../../../../core/constants/app_strings.dart';

/// A single heading + body pair within a legal document.
class LegalSection {
  const LegalSection({required this.heading, required this.body});

  final String heading;
  final String body;
}

/// Placeholder Terms of Service content -- replace with your real terms
/// before shipping to production.
const List<LegalSection> termsOfServiceSections = [
  LegalSection(
    heading: AppStrings.termsSection1Heading,
    body: AppStrings.termsSection1Body,
  ),
  LegalSection(
    heading: AppStrings.termsSection2Heading,
    body: AppStrings.termsSection2Body,
  ),
  LegalSection(
    heading: AppStrings.termsSection3Heading,
    body: AppStrings.termsSection3Body,
  ),
  LegalSection(
    heading: AppStrings.termsSection4Heading,
    body: AppStrings.termsSection4Body,
  ),
  LegalSection(
    heading: AppStrings.termsSection5Heading,
    body: AppStrings.termsSection5Body,
  ),
];

/// Placeholder Privacy Policy content -- replace with your real policy
/// before shipping to production.
const List<LegalSection> privacyPolicySections = [
  LegalSection(
    heading: AppStrings.privacySection1Heading,
    body: AppStrings.privacySection1Body,
  ),
  LegalSection(
    heading: AppStrings.privacySection2Heading,
    body: AppStrings.privacySection2Body,
  ),
  LegalSection(
    heading: AppStrings.privacySection3Heading,
    body: AppStrings.privacySection3Body,
  ),
  LegalSection(
    heading: AppStrings.privacySection4Heading,
    body: AppStrings.privacySection4Body,
  ),
  LegalSection(
    heading: AppStrings.privacySection5Heading,
    body: AppStrings.privacySection5Body,
  ),
];
