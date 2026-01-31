import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:app_ui/app_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_super_aslan_app/features/message/message.dart';
import 'package:flutter_super_aslan_app/features/shared/widgets/global_app_bar.dart';
import 'package:flutter_super_aslan_app/features/shared/widgets/professional_background.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({super.key, required this.user});
  final MessageGroup user;

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.white,
      appBar: GlobalAppBar(
        title: '',
        backgroundColor: AppColors.white,
        elevation: 0.5,
        centerTitle: false,
        titleWidget: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primaryColor.withValues(alpha: 0.1),
              child: Text(
                widget.user.name[0],
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                Row(
                  children: [
                    if (widget.user.isOnline)
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
                      widget.user.isOnline ? 'Online' : 'Offline',
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.user.isOnline
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
      body: Stack(
        children: [
          const ProfessionalBackground(),
          Column(
            children: [
              Expanded(
                child: BlocBuilder<MessageCubit, MessageState>(
                  builder: (context, state) {
                    return ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.lg,
                      ),
                      itemCount: state.activeChat.length,
                      itemBuilder: (context, index) {
                        final msg = state.activeChat[state.activeChat.length - 1 - index];
                        return _ChatBubble(message: msg);
                      },
                    );
                  },
                ),
              ),
              _MessageInput(focusNode: _focusNode),
            ],
          ),
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
          color: isMe ? AppColors.primaryColor : AppColors.white,
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
            if (message.type == ChatMessageType.image && message.attachmentPath != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    message.attachmentPath!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, color: Colors.white),
                  ),
                ),
              )
            else if (message.type == ChatMessageType.file && message.attachmentPath != null)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(IconlyBold.document, color: isMe ? Colors.white : Colors.black54),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        message.text.isNotEmpty ? message.text : 'File Attachment',
                        style: TextStyle(
                           color: isMe ? Colors.white : Colors.black,
                           decoration: TextDecoration.underline,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )
            else if (message.type == ChatMessageType.audio)
               Row(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   Icon(Icons.play_arrow_rounded, color: isMe ? Colors.white : Colors.black),
                   const SizedBox(width: 4),
                   Container(
                     height: 4,
                     width: 100,
                     decoration: BoxDecoration(
                       color: isMe ? Colors.white54 : Colors.grey.shade300,
                       borderRadius: BorderRadius.circular(2),
                     ),
                   ),
                    const SizedBox(width: 8),
                   Text(
                     '0:05',
                     style: TextStyle(
                       fontSize: 12,
                       color: isMe ? Colors.white70 : Colors.black54,
                     ),
                   ),
                 ],
               )
            else
              Text(
                message.text,
                style: TextStyle(
                  color: isMe ? AppColors.white : AppColors.black,
                  fontSize: 15,
                ),
              ),
            if (message.type != ChatMessageType.audio) const SizedBox(height: 4),
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
                    message.isRead ? IconlyLight.tickSquare : IconlyLight.tickSquare,
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

class _MessageInput extends StatefulWidget {
  const _MessageInput({required this.focusNode});
  final FocusNode focusNode;

