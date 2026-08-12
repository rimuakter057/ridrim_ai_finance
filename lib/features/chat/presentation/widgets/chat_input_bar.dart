import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import 'attachment_picker_sheet.dart';
import 'voice_input_sheet.dart';

/// Bottom message composer matching design screenshot:
/// Attachment button (+), rounded text field with mic icon, and circular blue send button.
class ChatInputBar extends StatelessWidget {
  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onImagePicked,
    this.enabled = true,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSend;

  /// Called with the local file path of an image picked via the
  /// attachment sheet (Camera or Photos & Videos).
  final ValueChanged<String> onImagePicked;
  final bool enabled;

  void _handleSend() {
    final String text = controller.text.trim();
    if (text.isEmpty) return;
    onSend(text);
    controller.clear();
  }

  Future<void> _onAttachment(BuildContext context) async {
    final String? imagePath = await showAttachmentPickerSheet(context);
    if (imagePath != null) onImagePicked(imagePath);
  }

  Future<void> _onMic(BuildContext context) async {
    final String? recognizedText = await showVoiceInputSheet(context);
    if (recognizedText == null || recognizedText.isEmpty) return;

    controller.text = recognizedText;
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final double actionBtnSize = responsive.width(42);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.spacing(AppSpacing.md),
            vertical: responsive.spacing(AppSpacing.sm),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Plus (+) Attachment Button ───────────────────────────────
              Container(
                width: actionBtnSize,
                height: actionBtnSize,
                margin: EdgeInsets.only(
                  right: responsive.spacing(AppSpacing.xs),
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.add_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 22,
                  ),
                  onPressed: enabled ? () => _onAttachment(context) : null,
                ),
              ),

              // ── Text Input Field with Microphone Icon ────────────────────
              Expanded(
                child: Container(
                  height: actionBtnSize,
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.spacing(AppSpacing.md),
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          enabled: enabled,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _handleSend(),
                          style: theme.textTheme.bodyMedium,
                          decoration: InputDecoration(
                            hintText: AppStrings.chatInputHint,
                            hintStyle: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.mic_none_rounded,
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        onPressed: enabled ? () => _onMic(context) : null,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: responsive.spacing(AppSpacing.xs)),

              // ── Circular Blue Send Button ────────────────────────────────
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (context, value, _) {
                  final bool canSend = enabled && value.text.trim().isNotEmpty;
                  return Container(
                    width: actionBtnSize,
                    height: actionBtnSize,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: canSend
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.4),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Opacity(
                      opacity: canSend ? 1 : 0.5,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.send_rounded,
                          color: AppColors.white,
                          size: 20,
                        ),
                        onPressed: canSend ? _handleSend : null,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
