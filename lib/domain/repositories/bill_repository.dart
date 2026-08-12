import '../entities/bill.dart';

/// Contract for retrieving and updating bills.
abstract class BillRepository {
  Future<List<Bill>> getBills();

  Future<Bill> setPaid(String billId, bool isPaid);
}
