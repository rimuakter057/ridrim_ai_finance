import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/mock/mock_chat_data.dart';

/// [ChatRepository] backed by [MockChatDataSource]. Swap the data source
/// for an API-backed one later without touching call sites -- they only
/// depend on the [ChatRepository] interface.
class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl(this._dataSource);

  final MockChatDataSource _dataSource;

  @override
  Future<List<ChatMessage>> getChatHistory() => _dataSource.getMessages();

  @override
  Future<ChatMessage> sendMessage(String content) =>
      _dataSource.generateReply(content);
}
