import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

/// Screen to edit profile details (Name, Email, Bio).
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: AppStrings.demoUserName);
  final TextEditingController _emailController =
      TextEditingController(text: AppStrings.demoUserEmail);
  final TextEditingController _bioController = TextEditingController(
    text: 'AI Enthusiast & Software Developer building next-gen SaaS apps.',
  );
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    context.hideKeyboard();
    setState(() => _isSaving = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isSaving = false);
    context.showSnackBar(AppStrings.profileSavedMessage);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return Scaffold(
      appBar: const AppAppBar(
        title: AppStrings.editProfileScreenTitle,
        subtitle: AppStrings.editProfileScreenSubtitle,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(responsive.spacing(AppSpacing.lg)),
          child: Column(
            children: [
              // Avatar edit preview
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: responsive.width(44),
                      backgroundColor: AppColors.avatarPurple,
                      child: Text(
                        _nameController.text.initials(),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsive.spacing(AppSpacing.xl)),

              // Form fields
              AppTextField(
                label: AppStrings.fullNameLabel,
                controller: _nameController,
                prefixIcon: Icons.person_outline_rounded,
              ),
              SizedBox(height: responsive.spacing(AppSpacing.md)),
              AppTextField(
                label: AppStrings.emailLabel,
                controller: _emailController,
                prefixIcon: Icons.email_outlined,
              ),
              SizedBox(height: responsive.spacing(AppSpacing.md)),
              AppTextField(
                label: AppStrings.bioLabel,
                controller: _bioController,
                maxLines: 3,
              ),
              SizedBox(height: responsive.spacing(AppSpacing.xl)),

              // Save button
              AppButton(
                label: AppStrings.save,
                isLoading: _isSaving,
                onPressed: _saveProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
