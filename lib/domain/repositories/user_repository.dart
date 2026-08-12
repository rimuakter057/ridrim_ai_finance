import '../entities/user_profile.dart';

/// Contract for retrieving the current user's profile. Implemented
/// against the mock data source today, and against a real API data
/// source once the backend exists.
abstract class UserRepository {
  Future<UserProfile> getUserProfile();
}
