import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:p_chat/chatscreen/chat_detail_screen.dart';
import 'package:p_chat/chatscreen/chat_list_screen.dart';
import 'package:p_chat/home_screen.dart';
import 'package:p_chat/login_screen.dart';

final router = GoRouter(
  redirect: (context, state) {
    final bool loggedIn = FirebaseAuth.instance.currentUser != null;
    final bool loggingIn = state.uri.path == '/';
    if (!loggedIn && !loggingIn) return '/';
    if (loggedIn && loggingIn) return '/home';
    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/chat_list',
      builder: (context, state) => const ChatListScreen(),
    ),
    GoRoute(
      path: '/chat/:id',
      builder: (context, state) {
        final chatId = state.pathParameters['id'] ?? 'defaultChatId';
        return ChatDetailScreen(chatId: chatId);
      },
    ),
  ],
);
