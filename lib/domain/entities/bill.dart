/// How often a [Bill] recurs.
enum BillRecurrence { oneTime, weekly, monthly, yearly }

/// A bill that is due, or was recently paid.
///
/// Pure domain entity -- no Flutter or data-layer dependencies.
class Bill {
  const Bill({
    required this.id,
    required this.name,
    required this.amount,
    required this.dueDate,
    required this.recurrence,
    this.isPaid = false,
    this.payee,
  });

  final String id;
  final String name;
  final double amount;
  final DateTime dueDate;
  final BillRecurrence recurrence;
  final bool isPaid;
  final String? payee;

  bool get isOverdue => !isPaid && dueDate.isBefore(DateTime.now());
  int get daysUntilDue => dueDate.difference(DateTime.now()).inDays;

  Bill copyWith({bool? isPaid}) {
    return Bill(
      id: id,
      name: name,
      amount: amount,
      dueDate: dueDate,
      recurrence: recurrence,
      isPaid: isPaid ?? this.isPaid,
      payee: payee,
    );
  }
}
