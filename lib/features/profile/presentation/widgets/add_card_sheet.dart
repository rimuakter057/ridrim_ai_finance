import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/utils/responsive.dart';
import '../../controller/payment_method_controller.dart';
import '../utils/card_input_format.dart';

class AddCardSheet extends StatefulWidget {
  const AddCardSheet({super.key});

  @override
  State<AddCardSheet> createState() => _AddCardSheetState();
}

class _AddCardSheetState extends State<AddCardSheet>
    with AddCardControllerMixin {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final double bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(responsive.radius(AppRadius.xl)),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        responsive.spacing(24),
        responsive.spacing(12),
        responsive.spacing(24),
        responsive.spacing(24) + bottomPadding,
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: responsive.width(40),
                height: responsive.height(4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(responsive.radius(AppRadius.pill)),
                ),
              ),
            ),
            SizedBox(height: responsive.spacing(20)),

            Text(
              AppStrings.addCardModalTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: responsive.spacing(4)),
            Text(
              AppStrings.addCardModalSubtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: responsive.spacing(24)),

            _FieldLabel(label: AppStrings.cardNumberLabel, theme: theme),
            SizedBox(height: responsive.spacing(6)),
            TextFormField(
              controller: numberCtrl,
              keyboardType: TextInputType.number,
              maxLength: 19,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CardNumberFormatter(),
              ],
              decoration: _inputDecoration(
                context,
                responsive,
                hintText: '1234 5678 9012 3456',
                suffixIcon: detectedBrand.isNotEmpty
                    ? Padding(
                  padding: EdgeInsets.all(responsive.spacing(12)),
                  child: Text(
                    detectedBrand,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: cardBrandColor(detectedBrand),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                    : null,
              ),
              onChanged: onNumberChanged,
              validator: validateCardNumber,
            ),
            SizedBox(height: responsive.spacing(16)),

            _FieldLabel(label: AppStrings.cardholderNameLabel, theme: theme),
            SizedBox(height: responsive.spacing(6)),
            TextFormField(
              controller: nameCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: _inputDecoration(
                context,
                responsive,
                hintText: AppStrings.fullNameHint,
              ),
              validator: validateName,
            ),
            SizedBox(height: responsive.spacing(16)),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel(label: AppStrings.expiryDateLabel, theme: theme),
                      SizedBox(height: responsive.spacing(6)),
                      TextFormField(
                        controller: expiryCtrl,
                        keyboardType: TextInputType.number,
                        maxLength: 5,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          ExpiryFormatter(),
                        ],
                        decoration: _inputDecoration(
                          context,
                          responsive,
                          hintText: 'MM/YY',
                        ),
                        validator: validateExpiry,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: responsive.spacing(16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel(label: AppStrings.cvvLabel, theme: theme),
                      SizedBox(height: responsive.spacing(6)),
                      TextFormField(
                        controller: cvvCtrl,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        obscureText: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: _inputDecoration(
                          context,
                          responsive,
                          hintText: '•••',
                        ),
                        validator: validateCvv,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.spacing(8)),

            Row(
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: responsive.iconSize(12),
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: responsive.spacing(4)),
                Text(
                  AppStrings.sslSecurityNote,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: responsive.fontSize(11),
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.spacing(24)),

            FilledButton(
              onPressed: isLoading ? null : submit,
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: responsive.spacing(16),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(responsive.radius(AppRadius.md)),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                height: responsive.height(20),
                width: responsive.width(20),
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : Text(
                AppStrings.addCardButtonLabel,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: responsive.fontSize(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
      BuildContext context,
      ResponsiveHelper responsive, {
        required String hintText,
        Widget? suffixIcon,
      }) {
    final ThemeData theme = Theme.of(context);
    final double borderRadius = responsive.radius(AppRadius.md);

    return InputDecoration(
      hintText: hintText,
      counterText: '',
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      contentPadding: EdgeInsets.symmetric(
        horizontal: responsive.spacing(16),
        vertical: responsive.spacing(14),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label, required this.theme});
  final String label;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: theme.textTheme.labelMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface,
      ),
    );
  }
}