import '../entities/user_profile.dart';
import '../repositories/user_repository.dart';

/// Fetches the current user's profile.
class GetUserProfile {
  const GetUserProfile(this._repository);

  final UserRepository _repository;

  Future<UserProfile> call() => _repository.getUserProfile();
}
