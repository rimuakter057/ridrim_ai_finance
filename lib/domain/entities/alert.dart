/// What triggered an [Alert].
enum AlertType { budgetExceeded, billDue, lowBalance, unusualSpending, savingsMilestone }

/// How urgently an [Alert] should be surfaced.
enum AlertSeverity { info, warning, critical }

/// A single spending/account alert surfaced to the user.
///
/// Pure domain entity -- no Flutter or data-layer dependencies.
class Alert {
  const Alert({
    required this.id,
    required this.type,
    required this.severity,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });

  final String id;
  final AlertType type;
  final AlertSeverity severity;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  Alert copyWith({bool? isRead}) {
    return Alert(
      id: id,
      type: type,
      severity: severity,
      title: title,
      message: message,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}
