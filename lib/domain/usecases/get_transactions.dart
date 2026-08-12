import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

/// Fetches every recorded transaction, newest first.
class GetTransactions {
  const GetTransactions(this._repository);

  final TransactionRepository _repository;

  Future<List<Transaction>> call() async {
    final List<Transaction> transactions = await _repository.getTransactions();
    final List<Transaction> sorted = List.of(transactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }
}
