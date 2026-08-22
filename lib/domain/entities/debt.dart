/// The kind of debt being tracked.
enum DebtType { creditCard, personalLoan, studentLoan, autoLoan, mortgage, other }

/// A single debt (credit card, loan, or mortgage) being tracked toward
/// payoff.
///
/// Pure domain entity -- no Flutter or data-layer dependencies.
class Debt {
  const Debt({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.originalAmount,
    required this.interestRate,
    required this.minimumPayment,
    required this.dueDate,
  });

  final String id;
  final String name;
  final DebtType type;

  /// Amount still owed.
  final double balance;

  /// The original loan/credit amount, used to compute payoff progress.
  final double originalAmount;

  /// Annual percentage rate, e.g. `24.99` for 24.99% APR.
  final double interestRate;
  final double minimumPayment;
  final DateTime dueDate;

  double get paidOffProgress => originalAmount <= 0
      ? 0
      : (1 - (balance / originalAmount)).clamp(0, 1);

  /// Rough months-to-payoff at the minimum payment only (ignores interest
  /// accrual -- a simple estimate, not a real amortization schedule).
  int get monthsToPayoffAtMinimum =>
      minimumPayment <= 0 ? 0 : (balance / minimumPayment).ceil();
}
