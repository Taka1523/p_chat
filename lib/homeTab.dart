import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p_chat/chatscreen/chat_detail_screen.dart';
import 'package:p_chat/chatscreen/chat_logic.dart';

class HomeTab extends StatelessWidget {
  final String userName;

  const HomeTab({Key? key, required this.userName}) : super(key: key);

  // メンバータップ時の処理
  void _onMemberTapped(BuildContext context, String partnerName) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';
    ChatService chatService = ChatService();

    // 既にチャットが存在するか確認
    String? existingChatId = await chatService.getExistingChat(
      partnerName: partnerName,
      currentUserId: currentUserId,
    );

    if (existingChatId != null) {
      // 既存チャットがあれば、直接チャット画面へ遷移
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatDetailScreen(chatId: existingChatId),
        ),
      );
      return;
    }

    // 初回チャットの場合、バナー（ここではダイアログ）で確認
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('$partnerName とのチャット'),
            content: Text('$partnerName とのチャットを開始しますか？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('いいえ'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('はい'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      // ユーザーが新規チャット作成を選択した場合、チャット作成して画面遷移
      String chatId = await chatService.createChat(
        partnerName: partnerName,
        currentUserId: currentUserId,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatDetailScreen(chatId: chatId),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dummyMembers = [
      {'name': 'たかふみ', 'role': '薬剤師', 'online': true},
      {'name': 'さとう', 'role': '医療事務', 'online': false},
      {'name': 'なかむら', 'role': '薬剤師', 'online': true},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ようこそ P_Chat へ', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 16),
          Text('使用者：$userName', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 24),
          const Text(
            'メンバー一覧',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: dummyMembers.length,
              itemBuilder: (context, index) {
                final member = dummyMembers[index];
                final String name = member['name'] as String;
                final String role = member['role'] as String;
                final bool online = member['online'] as bool;

                return ListTile(
                  leading: CircleAvatar(child: Text(name[0])),
                  title: Text(name),
                  subtitle: Text(role),
                  trailing: Icon(
                    Icons.circle,
                    size: 12,
                    color: online ? Colors.green : Colors.grey,
                  ),
                  onTap: () => _onMemberTapped(context, name),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
