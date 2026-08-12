import '../../../core/utils/helpers.dart';
import '../../../core/utils/transaction_category_style.dart';
import '../../../domain/entities/budget.dart';
import '../../../domain/entities/chat_message.dart';
import '../../../domain/entities/transaction.dart';
import '../../models/chat_message_model.dart';
import 'mock_budget_data.dart';
import 'mock_transaction_data.dart';

/// In-memory mock data source standing in for a real AI finance-assistant
/// API. Answers are generated with simple keyword matching over the mock
/// transactions/budgets rather than a canned response bank -- the
/// assistant reasons over the user's actual (mock) financial data.
class MockChatDataSource {
  const MockChatDataSource();

  static final DateTime _now = DateTime.now();

  static final List<ChatMessageModel> _seedHistory = [
    ChatMessageModel(
      id: AppHelpers.generateId(),
      content: "Hi! I'm your AI finance assistant. Ask me things like "
          '"Where did I overspend?" or "Show my spending trend" and '
          "I'll pull the answer from your accounts.",
      sender: ChatMessageSender.ai,
      timestamp: _now.subtract(const Duration(minutes: 2)),
    ),
  ];

  static const List<String> _weekdayLabels = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];

  Future<List<ChatMessageModel>> getMessages() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List.of(_seedHistory);
  }

  Future<ChatMessageModel> generateReply(String userMessage) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final String q = userMessage.toLowerCase();
    final List<Transaction> transactions =
        await const MockTransactionDataSource().getTransactions();
    final List<Budget> budgets = await const MockBudgetDataSource().getBudgets();

    if (q.contains('overspend') || q.contains('over budget')) {
      return _replyToOverspend(budgets);
    }
    if (q.contains('trend') || q.contains('cash flow')) {
      return _replyWithTrend(transactions);
    }
    if (q.contains('savings goal') || q.contains('on track')) {
      return _reply(
        "Savings goals are coming soon — once you set one, I'll track "
        'your progress right here in chat.',
      );
    }
    if (q.contains('sent an image')) {
      return _reply(
        "Thanks for the photo! I can't read receipts yet, but you can "
        'log that purchase manually from the Transactions tab.',
      );
    }

    for (final TransactionCategory category in TransactionCategory.values) {
      if (category == TransactionCategory.income) continue;
      if (q.contains(category.label.toLowerCase()) ||
          q.contains(category.name.toLowerCase())) {
        return _replyWithCategorySpend(transactions, category);
      }
    }

    return _replyWithTopCategory(transactions);
  }

  ChatMessageModel _reply(String content, {List<double>? values, List<String>? labels}) {
    return ChatMessageModel(
      id: AppHelpers.generateId(),
      content: content,
      sender: ChatMessageSender.ai,
      timestamp: DateTime.now(),
      chartValues: values,
      chartLabels: labels,
    );
  }

  ChatMessageModel _replyToOverspend(List<Budget> budgets) {
    final List<Budget> over = budgets.where((b) => b.isOverLimit).toList()
      ..sort((a, b) => (b.spent - b.limit).compareTo(a.spent - a.limit));

    if (over.isEmpty) {
      return _reply(
        "Good news — you're within budget in every category this month.",
      );
    }

    final Budget worst = over.first;
    return _reply(
      "You're ${AppHelpers.formatCurrency(worst.spent - worst.limit)} over "
      'your ${worst.category.label} budget this month '
      '(${AppHelpers.formatCurrency(worst.spent)} of '
      '${AppHelpers.formatCurrency(worst.limit)}).',
    );
  }

  ChatMessageModel _replyWithTrend(List<Transaction> transactions) {
    final List<double> values = [];
    final List<String> labels = [];
    for (int i = 6; i >= 0; i--) {
      final DateTime day = DateTime(_now.year, _now.month, _now.day - i);
      final double net = transactions
          .where((t) =>
              t.date.year == day.year &&
              t.date.month == day.month &&
              t.date.day == day.day)
          .fold(0.0, (sum, t) => sum + t.signedAmount);
      values.add(net);
      labels.add(_weekdayLabels[day.weekday - 1]);
    }
    return _reply(
      "Here's your net cash flow over the last 7 days.",
      values: values,
      labels: labels,
    );
  }

  ChatMessageModel _replyWithCategorySpend(
    List<Transaction> transactions,
    TransactionCategory category,
  ) {
    final double spent = transactions
        .where((t) =>
            t.category == category &&
            t.type == TransactionType.expense &&
            t.date.year == _now.year &&
            t.date.month == _now.month)
        .fold(0.0, (sum, t) => sum + t.amount);

    if (spent == 0) {
      return _reply("You haven't spent anything on ${category.label} yet this month.");
    }
    return _reply(
      "You've spent ${AppHelpers.formatCurrency(spent)} on "
      '${category.label} this month.',
    );
  }

  ChatMessageModel _replyWithTopCategory(List<Transaction> transactions) {
    final Map<TransactionCategory, double> totals = {};
    for (final Transaction t in transactions) {
      if (t.type != TransactionType.expense) continue;
      if (t.date.year != _now.year || t.date.month != _now.month) continue;
      totals.update(t.category, (v) => v + t.amount, ifAbsent: () => t.amount);
    }
    if (totals.isEmpty) {
      return _reply(
        "You don't have any spending recorded this month yet.",
      );
    }
    final MapEntry<TransactionCategory, double> top =
        totals.entries.reduce((a, b) => a.value > b.value ? a : b);
    return _reply(
      'Your biggest spend this month is ${top.key.label} at '
      '${AppHelpers.formatCurrency(top.value)}. Ask me about a specific '
      "category, your budgets, or your spending trend for more.",
    );
  }
}
