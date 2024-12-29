import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  String? _link;

  @override
  void initState() {
    super.initState();
    // アプリがバックグラウンドで動作している場合のリンク処理
    _initUniLinks();
  }

  // ディープリンクを取得
  Future<void> _initUniLinks() async {
    // アプリがフォアグラウンドにある場合
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        setState(() {
          _link = initialLink;
        });
      }
    } catch (e) {
      print('リンク取得エラー: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新しいパスワードを設定'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_link != null)
              Text('ディープリンクで受け取ったリンク: $_link'),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: '新しいパスワード',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 新しいパスワードの設定処理をここに記述
              },
              child: const Text('パスワードを変更'),
            ),
          ],
        ),
      ),
    );
  }
}
