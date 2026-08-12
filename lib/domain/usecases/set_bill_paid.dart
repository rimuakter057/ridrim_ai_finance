import '../entities/bill.dart';
import '../repositories/bill_repository.dart';

/// Marks a bill as paid or unpaid.
class SetBillPaid {
  const SetBillPaid(this._repository);

  final BillRepository _repository;

  Future<Bill> call(String billId, bool isPaid) =>
      _repository.setPaid(billId, isPaid);
}
