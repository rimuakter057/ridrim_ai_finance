import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/responsive.dart';

enum _AttachmentOption { camera, gallery, document }


Future<String?> showAttachmentPickerSheet(BuildContext context) async {
  final _AttachmentOption? option = await showModalBottomSheet<_AttachmentOption>(
    context: context,
    builder: (_) => const _AttachmentPickerSheet(),
  );
  if (option == null || !context.mounted) return null;

  try {
    switch (option) {
      case _AttachmentOption.camera:
        final XFile? file =
            await ImagePicker().pickImage(source: ImageSource.camera);
        return file?.path;
      case _AttachmentOption.gallery:
        final XFile? file = await ImagePicker().pickMedia();
        return file?.path;
      case _AttachmentOption.document:
        final FilePickerResult? result = await FilePicker.pickFiles();
        if (result == null || !context.mounted) return null;
        context.showSnackBar(
          AppStrings.attachmentAddedMessage(result.files.single.name),
        );
        return null;
    }
  } catch (_) {
    if (context.mounted) {
      context.showSnackBar(AppStrings.attachmentPermissionDeniedMessage);
    }
    return null;
  }
}

class _AttachmentPickerSheet extends StatelessWidget {
  const _AttachmentPickerSheet();

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          responsive.spacing(AppSpacing.lg),
          responsive.spacing(AppSpacing.xs),
          responsive.spacing(AppSpacing.lg),
          responsive.spacing(AppSpacing.lg),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.addAttachmentTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: responsive.spacing(AppSpacing.sm)),
            _AttachmentTile(
              icon: Icons.photo_camera_rounded,
              label: AppStrings.attachmentCameraLabel,
              subtitle: AppStrings.attachmentCameraSubtitle,
              onTap: () =>
                  Navigator.of(context).pop(_AttachmentOption.camera),
            ),
            _AttachmentTile(
              icon: Icons.photo_library_rounded,
              label: AppStrings.attachmentGalleryLabel,
              subtitle: AppStrings.attachmentGallerySubtitle,
              onTap: () =>
                  Navigator.of(context).pop(_AttachmentOption.gallery),
            ),
            _AttachmentTile(
              icon: Icons.insert_drive_file_rounded,
              label: AppStrings.attachmentDocumentLabel,
              subtitle: AppStrings.attachmentDocumentSubtitle,
              onTap: () =>
                  Navigator.of(context).pop(_AttachmentOption.document),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  const _AttachmentTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: Container(
        width: responsive.width(44),
        height: responsive.width(44),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(responsive.radius(AppRadius.md)),
        ),
        child: Icon(icon, color: theme.colorScheme.primary),
      ),
      title: Text(
        label,
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
