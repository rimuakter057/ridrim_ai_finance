import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

/// Records a new transaction.
class AddTransaction {
  const AddTransaction(this._repository);

  final TransactionRepository _repository;

  Future<Transaction> call(Transaction transaction) =>
      _repository.addTransaction(transaction);
}
