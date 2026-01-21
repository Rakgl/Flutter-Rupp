import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(const MessageState()) {
    _loadInitialData();
  }

  void _loadInitialData() {
    emit(const MessageState(
      groups: [
        MessageGroup(
          name: 'Sue Storm',
          service: 'Electrical Panel Upgrade',
          lastMessage: 'What time works best for you?',
          time: '5 min ago',
          isOnline: true,
        ),
        MessageGroup(
          name: 'Clint Barton',
          service: 'Lighting Installation',
          lastMessage: 'Thank you! The work looks great.',
          time: '2 hours ago',
        ),
        MessageGroup(
          name: 'Peter Parker',
          service: 'Circuit Breaker Repair',
          lastMessage: 'Do you have availability this week?',
          time: '1 day ago',
          isOnline: true,
        ),
        MessageGroup(
          name: 'Sam Wilson',
          service: 'Wiring & Rewiring',
          lastMessage: 'Sounds good, see you then!',
          time: '2 days ago',
        ),
      ],
      activeChat: [
        ChatMessage(text: 'Hi! I saw your proposal for the electrical panel upgrade.', time: '10:32 AM', isMe: false),
        ChatMessage(text: 'Hello Sue! Yes, I can help with that. When would be a good time for you?', time: '10:33 AM', isMe: true, isRead: true),
        ChatMessage(text: "I'm flexible this week. Do you have availability on Thursday or Friday?", time: '10:35 AM', isMe: false),
        ChatMessage(text: "Thursday at 10 AM works perfectly for me. I'll bring all necessary equipment.", time: '10:36 AM', isMe: true, isRead: true),
        ChatMessage(text: 'What time works best for you?', time: '10:38 AM', isMe: false),
      ],
    ));
  }

  void updateSearch(String query) {
    emit(MessageState(
      groups: state.groups,
      activeChat: state.activeChat,
      searchQuery: query,
    ));
  }
}
