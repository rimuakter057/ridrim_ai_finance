/// The signed-in user's profile.
class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.accountType,
    required this.planName,
    required this.joinedAt,
  });

  final String id;
  final String name;
  final String username;
  final String email;
  final String phone;

  /// e.g. "Personal", "Joint", "Business".
  final String accountType;
  final String planName;
  final DateTime joinedAt;
}
