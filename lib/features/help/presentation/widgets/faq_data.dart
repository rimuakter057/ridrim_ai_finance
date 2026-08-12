import '../../../../core/constants/app_strings.dart';

/// A single frequently-asked question and its answer.
class FaqItem {
  const FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}

/// The Help screen's FAQ list.
const List<FaqItem> faqItems = [
  FaqItem(
    question: AppStrings.faqQuestion1,
    answer: AppStrings.faqAnswer1,
  ),
  FaqItem(
    question: AppStrings.faqQuestion2,
    answer: AppStrings.faqAnswer2,
  ),
  FaqItem(
    question: AppStrings.faqQuestion3,
    answer: AppStrings.faqAnswer3,
  ),
  FaqItem(
    question: AppStrings.faqQuestion4,
    answer: AppStrings.faqAnswer4,
  ),
  FaqItem(
    question: AppStrings.faqQuestion5,
    answer: AppStrings.faqAnswer5,
  ),
];
