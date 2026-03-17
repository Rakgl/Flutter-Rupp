import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_methgo_app/features/ai_chat/cubit/ai_chat_cubit.dart';
import 'package:repository/repository.dart';
import 'package:api_http_client/src/response/ai_response.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  static const String path = '/ai-chat';

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _sidebarOpen = true;

  @override
  void initState() {
    super.initState();
    context.read<AiChatCubit>().fetchConversations();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _messageController.text;
    if (text.isNotEmpty) {
      context.read<AiChatCubit>().sendMessage(text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      drawer: isWide ? null : Drawer(child: _buildSidebar()),
      body: BlocConsumer<AiChatCubit, AiChatState>(
        listener: (context, state) {
          if (state.status == AiChatStatus.success ||
              state.status == AiChatStatus.sending) {
            _scrollToBottom();
          }
          if (state.status == AiChatStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          if (isWide) {
            return Row(
              children: [
                if (_sidebarOpen)
                  Container(
                    width: 280,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: _buildSidebar(),
                  ),
                Expanded(child: _buildChatArea(state, isWide: true)),
              ],
            );
          }
          return _buildChatArea(state, isWide: false);
        },
      ),
    );
  }

  // ─── Sidebar ───────────────────────────────────────────────────────

  Widget _buildSidebar() {
    return BlocBuilder<AiChatCubit, AiChatState>(
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: SafeArea(
            child: Column(
              children: [
                // New chat button
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.read<AiChatCubit>().startNewChat();
                        if (MediaQuery.of(context).size.width <= 600) {
                          Navigator.of(context).pop();
                        }
                      },
                      icon: Icon(Icons.add, size: 18, color: Colors.grey.shade700),
                      label: Text('New chat', style: TextStyle(color: Colors.grey.shade700)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),

                Divider(color: Colors.grey.shade200, height: 1),

                // Conversation list
                Expanded(
                  child: state.conversations.isEmpty
                      ? Center(
                          child: Text(
                            'No conversations yet',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 13,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: state.conversations.length,
                          itemBuilder: (context, index) {
                            final conv = state.conversations[index];
                            return _buildConversationTile(conv, state);
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildConversationTile(AiConversation conv, AiChatState state) {
    final isSelected = conv.conversationId == state.currentConversationId;

    return Dismissible(
      key: Key(conv.conversationId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: Colors.red.withOpacity(0.8),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 20),
      ),
      onDismissed: (_) {
        context.read<AiChatCubit>().deleteConversation(conv.conversationId);
      },
      child: InkWell(
        onTap: () {
          context.read<AiChatCubit>().selectConversation(conv.conversationId);
          if (MediaQuery.of(context).size.width <= 600) {
            Navigator.of(context).pop();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey.shade100 : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.chat_bubble_outline,
                  color: Colors.grey.shade500, size: 16),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  conv.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected ? Colors.black87 : Colors.grey.shade700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Chat Area ─────────────────────────────────────────────────────

  Widget _buildChatArea(AiChatState state, {required bool isWide}) {
    return Column(
      children: [
        // Top bar
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: Row(
            children: [
              if (isWide)
                IconButton(
                  icon: Icon(
                    _sidebarOpen ? Icons.menu_open : Icons.menu,
                    color: Colors.grey.shade700,
                  ),
                  onPressed: () {
                    setState(() => _sidebarOpen = !_sidebarOpen);
                  },
                )
              else
                Builder(
                  builder: (ctx) => IconButton(
                    icon: Icon(Icons.menu, color: Colors.grey.shade700),
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
                  ),
                ),
              const SizedBox(width: 4),
              const Text(
                'AI Assistant',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey.shade700),
                tooltip: 'Back',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),

        // Messages
        Expanded(child: _buildMessageArea(state)),

        // Input
        _buildMessageInput(state),
      ],
    );
  }

  // ─── Message Area ──────────────────────────────────────────────────

  Widget _buildMessageArea(AiChatState state) {
    if (state.messages.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount:
          state.messages.length + (state.status == AiChatStatus.sending ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.messages.length) {
          return _buildTypingIndicator();
        }
        return _buildMessageRow(state.messages[index]);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.smart_toy_outlined,
              size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'How can I help you today?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Ask me about your pets, products, or book an appointment.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageRow(AiMessage msg) {
    final isUser = msg.role == 'user';

    if (isUser) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 48),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  msg.message,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.smart_toy_outlined,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  msg.message,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: AppColors.scaffoldBackground,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.smart_toy_outlined,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 14),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SizedBox(
              width: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: const LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
                  minHeight: 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Input ─────────────────────────────────────────────────────────

  Widget _buildMessageInput(AiChatState state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                maxLines: 4,
                minLines: 1,
                decoration: const InputDecoration(
                  hintText: 'Message AI Assistant...',
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: SizedBox(
                width: 36,
                height: 36,
                child: IconButton(
                  icon: const Icon(Icons.arrow_upward, size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor: state.status == AiChatStatus.sending
                        ? Colors.grey.shade300
                        : const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed:
                      state.status == AiChatStatus.sending ? null : _sendMessage,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
