import 'package:flutter/material.dart';
import 'package:p_chat/chatscreen/ChatTab.dart';
import 'package:p_chat/homeTab.dart';
import 'package:p_chat/loginbutton/google_sign_in/sign_out_buttom.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static const String _userName = 'たかふみ';

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = <Widget>[HomeTab(userName: _userName), const ChatTab()];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSettingsTapped() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('設定ボタンが押されました')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'HOME' : 'トーク'),
        actions: [
          const SignOutButton(),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _onSettingsTapped,
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'トーク'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
