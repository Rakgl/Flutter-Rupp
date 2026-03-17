import 'package:api_http_client/src/response/base_response.dart';

class AiAskResponse extends BaseResponse {
  AiAskResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    final data = json.getMapOrDefault('data');
    conversationId = data.getStringOrDefault('conversation_id');
    reply = data.getStringOrDefault('reply');
  }

  late String conversationId;
  late String reply;
}

class AiConversationListResponse extends BaseResponse {
  AiConversationListResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    final data = json.getMapOrDefault('data');
    currentPage = data.getIntOrDefault('current_page');
    perPage = data.getIntOrDefault('per_page');
    total = data.getIntOrDefault('total');
    conversations = data
        .getListOrDefault('data')
        .map(AiConversation.fromJson)
        .toList();
  }

  late int currentPage;
  late int perPage;
  late int total;
  late List<AiConversation> conversations;
}

class AiConversation {
  AiConversation.fromJson(Map<String, dynamic> json) {
    conversationId = json.getStringOrDefault('conversation_id');
    title = json.getStringOrDefault('title');
    messageCount = json.getIntOrDefault('message_count');
    lastActive = json.getStringOrDefault('last_active');
  }

  late String conversationId;
  late String title;
  late int messageCount;
  late String lastActive;
}

class AiMessageListResponse extends BaseResponse {
  AiMessageListResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    final data = json.getMapOrDefault('data');
    currentPage = data.getIntOrDefault('current_page');
    perPage = data.getIntOrDefault('per_page');
    total = data.getIntOrDefault('total');
    messages = data
        .getListOrDefault('data')
        .map(AiMessage.fromJson)
        .toList();
  }

  late int currentPage;
  late int perPage;
  late int total;
  late List<AiMessage> messages;
}

class AiMessage {
  AiMessage.fromJson(Map<String, dynamic> json) {
    role = json.getStringOrDefault('role');
    message = json.getStringOrDefault('message');
    createdAt = json.getStringOrDefault('created_at');
  }

  late String role;
  late String message;
  late String createdAt;
}
