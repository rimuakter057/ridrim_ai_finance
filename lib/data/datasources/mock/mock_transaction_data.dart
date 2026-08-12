import '../../../domain/entities/transaction.dart';
import '../../models/transaction_model.dart';

/// In-memory mock data source standing in for a real transactions API.
///
/// [_transactions] is `static` so every instance shares the same in-memory
/// list -- additions made from one screen (e.g. Add Transaction) are
/// visible from any other screen without a DI container.
class MockTransactionDataSource {
  const MockTransactionDataSource();

  static final DateTime _now = DateTime.now();

  static DateTime _daysAgo(int days, [int hour = 12]) =>
      DateTime(_now.year, _now.month, _now.day - days, hour);

  static final List<TransactionModel> _seedTransactions = [
    TransactionModel(
      id: 'txn_pay_1',
      accountId: 'acc_checking',
      title: 'Payroll Deposit',
      category: TransactionCategory.income,
      amount: 3200,
      type: TransactionType.income,
      date: _daysAgo(2, 9),
      merchant: 'Acme Corp',
    ),
    TransactionModel(
      id: 'txn_pay_2',
      accountId: 'acc_checking',
      title: 'Payroll Deposit',
      category: TransactionCategory.income,
      amount: 3200,
      type: TransactionType.income,
      date: _daysAgo(16, 9),
      merchant: 'Acme Corp',
    ),
    TransactionModel(
      id: 'txn_rent',
      accountId: 'acc_checking',
      title: 'Rent',
      category: TransactionCategory.billsUtilities,
      amount: 1450,
      type: TransactionType.expense,
      date: _daysAgo(3, 8),
      merchant: 'Maple Court Apartments',
    ),
    TransactionModel(
      id: 'txn_electric',
      accountId: 'acc_checking',
      title: 'Electric Bill',
      category: TransactionCategory.billsUtilities,
      amount: 118.42,
      type: TransactionType.expense,
      date: _daysAgo(6),
      merchant: 'City Power & Light',
    ),
    TransactionModel(
      id: 'txn_internet',
      accountId: 'acc_checking',
      title: 'Internet',
      category: TransactionCategory.billsUtilities,
      amount: 79.99,
      type: TransactionType.expense,
      date: _daysAgo(9),
      merchant: 'Fiberlink',
    ),
    TransactionModel(
      id: 'txn_grocery_1',
      accountId: 'acc_credit',
      title: 'Groceries',
      category: TransactionCategory.groceries,
      amount: 112.34,
      type: TransactionType.expense,
      date: _daysAgo(1, 18),
      merchant: 'Greenfield Market',
    ),
    TransactionModel(
      id: 'txn_grocery_2',
      accountId: 'acc_credit',
      title: 'Groceries',
      category: TransactionCategory.groceries,
      amount: 86.10,
      type: TransactionType.expense,
      date: _daysAgo(5, 17),
      merchant: 'Greenfield Market',
    ),
    TransactionModel(
      id: 'txn_grocery_3',
      accountId: 'acc_credit',
      title: 'Groceries',
      category: TransactionCategory.groceries,
      amount: 64.55,
      type: TransactionType.expense,
      date: _daysAgo(11, 17),
      merchant: 'Corner Grocer',
    ),
    TransactionModel(
      id: 'txn_grocery_4',
      accountId: 'acc_credit',
      title: 'Groceries',
      category: TransactionCategory.groceries,
      amount: 77.23,
      type: TransactionType.expense,
      date: _daysAgo(18, 16),
      merchant: 'Greenfield Market',
    ),
    TransactionModel(
      id: 'txn_coffee_1',
      accountId: 'acc_credit',
      title: 'Coffee',
      category: TransactionCategory.food,
      amount: 5.75,
      type: TransactionType.expense,
      date: _daysAgo(0, 8),
      merchant: 'Daily Grind Coffee',
    ),
    TransactionModel(
      id: 'txn_lunch_1',
      accountId: 'acc_credit',
      title: 'Lunch',
      category: TransactionCategory.food,
      amount: 18.40,
      type: TransactionType.expense,
      date: _daysAgo(1, 13),
      merchant: 'Basil & Vine',
    ),
    TransactionModel(
      id: 'txn_dinner_1',
      accountId: 'acc_credit',
      title: 'Dinner',
      category: TransactionCategory.food,
      amount: 54.20,
      type: TransactionType.expense,
      date: _daysAgo(4, 20),
      merchant: 'Ember Grill',
    ),
    TransactionModel(
      id: 'txn_coffee_2',
      accountId: 'acc_credit',
      title: 'Coffee',
      category: TransactionCategory.food,
      amount: 6.25,
      type: TransactionType.expense,
      date: _daysAgo(7, 9),
      merchant: 'Daily Grind Coffee',
    ),
    TransactionModel(
      id: 'txn_takeout_1',
      accountId: 'acc_credit',
      title: 'Takeout',
      category: TransactionCategory.food,
      amount: 32.60,
      type: TransactionType.expense,
      date: _daysAgo(10, 19),
      merchant: 'Golden Wok',
    ),
    TransactionModel(
      id: 'txn_gas_1',
      accountId: 'acc_checking',
      title: 'Gas',
      category: TransactionCategory.transport,
      amount: 48.30,
      type: TransactionType.expense,
      date: _daysAgo(2, 17),
      merchant: 'Shell',
    ),
    TransactionModel(
      id: 'txn_rideshare_1',
      accountId: 'acc_credit',
      title: 'Rideshare',
      category: TransactionCategory.transport,
      amount: 22.15,
      type: TransactionType.expense,
      date: _daysAgo(8, 22),
      merchant: 'RideNow',
    ),
    TransactionModel(
      id: 'txn_transit_1',
      accountId: 'acc_checking',
      title: 'Transit Pass',
      category: TransactionCategory.transport,
      amount: 65,
      type: TransactionType.expense,
      date: _daysAgo(15, 8),
      merchant: 'City Transit',
    ),
    TransactionModel(
      id: 'txn_shopping_1',
      accountId: 'acc_credit',
      title: 'New Headphones',
      category: TransactionCategory.shopping,
      amount: 149.99,
      type: TransactionType.expense,
      date: _daysAgo(3, 14),
      merchant: 'TechMart',
    ),
    TransactionModel(
      id: 'txn_shopping_2',
      accountId: 'acc_credit',
      title: 'Clothing',
      category: TransactionCategory.shopping,
      amount: 88.40,
      type: TransactionType.expense,
      date: _daysAgo(9, 15),
      merchant: 'Northline Apparel',
    ),
    TransactionModel(
      id: 'txn_shopping_3',
      accountId: 'acc_credit',
      title: 'Home Goods',
      category: TransactionCategory.shopping,
      amount: 41.10,
      type: TransactionType.expense,
      date: _daysAgo(13, 12),
      merchant: 'Nestwell Home',
    ),
    TransactionModel(
      id: 'txn_streaming_1',
      accountId: 'acc_credit',
      title: 'Streaming Subscription',
      category: TransactionCategory.entertainment,
      amount: 15.99,
      type: TransactionType.expense,
      date: _daysAgo(4, 10),
      merchant: 'StreamPlex',
    ),
    TransactionModel(
      id: 'txn_movies_1',
      accountId: 'acc_credit',
      title: 'Movie Night',
      category: TransactionCategory.entertainment,
      amount: 34.50,
      type: TransactionType.expense,
      date: _daysAgo(12, 21),
      merchant: 'Cinepolis',
    ),
    TransactionModel(
      id: 'txn_pharmacy_1',
      accountId: 'acc_checking',
      title: 'Pharmacy',
      category: TransactionCategory.health,
      amount: 24.80,
      type: TransactionType.expense,
      date: _daysAgo(6, 16),
      merchant: 'CarePlus Pharmacy',
    ),
    TransactionModel(
      id: 'txn_gym_1',
      accountId: 'acc_checking',
      title: 'Gym Membership',
      category: TransactionCategory.health,
      amount: 45,
      type: TransactionType.expense,
      date: _daysAgo(17, 7),
      merchant: 'FitZone',
    ),
    TransactionModel(
      id: 'txn_flight_1',
      accountId: 'acc_credit',
      title: 'Flight Booking',
      category: TransactionCategory.travel,
      amount: 318.20,
      type: TransactionType.expense,
      date: _daysAgo(20, 11),
      merchant: 'SkyRoute Airlines',
    ),
    TransactionModel(
      id: 'txn_misc_1',
      accountId: 'acc_checking',
      title: 'Gift',
      category: TransactionCategory.other,
      amount: 30,
      type: TransactionType.expense,
      date: _daysAgo(14, 15),
      merchant: 'Card & Co.',
    ),
  ];

  static final List<TransactionModel> _transactions =
      List.of(_seedTransactions);

  Future<List<Transaction>> getTransactions() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List.of(_transactions);
  }

  Future<Transaction> addTransaction(Transaction transaction) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final TransactionModel model = TransactionModel(
      id: transaction.id,
      accountId: transaction.accountId,
      title: transaction.title,
      category: transaction.category,
      amount: transaction.amount,
      type: transaction.type,
      date: transaction.date,
      merchant: transaction.merchant,
      note: transaction.note,
    );
    _transactions.insert(0, model);
    return model;
  }
}
