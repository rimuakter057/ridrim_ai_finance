import '../entities/bill.dart';
import '../repositories/bill_repository.dart';

/// Fetches the user's bills, soonest due first.
class GetBills {
  const GetBills(this._repository);

  final BillRepository _repository;

  Future<List<Bill>> call() async {
    final List<Bill> bills = await _repository.getBills();
    final List<Bill> sorted = List.of(bills)
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return sorted;
  }
}
