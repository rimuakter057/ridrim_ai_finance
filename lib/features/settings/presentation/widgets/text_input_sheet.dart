import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

/// Bottom sheet collecting a single free-text/numeric value. Returns the
/// trimmed input, or `null` if dismissed without submitting. Shared by
/// every Settings/Profile tile that edits one value via a text field
/// (income, targets, spending limits, ...).
Future<String?> showTextInputSheet({
  required BuildContext context,
  required String title,
  required String initialValue,
  String? hint,
  String? prefixText,
  TextInputType keyboardType = TextInputType.text,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _TextInputSheet(
      title: title,
      initialValue: initialValue,
      hint: hint,
      prefixText: prefixText,
      keyboardType: keyboardType,
    ),
  );
}

class _TextInputSheet extends StatefulWidget {
  const _TextInputSheet({
    required this.title,
    required this.initialValue,
    this.hint,
    this.prefixText,
    required this.keyboardType,
  });

  final String title;
  final String initialValue;
  final String? hint;
  final String? prefixText;
  final TextInputType keyboardType;

  @override
  State<_TextInputSheet> createState() => _TextInputSheetState();
}

class _TextInputSheetState extends State<_TextInputSheet> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialValue,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final String value = _controller.text.trim();
    if (value.isEmpty) return;
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        responsive.spacing(AppSpacing.lg),
        responsive.spacing(AppSpacing.lg),
        responsive.spacing(AppSpacing.lg),
        MediaQuery.viewInsetsOf(context).bottom +
            responsive.spacing(AppSpacing.lg),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: responsive.spacing(AppSpacing.lg)),
            AppTextField(
              controller: _controller,
              hint: widget.hint,
              keyboardType: widget.keyboardType,
              prefixIcon: widget.prefixText == null
                  ? null
                  : Icons.attach_money_rounded,
              textInputAction: TextInputAction.done,
              onChanged: (_) {},
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xl)),
            AppButton(label: 'Save', fullWidth: true, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
