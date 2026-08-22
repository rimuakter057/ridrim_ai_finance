import '../entities/debt.dart';

/// Contract for retrieving the user's tracked debts.
abstract class DebtRepository {
  Future<List<Debt>> getDebts();
}
