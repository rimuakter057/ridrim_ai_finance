/// Who authored a [ChatMessage].
enum ChatMessageSender { user, ai }

/// A single message in an AI chat conversation.
///
/// Pure domain entity -- no Flutter or data-layer dependencies.
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
    this.imagePath,
    this.chartValues,
    this.chartLabels,
  });

  final String id;
  final String content;
  final ChatMessageSender sender;
  final DateTime timestamp;

  /// Local file path of an attached image, if this message carries one.
  final String? imagePath;

  /// Optional data series for an inline chart rendered under an AI reply
  /// (e.g. a 7-day cash-flow trend). Plain numbers/strings only -- no
  /// Flutter or charting-library types leak into the domain layer.
  final List<double>? chartValues;
  final List<String>? chartLabels;

  bool get isFromUser => sender == ChatMessageSender.user;
  bool get hasImage => imagePath != null;
  bool get hasChart => chartValues != null && chartValues!.isNotEmpty;
}
