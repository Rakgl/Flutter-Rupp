part of 'message_cubit.dart';

enum ChatMessageType { text, image, file, audio }

class MessageGroup extends Equatable {
  const MessageGroup({
    required this.name,
    required this.service,
    required this.lastMessage,
    required this.time,
    this.isOnline = false,
    this.avatarUrl,
  });

  final String name;
  final String service;
  final String lastMessage;
  final String time;
  final bool isOnline;
  final String? avatarUrl;

  @override
  List<Object?> get props => [name, service, lastMessage, time, isOnline, avatarUrl];
}

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.text,
    required this.time,
    this.isMe = false,
    this.isRead = false,
    this.type = ChatMessageType.text,
    this.attachmentPath,
  });

  final String text;
  final String time;
  final bool isMe;
  final bool isRead;
  final ChatMessageType type;
  final String? attachmentPath;

  @override
  List<Object?> get props => [text, time, isMe, isRead, type, attachmentPath];
}

class MessageState extends Equatable {
  const MessageState({
    this.groups = const [],
    this.activeChat = const [],
    this.searchQuery = '',
  });

  final List<MessageGroup> groups;
  final List<ChatMessage> activeChat;
  final String searchQuery;

  List<MessageGroup> get filteredGroups {
    if (searchQuery.isEmpty) return groups;
    return groups
        .where((group) =>
            group.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  List<Object?> get props => [groups, activeChat, searchQuery];
}
