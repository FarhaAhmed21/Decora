import 'package:decora/src/features/chat/repository/chat_message.dart';
import 'package:decora/src/features/chat/repository/chat_service.dart';
import 'package:decora/src/features/chat/widgets/message_widget.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String adminId;
  final String currentUserId;

  const ChatScreen({
    super.key,
    required this.userId,
    required this.adminId,
    required this.currentUserId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    if (widget.currentUserId == widget.adminId) {
      _chatService.sendMessageFromAdmin(widget.adminId, widget.userId, text);
    } else {
      _chatService.sendMessage(widget.userId, widget.adminId, text);
    }

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: _chatService.getMessages(widget.userId, widget.adminId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!;
                return ListView.builder(
                  reverse: false,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isSender = msg.senderId == widget.currentUserId;
                    return MessageWidget(text: msg.text, isSender: isSender);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
