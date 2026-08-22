import '../../../domain/entities/debt.dart';
import '../../models/debt_model.dart';

/// In-memory mock data source standing in for a real debt-tracking API.
class MockDebtDataSource {
  const MockDebtDataSource();

  static final DateTime _now = DateTime.now();

  static final List<DebtModel> _debts = [
    DebtModel(
      id: 'debt_credit_card',
      name: 'Rewards Card',
      type: DebtType.creditCard,
      balance: 842.30,
      originalAmount: 2500,
      interestRate: 24.99,
      minimumPayment: 75,
      dueDate: DateTime(_now.year, _now.month, _now.day + 18),
    ),
    DebtModel(
      id: 'debt_student_loan',
      name: 'Student Loan',
      type: DebtType.studentLoan,
      balance: 14200,
      originalAmount: 22000,
      interestRate: 5.5,
      minimumPayment: 220,
      dueDate: DateTime(_now.year, _now.month, _now.day + 9),
    ),
    DebtModel(
      id: 'debt_auto_loan',
      name: 'Car Loan',
      type: DebtType.autoLoan,
      balance: 8750,
      originalAmount: 18000,
      interestRate: 6.9,
      minimumPayment: 340,
      dueDate: DateTime(_now.year, _now.month, _now.day + 4),
    ),
  ];

  Future<List<Debt>> getDebts() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List.of(_debts);
  }
}
