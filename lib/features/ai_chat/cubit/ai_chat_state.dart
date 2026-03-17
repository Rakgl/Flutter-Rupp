part of 'ai_chat_cubit.dart';

const _sentinel = Object();

enum AiChatStatus { initial, loading, success, failure, sending }

class AiChatState extends Equatable {
  const AiChatState({
    this.status = AiChatStatus.initial,
    this.conversations = const [],
    this.messages = const [],
    this.currentConversationId,
    this.errorMessage,
  });

  final AiChatStatus status;
  final List<AiConversation> conversations;
  final List<AiMessage> messages;
  final String? currentConversationId;
  final String? errorMessage;

  AiChatState copyWith({
    AiChatStatus? status,
    List<AiConversation>? conversations,
    List<AiMessage>? messages,
    Object? currentConversationId = _sentinel,
    String? errorMessage,
  }) {
    return AiChatState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      messages: messages ?? this.messages,
      currentConversationId: currentConversationId == _sentinel
          ? this.currentConversationId
          : currentConversationId as String?,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        conversations,
        messages,
        currentConversationId,
        errorMessage,
      ];
}
