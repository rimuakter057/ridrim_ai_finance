import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

/// Opens the "Send Feedback" bottom sheet: a multiline field and a submit
/// button. Submission is mocked (no backend), but validates non-empty
/// input and confirms success via a snackbar.
Future<void> showFeedbackSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _FeedbackSheet(),
  );
}

class _FeedbackSheet extends StatefulWidget {
  const _FeedbackSheet();

  @override
  State<_FeedbackSheet> createState() => _FeedbackSheetState();
}

class _FeedbackSheetState extends State<_FeedbackSheet> {
  final TextEditingController _controller = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    final String feedback = _controller.text.trim();
    if (feedback.isEmpty) {
      context.showSnackBar(AppStrings.feedbackRequiredMessage);
      return;
    }

    context.hideKeyboard();
    setState(() => _isSubmitting = true);

    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!context.mounted) return;

    Navigator.of(context).pop();
    context.showSnackBar(AppStrings.feedbackSubmittedMessage);
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        responsive.spacing(AppSpacing.lg),
        responsive.spacing(AppSpacing.xs),
        responsive.spacing(AppSpacing.lg),
        responsive.spacing(AppSpacing.lg) + context.keyboardHeight,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.sendFeedbackTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: responsive.spacing(AppSpacing.md)),
            AppTextField(
              hint: AppStrings.sendFeedbackHint,
              controller: _controller,
              maxLines: 4,
            ),
            SizedBox(height: responsive.spacing(AppSpacing.lg)),
            AppButton(
              label: AppStrings.submitFeedbackLabel,
              isLoading: _isSubmitting,
              onPressed: () => _submit(context),
            ),
          ],
        ),
      ),
    );
  }
}
