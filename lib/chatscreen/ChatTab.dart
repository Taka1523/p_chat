import 'package:flutter/material.dart';
import 'package:p_chat/chatscreen/chat_detail_screen.dart';
import 'package:p_chat/chatscreen/chat_list_screen.dart';

class ChatTab extends StatelessWidget {
  const ChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (BuildContext context) => const ChatListScreen();
            break;
          default:
            if (settings.name!.startsWith('/chat/')) {
              final chatId = settings.name!.replaceFirst('/chat/', '');
              builder =
                  (BuildContext context) => ChatDetailScreen(
                    chatId: chatId.isEmpty ? 'defaultChatId' : chatId,
                  );
            } else {
              builder = (BuildContext context) => const ChatListScreen();
            }
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
