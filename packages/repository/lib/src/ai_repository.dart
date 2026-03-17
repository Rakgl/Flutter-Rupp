import 'package:api_http_client/api_http_client.dart';
import 'package:api_http_client/src/response/ai_response.dart';

class AiRepository {
  AiRepository({
    required ApiHttpClient apiClient,
  }) : _apiClient = apiClient;

  final ApiHttpClient _apiClient;

  Future<Either<String, AiAskResponse>> askAi({
    required String prompt,
    String? conversationId,
  }) {
    return _apiClient.askAi(prompt: prompt, conversationId: conversationId);
  }

  Future<Either<String, AiConversationListResponse>> getConversations({
    int page = 1,
  }) {
    return _apiClient.getAiConversations(page: page);
  }

  Future<Either<String, AiMessageListResponse>> getMessages({
    required String conversationId,
    int page = 1,
  }) {
    return _apiClient.getAiMessages(conversationId: conversationId, page: page);
  }

  Future<Either<String, bool>> deleteConversation({
    required String conversationId,
  }) {
    return _apiClient.deleteAiConversation(conversationId: conversationId);
  }
}
