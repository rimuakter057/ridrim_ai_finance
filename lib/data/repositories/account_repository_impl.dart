import '../../domain/entities/account.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/mock/mock_account_data.dart';

/// [AccountRepository] backed by [MockAccountDataSource]. Swap the data
/// source for an API-backed one later without touching call sites -- they
/// only depend on the [AccountRepository] interface.
class AccountRepositoryImpl implements AccountRepository {
  const AccountRepositoryImpl(this._dataSource);

  final MockAccountDataSource _dataSource;

  @override
  Future<List<Account>> getAccounts() => _dataSource.getAccounts();
}
