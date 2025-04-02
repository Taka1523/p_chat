import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p_chat/chatscreen/chat_logic.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatId;
  const ChatDetailScreen({Key? key, required this.chatId}) : super(key: key);

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();

  String get currentUserId =>
      FirebaseAuth.instance.currentUser?.uid ?? 'unknown';

  @override
  Widget build(BuildContext context) {
    if (widget.chatId.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Chat Room")),
        body: const Center(child: Text('無効なチャットIDです')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Chat Room")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatService.getMessages(widget.chatId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('エラーが発生しました'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index].data() as Map<String, dynamic>;
                    final text = data['text'] ?? '';
                    final senderId = data['senderId'] ?? '';
                    return ListTile(
                      title: Text(text),
                      subtitle: Text(
                        senderId == currentUserId ? '自分' : '他ユーザー',
                      ),
                    );
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
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'メッセージを入力...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    final text = _messageController.text.trim();
                    if (text.isNotEmpty) {
                      await _chatService.sendMessage(
                        chatId: widget.chatId,
                        text: text,
                        senderId: currentUserId,
                      );
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
