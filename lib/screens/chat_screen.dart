import 'package:flutter/material.dart';

import '../models/message_model.dart';
import '../services/firestore_service.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _service = FirestoreService();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('ClassBoard'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: FilledButton.tonalIcon(
              icon: const Icon(Icons.delete_sweep_rounded),
              label: const Text('Clear Chat'),
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.errorContainer,
                foregroundColor: theme.colorScheme.onErrorContainer,
              ),
              onPressed: () async {
                await _service.clearMessages();
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<Message>>(
                  stream: _service.messagesStream(),
                  builder: (context, snapshot) {
                    final messages = snapshot.data ?? [];

                    // Auto-scroll when new messages arrive.
                    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        return MessageBubble(message: msg);
                      },
                    );
                  },
                ),
              ),
              const Divider(height: 1),
              MessageInput(
                onSend: (text) async {
                  await _service.sendMessage(text);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
