import '../../../domain/entities/bill.dart';
import '../../models/bill_model.dart';

/// In-memory mock data source standing in for a real bills API.
///
/// [_bills] is `static` so every instance shares the same in-memory list --
/// marking a bill paid from one screen is visible from any other.
class MockBillDataSource {
  const MockBillDataSource();

  static final DateTime _now = DateTime.now();

  static DateTime _daysFromNow(int days) =>
      DateTime(_now.year, _now.month, _now.day + days);

  static final List<BillModel> _bills = [
    BillModel(
      id: 'bill_rent',
      name: 'Rent',
      amount: 1450,
      dueDate: _daysFromNow(22),
      recurrence: BillRecurrence.monthly,
      payee: 'Maple Court Apartments',
    ),
    BillModel(
      id: 'bill_internet',
      name: 'Internet',
      amount: 79.99,
      dueDate: _daysFromNow(4),
      recurrence: BillRecurrence.monthly,
      payee: 'Fiberlink',
    ),
    BillModel(
      id: 'bill_electric',
      name: 'Electric Bill',
      amount: 118.42,
      dueDate: _daysFromNow(-2),
      recurrence: BillRecurrence.monthly,
      payee: 'City Power & Light',
    ),
    BillModel(
      id: 'bill_phone',
      name: 'Phone Plan',
      amount: 55,
      dueDate: _daysFromNow(9),
      recurrence: BillRecurrence.monthly,
      payee: 'Nova Mobile',
    ),
    BillModel(
      id: 'bill_streaming',
      name: 'Streaming Subscription',
      amount: 15.99,
      dueDate: _daysFromNow(12),
      recurrence: BillRecurrence.monthly,
      payee: 'StreamPlex',
    ),
    BillModel(
      id: 'bill_gym',
      name: 'Gym Membership',
      amount: 45,
      dueDate: _daysFromNow(-6),
      recurrence: BillRecurrence.monthly,
      isPaid: true,
      payee: 'FitZone',
    ),
    BillModel(
      id: 'bill_insurance',
      name: 'Car Insurance',
      amount: 612,
      dueDate: _daysFromNow(48),
      recurrence: BillRecurrence.yearly,
      payee: 'SafeDrive Insurance',
    ),
  ];

  Future<List<Bill>> getBills() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List.of(_bills);
  }

  Future<Bill> setPaid(String billId, bool isPaid) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final int index = _bills.indexWhere((b) => b.id == billId);
    if (index == -1) {
      throw ArgumentError('No bill with id $billId');
    }
    final BillModel updated = BillModel(
      id: _bills[index].id,
      name: _bills[index].name,
      amount: _bills[index].amount,
      dueDate: _bills[index].dueDate,
      recurrence: _bills[index].recurrence,
      isPaid: isPaid,
      payee: _bills[index].payee,
    );
    _bills[index] = updated;
    return updated;
  }
}
