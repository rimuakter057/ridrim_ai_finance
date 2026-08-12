import '../entities/chat_message.dart';

/// Contract for retrieving and sending chat messages. Implemented against
/// the mock data source today, and against a real API data source once
/// the backend exists.
abstract class ChatRepository {
  Future<List<ChatMessage>> getChatHistory();

  /// Sends [content] as the current user and returns the assistant's
  /// reply.
  Future<ChatMessage> sendMessage(String content);
}
