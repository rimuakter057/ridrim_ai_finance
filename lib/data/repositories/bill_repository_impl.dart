import '../../domain/entities/bill.dart';
import '../../domain/repositories/bill_repository.dart';
import '../datasources/mock/mock_bill_data.dart';

/// [BillRepository] backed by [MockBillDataSource]. Swap the data source
/// for an API-backed one later without touching call sites -- they only
/// depend on the [BillRepository] interface.
class BillRepositoryImpl implements BillRepository {
  const BillRepositoryImpl(this._dataSource);

  final MockBillDataSource _dataSource;

  @override
  Future<List<Bill>> getBills() => _dataSource.getBills();

  @override
  Future<Bill> setPaid(String billId, bool isPaid) =>
      _dataSource.setPaid(billId, isPaid);
}
