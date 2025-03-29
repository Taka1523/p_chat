import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  final String userName;
  final VoidCallback onChatTabSelected;

  const HomeTab({
    Key? key,
    required this.userName,
    required this.onChatTabSelected,
  }) : super(key: key);

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
                  // タップ時にチャットタブへ切り替え
                  onTap: onChatTabSelected,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
