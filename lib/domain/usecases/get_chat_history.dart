import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

/// Fetches the current chat's message history.
class GetChatHistory {
  const GetChatHistory(this._repository);

  final ChatRepository _repository;

  Future<List<ChatMessage>> call() => _repository.getChatHistory();
}
