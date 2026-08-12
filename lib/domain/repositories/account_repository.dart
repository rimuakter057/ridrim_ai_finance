import '../entities/account.dart';

/// Contract for retrieving the user's linked accounts.
abstract class AccountRepository {
  Future<List<Account>> getAccounts();
}
