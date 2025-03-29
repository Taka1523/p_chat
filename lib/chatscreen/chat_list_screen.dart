import 'package:flutter/material.dart';
import 'chat_detail_screen.dart'; // ← 追加

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyChats = [
      {'name': '薬剤師グループ', 'lastMessage': '在庫確認お願いします', 'time': '10:45'},
      {'name': '医療事務グループ', 'lastMessage': 'FAX送信済みです', 'time': '09:20'},
      {'name': 'たかふみ', 'lastMessage': '今日のシフト確認しました', 'time': '昨日'},
    ];

    return ListView.builder(
      itemCount: dummyChats.length,
      itemBuilder: (context, index) {
        final chat = dummyChats[index];
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.group)),
          title: Text(chat['name']!),
          subtitle: Text(chat['lastMessage']!),
          trailing: Text(chat['time']!),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ChatDetailScreen(chatId: ''),
              ),
            );
          },
        );
      },
    );
  }
}
