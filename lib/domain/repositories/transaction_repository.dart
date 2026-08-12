import '../entities/transaction.dart';

/// Contract for retrieving and recording transactions.
abstract class TransactionRepository {
  Future<List<Transaction>> getTransactions();

  Future<Transaction> addTransaction(Transaction transaction);
}
