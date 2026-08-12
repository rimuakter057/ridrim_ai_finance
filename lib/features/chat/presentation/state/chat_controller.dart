import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../data/datasources/mock/mock_chat_data.dart';
import '../../../../data/repositories/chat_repository_impl.dart';
import '../../../../domain/entities/chat_message.dart';
import '../../../../domain/repositories/chat_repository.dart';
import '../../../../domain/usecases/get_chat_history.dart';
import '../../../../domain/usecases/send_message.dart';


final ChatRepository _chatRepository =
    const ChatRepositoryImpl(MockChatDataSource());
final GetChatHistory _getChatHistory = GetChatHistory(_chatRepository);
final SendMessage _sendMessage = SendMessage(_chatRepository);


/// Loads the mock chat history and returns the message list.
Future<List<ChatMessage>> loadChatHistory() async {
  return _getChatHistory();
}

/// Returns a fresh welcome message for a new chat session.
List<ChatMessage> newChatMessages() {
  return [
    ChatMessage(
      id: AppHelpers.generateId(),
      content: "Hi! I'm your AI finance assistant. Ask me about your "
          'spending, budgets, or cash flow.',
      sender: ChatMessageSender.ai,
      timestamp: DateTime.now(),
    ),
  ];
}


Future<ChatMessage> sendUserMessage(String text) async {
  return _sendMessage(text);
}

/// Builds the user [ChatMessage] for a plain text input.
ChatMessage buildUserTextMessage(String text) {
  return ChatMessage(
    id: AppHelpers.generateId(),
    content: text,
    sender: ChatMessageSender.user,
    timestamp: DateTime.now(),
  );
}

/// Builds the user [ChatMessage] for an image attachment.
ChatMessage buildUserImageMessage(String imagePath) {
  return ChatMessage(
    id: AppHelpers.generateId(),
    content: '',
    sender: ChatMessageSender.user,
    timestamp: DateTime.now(),
    imagePath: imagePath,
  );
}

/// Finds the last user message in [messages] to use for regeneration.
ChatMessage? lastUserMessage(List<ChatMessage> messages) {
  try {
    return messages.lastWhere((m) => m.isFromUser);
  } catch (_) {
    return messages.isNotEmpty ? messages.first : null;
  }
}

/// Sends the image-attachment prompt and returns the AI reply.
Future<ChatMessage> sendImagePromptReply() async {
  return _sendMessage(AppStrings.imageAttachmentPrompt);
}
