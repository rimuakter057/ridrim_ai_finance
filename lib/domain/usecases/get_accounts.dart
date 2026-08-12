import '../entities/account.dart';
import '../repositories/account_repository.dart';

/// Fetches the user's linked accounts.
class GetAccounts {
  const GetAccounts(this._repository);

  final AccountRepository _repository;

  Future<List<Account>> call() => _repository.getAccounts();
}
