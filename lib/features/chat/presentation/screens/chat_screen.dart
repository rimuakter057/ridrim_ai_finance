import 'package:flutter/material.dart';

import '../../../../domain/entities/chat_message.dart';
import '../state/chat_controller.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/chat_message_list.dart';
import '../widgets/quick_prompt_row.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, this.showBackButton = true});


  final bool showBackButton;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<ChatMessage> _messages = [];
  bool _isLoadingHistory = true;
  bool _isAiTyping = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ── Scroll helper ────────────────────────────────────────────────────────

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  // ── Actions ──────────────────────────────────────────────────────────────

  Future<void> _loadHistory() async {
    final history = await loadChatHistory();
    if (!mounted) return;
    setState(() {
      _messages = history;
      _isLoadingHistory = false;
    });
    _scrollToBottom();
  }

  void _startNewChat() {
    setState(() => _messages = newChatMessages());
    _scrollToBottom();
  }

  Future<void> _handleSend(String text) async {
    if (text.trim().isEmpty) return;
    _inputController.clear();

    final userMsg = buildUserTextMessage(text);
    setState(() {
      _messages = [..._messages, userMsg];
      _isAiTyping = true;
    });
    _scrollToBottom();

    final reply = await sendUserMessage(text);
    if (!mounted) return;
    setState(() {
      _messages = [..._messages, reply];
      _isAiTyping = false;
    });
    _scrollToBottom();
  }

  Future<void> _handleImageAttachment(String imagePath) async {
    final userMsg = buildUserImageMessage(imagePath);
    setState(() {
      _messages = [..._messages, userMsg];
      _isAiTyping = true;
    });
    _scrollToBottom();

    final reply = await sendImagePromptReply();
    if (!mounted) return;
    setState(() {
      _messages = [..._messages, reply];
      _isAiTyping = false;
    });
    _scrollToBottom();
  }

  Future<void> _handleRegenerate() async {
    final last = lastUserMessage(_messages);
    if (last == null) return;

    setState(() => _isAiTyping = true);
    _scrollToBottom();

    final reply = await sendUserMessage(last.content);
    if (!mounted) return;
    setState(() {
      _messages = [..._messages, reply];
      _isAiTyping = false;
    });
    _scrollToBottom();
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(
        showBackButton: widget.showBackButton,
        onNewChat: _startNewChat,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ChatMessageList(
                messages: _messages,
                isLoading: _isLoadingHistory,
                isAiTyping: _isAiTyping,
                scrollController: _scrollController,
                onRegenerate: _handleRegenerate,
              ),
            ),
            QuickPromptRow(
              onSelectPrompt: (prompt) {
                _inputController.text = prompt;
                _handleSend(prompt);
              },
            ),
            ChatInputBar(
              controller: _inputController,
              enabled: !_isAiTyping,
              onSend: _handleSend,
              onImagePicked: _handleImageAttachment,
            ),
          ],
        ),
      ),
    );
  }
}
