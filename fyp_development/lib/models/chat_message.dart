import 'package:hive/hive.dart';
import '../core/constants/hive_constants.dart';

part 'chat_message.g.dart';

/// A single message in the AI chat conversation.
/// isUser=true → displayed on the right (user bubble)
/// isUser=false → displayed on the left (AI bubble)
@HiveType(typeId: kChatMessageTypeId)
class ChatMessage extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String content;

  /// true = message from user, false = response from AI
  @HiveField(2)
  final bool isUser;

  @HiveField(3)
  final DateTime timestamp;

  /// true = this message represents an error state (shown with error styling)
  @HiveField(4)
  final bool isError;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.isError = false,
  });

  factory ChatMessage.fromUser(String content) => ChatMessage(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        content: content,
        isUser: true,
        timestamp: DateTime.now(),
      );

  factory ChatMessage.fromAI(String content) => ChatMessage(
        id: '${DateTime.now().microsecondsSinceEpoch}_ai',
        content: content,
        isUser: false,
        timestamp: DateTime.now(),
      );

  factory ChatMessage.error(String errorMessage) => ChatMessage(
        id: '${DateTime.now().microsecondsSinceEpoch}_err',
        content: errorMessage,
        isUser: false,
        timestamp: DateTime.now(),
        isError: true,
      );
}
