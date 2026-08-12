import '../../domain/entities/chat_message.dart';

/// Data-layer representation of [ChatMessage]. Kept separate from the
/// domain entity so JSON (de)serialization can be added here later
/// without leaking data-layer concerns into the domain layer.
class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    required super.id,
    required super.content,
    required super.sender,
    required super.timestamp,
    super.imagePath,
    super.chartValues,
    super.chartLabels,
  });

  factory ChatMessageModel.fromEntity(ChatMessage entity) {
    return ChatMessageModel(
      id: entity.id,
      content: entity.content,
      sender: entity.sender,
      timestamp: entity.timestamp,
      imagePath: entity.imagePath,
      chartValues: entity.chartValues,
      chartLabels: entity.chartLabels,
    );
  }
}
