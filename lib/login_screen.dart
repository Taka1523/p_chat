// login_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:p_chat/loginbutton/apple_sign_in/sign_in_buttom.dart';
import 'package:p_chat/loginbutton/google_sign_in/sign_in_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Google サインインボタンを配置
            const GoogleSignInButton(),
            const AppleSignInButton(),
            const SizedBox(height: 16),
            // 既存のホーム画面への遷移ボタン
            ElevatedButton(
              onPressed: () {
                context.go('/home'); // go_router を使って画面遷移
              },
              child: const Text('ログイン → HOME'),
            ),
          ],
        ),
      ),
    );
  }
}
