import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/mock/mock_transaction_data.dart';

/// [TransactionRepository] backed by [MockTransactionDataSource]. Swap the
/// data source for an API-backed one later without touching call sites --
/// they only depend on the [TransactionRepository] interface.
class TransactionRepositoryImpl implements TransactionRepository {
  const TransactionRepositoryImpl(this._dataSource);

  final MockTransactionDataSource _dataSource;

  @override
  Future<List<Transaction>> getTransactions() => _dataSource.getTransactions();

  @override
  Future<Transaction> addTransaction(Transaction transaction) =>
      _dataSource.addTransaction(transaction);
}
