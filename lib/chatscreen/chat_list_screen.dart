import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_chat/chatscreen/chat_detail_screen.dart';
import 'package:p_chat/chatscreen/chat_tile.dart';
import 'package:p_chat/chatscreen/provider.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatRoomsAsync = ref.watch(chatRoomsProvider);

    return chatRoomsAsync.when(
      data: (chatDocs) {
        if (chatDocs.docs.isEmpty) {
          return const Center(child: Text('チャット履歴はありません'));
        }
        return ListView.builder(
          itemCount: chatDocs.docs.length,
          itemBuilder: (context, index) {
            final data = chatDocs.docs[index].data() as Map<String, dynamic>;
            final chatName = data['chatName'] ?? 'チャット';
            final lastMessage = data['lastMessage'] ?? '';
            final timestamp = data['timestamp'];
            final timeText =
                timestamp != null
                    ? (timestamp is Timestamp
                        ? (timestamp).toDate().toString().substring(0, 16)
                        : timestamp.toString())
                    : '';

            return ChatTile(
              name: chatName,
              lastMessage: lastMessage,
              unreadCount: 0, // 未読件数の管理がある場合に設定
              isGroup: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) =>
                            ChatDetailScreen(chatId: chatDocs.docs[index].id),
                  ),
                );
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => const Center(child: Text('エラーが発生しました')),
    );
  }
}
