import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';
import 'package:api_http_client/src/response/ai_response.dart';

part 'ai_chat_state.dart';

class AiChatCubit extends Cubit<AiChatState> {
  AiChatCubit({
    required AiRepository aiRepository,
  })  : _aiRepository = aiRepository,
        super(const AiChatState());

  final AiRepository _aiRepository;

  Future<void> fetchConversations() async {
    emit(state.copyWith(status: AiChatStatus.loading));
    final result = await _aiRepository.getConversations();
    result.fold(
      (error) => emit(state.copyWith(
        status: AiChatStatus.failure,
        errorMessage: error,
      )),
      (response) => emit(state.copyWith(
        status: AiChatStatus.success,
        conversations: response.conversations,
      )),
    );
  }

  Future<void> selectConversation(String conversationId) async {
    emit(state.copyWith(
      status: AiChatStatus.loading,
      currentConversationId: conversationId,
      messages: [],
    ));
    final result = await _aiRepository.getMessages(conversationId: conversationId);
    result.fold(
      (error) => emit(state.copyWith(
        status: AiChatStatus.failure,
        errorMessage: error,
      )),
      (response) => emit(state.copyWith(
        status: AiChatStatus.success,
        messages: response.messages,
      )),
    );
  }

  void startNewChat() {
    emit(state.copyWith(
      currentConversationId: null,
      messages: [],
      status: AiChatStatus.initial,
    ));
  }

  Future<void> sendMessage(String prompt) async {
    if (prompt.trim().isEmpty) return;

    // Optimistic update: add user message
    final userMessage = AiMessage.fromJson({
      'role': 'user',
      'message': prompt,
      'created_at': DateTime.now().toIso8601String(),
    });

    emit(state.copyWith(
      status: AiChatStatus.sending,
      messages: [...state.messages, userMessage],
    ));

    final result = await _aiRepository.askAi(
      prompt: prompt,
      conversationId: state.currentConversationId,
    );

    result.fold(
      (error) => emit(state.copyWith(
        status: AiChatStatus.failure,
        errorMessage: error,
      )),
      (response) {
        final aiReply = AiMessage.fromJson({
          'role': 'model',
          'message': response.reply,
          'created_at': DateTime.now().toIso8601String(),
        });

        emit(state.copyWith(
          status: AiChatStatus.success,
          currentConversationId: response.conversationId,
          messages: [...state.messages, aiReply],
        ));
        
        // Refresh conversation list in background
        fetchConversations();
      },
    );
  }

  Future<void> deleteConversation(String conversationId) async {
    final result = await _aiRepository.deleteConversation(conversationId: conversationId);
    result.fold(
      (error) => emit(state.copyWith(
        errorMessage: error,
      )),
      (_) {
        final updatedConversations = state.conversations
            .where((c) => c.conversationId != conversationId)
            .toList();
        
        if (state.currentConversationId == conversationId) {
          emit(state.copyWith(
            conversations: updatedConversations,
            currentConversationId: null,
            messages: [],
          ));
        } else {
          emit(state.copyWith(conversations: updatedConversations));
        }
      },
    );
  }
}