  @override
  State<_MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<_MessageInput> {
  final TextEditingController _textController = TextEditingController();
  final AudioRecorder _audioRecorder = AudioRecorder();
  
  bool _isRecording = false;
  bool _showActions = true;
  Timer? _timer;
  int _recordDuration = 0;
  StreamSubscription<Amplitude>? _amplitudeSub;
  double _currentAmplitude = -160;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (widget.focusNode.hasFocus && _showActions) {
      setState(() {
        _showActions = false;
      });
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    _timer?.cancel();
    _amplitudeSub?.cancel();
    _textController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      final message = ChatMessage(
        text: text,
        time: 'Now',
        isMe: true,
        isRead: false,
        type: ChatMessageType.text,
      );
      context.read<MessageCubit>().sendMessage(message);
      _textController.clear();
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (!mounted) return;
      final message = ChatMessage(
        text: 'Image',
        time: 'Now',
        isMe: true,
        isRead: false,
        type: ChatMessageType.image,
        attachmentPath: image.path,
      );
      context.read<MessageCubit>().sendMessage(message);
    }
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      if (!mounted) return;
      final message = ChatMessage(
        text: 'Photo',
        time: 'Now',
        isMe: true,
        isRead: false,
        type: ChatMessageType.image,
        attachmentPath: photo.path,
      );
      context.read<MessageCubit>().sendMessage(message);
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      if (!mounted) return;
      final message = ChatMessage(
        text: result.files.single.name,
        time: 'Now',
        isMe: true,
        isRead: false,
        type: ChatMessageType.file,
        attachmentPath: result.files.single.path,
      );
      context.read<MessageCubit>().sendMessage(message);
    }
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      _timer?.cancel();
      _amplitudeSub?.cancel();
      final path = await _audioRecorder.stop();
      setState(() { 
        _isRecording = false;
        _recordDuration = 0;
        _currentAmplitude = -160.0;
      });
      if (path != null) {
         if (!mounted) return;
         final message = ChatMessage(
          text: 'Audio Message',
          time: 'Now',
          isMe: true,
          isRead: false,
          type: ChatMessageType.audio,
          attachmentPath: path,
        );
        context.read<MessageCubit>().sendMessage(message);
      }
    } else {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
        await _audioRecorder.start(
          const RecordConfig(),
          path: path,
        );
        
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _recordDuration++;
          });
        });

        _amplitudeSub = _audioRecorder.onAmplitudeChanged(const Duration(milliseconds: 100)).listen((amp) {
           setState(() {
             _currentAmplitude = amp.current;
           });
        });

        setState(() => _isRecording = true);
      }
    }
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

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
            if (_showActions || _isRecording) ...[
              IconButton(
                icon: Icon(
                  _isRecording ? Icons.stop_circle_outlined : IconlyLight.voice,
                  color: _isRecording ? Colors.red : AppColors.grey,
                  size: _isRecording ? 32 : 24,
                ),
                onPressed: _toggleRecording,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              
              if (!_isRecording) ...[
                IconButton(
                  icon: const Icon(IconlyLight.paperUpload, color: AppColors.grey),
                  onPressed: _pickFile,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                IconButton(
                  icon: const Icon(IconlyLight.image, color: AppColors.grey),
                  onPressed: _pickImage,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                IconButton(
                  icon: const Icon(IconlyLight.camera, color: AppColors.grey),
                  onPressed: _takePhoto,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ] else ...[
              IconButton(
                icon: const Icon(IconlyLight.arrowRight, color: AppColors.grey),
                onPressed: () => setState(() => _showActions = true),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
            
            const SizedBox(width: 16),
            
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: AppSpacing.md, right: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: _isRecording ? Colors.red.shade50 : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: _isRecording ? Colors.red.withValues(alpha: 0.5) : AppColors.grey.shade300),
                ),
                child: _isRecording 
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                    child: Row(
                      children: [
                        FadeTransition(
                          opacity: AlwaysStoppedAnimation(1.0),
                          child: Container(
                            width: 8, 
                            height: 8, 
                            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatDuration(_recordDuration),
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(10, (index) {
                                double normalized = (_currentAmplitude + 60) / 60;
                                if (normalized < 0.1) normalized = 0.1;
                                if (normalized > 1.0) normalized = 1.0;
                                double heightFactor = normalized * (0.5 + 0.5 * Random().nextDouble());

                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 100),
                                  width: 4,
                                  height: 20 * heightFactor,
                                  decoration: BoxDecoration(
                                    color: Colors.red.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : TextField(
                  controller: _textController,
                  focusNode: widget.focusNode,
                  onChanged: (val) {
                    if (val.isNotEmpty && _showActions) {
                      setState(() => _showActions = false);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                    hintStyle: const TextStyle(color: AppColors.grey, fontSize: 14),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.emoji_emotions_outlined, color: AppColors.grey),
                      onPressed: () {}, 
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            
            if (!_isRecording) ...[
              const SizedBox(width: AppSpacing.sm),
              GestureDetector(
                onTap: _sendMessage,
                child: const CircleAvatar(
                  backgroundColor: AppColors.primaryColor,
                  radius: 22,
                  child: Icon(
                     IconlyBold.send,
                     color: AppColors.white, 
                     size: 20,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
