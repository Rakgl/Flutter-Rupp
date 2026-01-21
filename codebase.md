# cubit/message_cubit.dart

```dart
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

```

# cubit/message_state.dart

```dart
part of 'message_cubit.dart';

class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

```

# message.dart

```dart
export './cubit/message_cubit.dart';
export './view/view.dart';

```

# view/chat_detail_page.dart

```dart
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_super_aslan_app/features/message/message.dart';

class ChatDetailPage extends StatelessWidget {
  const ChatDetailPage({super.key, required this.user});
  final MessageGroup user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(IconlyLight.arrowLeft, color: AppColors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Text(
                user.name[0],
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                Row(
                  children: [
                    if (user.isOnline)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 4),
                        decoration: const BoxDecoration(
                          color: AppColors.growthSuccess,
                          shape: BoxShape.circle,
                        ),
                      ),
                    Text(
                      user.isOnline ? 'Online' : 'Offline',
                      style: TextStyle(
                        fontSize: 12,
                        color: user.isOnline
                            ? AppColors.growthSuccess
                            : AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(IconlyLight.call, color: AppColors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(IconlyLight.video, color: AppColors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(IconlyLight.moreCircle, color: AppColors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<MessageCubit, MessageState>(
              builder: (context, state) {
                return ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: state.activeChat.length,
                  itemBuilder: (context, index) {
                    final msg = state.activeChat[index];
                    return _ChatBubble(message: msg);
                  },
                );
              },
            ),
          ),
          const _MessageInput(),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(AppSpacing.md),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: isMe ? AppColors.white : AppColors.black,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.time,
                  style: TextStyle(
                    fontSize: 10,
                    color: (isMe ? AppColors.white : AppColors.grey)
                        .withValues(alpha: 0.8),
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.isRead ? IconlyLight.tickSquare : IconlyLight.tickSquare, // Iconly doesn't have double tick, using tickSquare for read
                    size: 14,
                    color: message.isRead
                        ? AppColors.white
                        : AppColors.white.withValues(alpha: 0.5),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageInput extends StatelessWidget {
  const _MessageInput();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(IconlyLight.paperUpload, color: AppColors.grey),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(IconlyLight.image, color: AppColors.grey),
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.grey.shade100,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: AppColors.grey, fontSize: 14),
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: 22,
              child: IconButton(
                icon: const Icon(IconlyBold.send, color: AppColors.white, size: 20),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

```

# view/message_page.dart

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_super_aslan_app/features/message/message.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MessageCubit(),
      child: const MessageView(),
    );
  }
}

class MessageView extends StatelessWidget {
  const MessageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageCubit, MessageState>(
      builder: (context, state) {
        // TODO: return correct widget based on the state.
        return const SizedBox();
      },
    );
  }
}

```

# view/view.dart

```dart
export './message_page.dart';

```

