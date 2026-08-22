import '../entities/debt.dart';
import '../repositories/debt_repository.dart';

/// Fetches the user's tracked debts.
class GetDebts {
  const GetDebts(this._repository);

  final DebtRepository _repository;

  Future<List<Debt>> call() => _repository.getDebts();
}
