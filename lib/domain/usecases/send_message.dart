import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

/// Sends a user message and returns the assistant's reply.
class SendMessage {
  const SendMessage(this._repository);

  final ChatRepository _repository;

  Future<ChatMessage> call(String content) =>
      _repository.sendMessage(content);
}
