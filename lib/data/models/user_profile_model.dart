import '../../domain/entities/user_profile.dart';

/// Data-layer representation of [UserProfile]. Kept separate from the
/// domain entity so JSON (de)serialization can be added here later
/// without leaking data-layer concerns into the domain layer.
class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.name,
    required super.username,
    required super.email,
    required super.phone,
    required super.accountType,
    required super.planName,
    required super.joinedAt,
  });
}
