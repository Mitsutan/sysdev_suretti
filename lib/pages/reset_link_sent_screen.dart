import 'package:flutter/material.dart';
import 'package:sysdev_suretti/pages/login.dart';

class ResetLinkSentScreen extends StatelessWidget {
  const ResetLinkSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('パスワードリセットリンク送信完了'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'ご登録されたメールアドレスにパスワードリセット用リンクを送信しました。',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                    return const LoginPage();
                  }));
                },
                child: const Text('ログイン画面に戻る'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
