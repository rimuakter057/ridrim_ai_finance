import '../../../core/constants/app_strings.dart';
import '../../models/user_profile_model.dart';

/// In-memory mock data source standing in for a real user-profile API.
///
/// Replace with an `ApiUserDataSource` (same method signature) once a
/// backend exists -- [UserRepositoryImpl] wouldn't need to change.
class MockUserDataSource {
  const MockUserDataSource();

  Future<UserProfileModel> getProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return UserProfileModel(
      id: 'user_1',
      name: AppStrings.demoUserName,
      username: 'alexmorgan',
      email: AppStrings.demoUserEmail,
      phone: '+1 (555) 123-4567',
      accountType: 'Personal',
      planName: AppStrings.demoUserPlan,
      joinedAt: DateTime.now().subtract(const Duration(days: 42)),
    );
  }
}
