import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/mock/mock_user_data.dart';

/// [UserRepository] backed by [MockUserDataSource]. Swap the data source
/// for an API-backed one later without touching call sites -- they only
/// depend on the [UserRepository] interface.
class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl(this._dataSource);

  final MockUserDataSource _dataSource;

  @override
  Future<UserProfile> getUserProfile() => _dataSource.getProfile();
}
