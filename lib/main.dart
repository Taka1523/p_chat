import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:p_chat/chatscreen/chat_detail_screen.dart';
import 'package:p_chat/chatscreen/chat_list_screen.dart';
import 'package:p_chat/home_screen.dart';
import 'package:p_chat/login_screen.dart';
import 'package:p_chat/firebase_options.dart';

// Riverpod で GoRouter をプロバイダー化
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    redirect: (context, state) {
      // 現在のログイン状態を確認
      final bool loggedIn = FirebaseAuth.instance.currentUser != null;
      // 現在のルートがログイン画面かどうかを state.uri.path から取得
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
          final chatId = state.pathParameters['id']!;
          return ChatDetailScreen(chatId: chatId);
        },
      ),
    ],
  );
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'YakChat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: router,
    );
  }
}
