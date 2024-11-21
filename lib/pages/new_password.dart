import 'package:flutter/material.dart';
import 'package:sysdev_suretti/pages/login.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  _NewPasswordPageState createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  String? _errorMessage;

  void _validateAndSubmit() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const NewPasswordPage(),
    ));

    setState(() {
      if (_currentPasswordController.text.isEmpty ||
          _newPasswordController.text.isEmpty) {
        _errorMessage = "新しいパスワードを入力してください。";
      } else if (_newPasswordController.text.length < 8 ||
          _newPasswordController.text.length > 32) {
        _errorMessage = "パスワードは8文字以上、32文字以下で入力してください。";
      } else if (_currentPasswordController.text !=
          _newPasswordController.text) {
        _errorMessage = "パスワードが一致しません。";
      } else {
        _errorMessage = null;
        // ここで保存処理を追加
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("認証メールを送信しました。")),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // 左右のパディングを考慮した幅を計算
    final contentWidth = screenWidth - 32.0; // 左右16pxずつのパディング
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('新規パスワード入力'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '新しいパスワードを入力してください',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32.0),
              TextField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '新しいパスワードを入力',
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '新しいパスワードを再入力',
                ),
              ),
              const SizedBox(height: 16.0),
              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!, //ここでなんか適当なエラーを表示する
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
                const SizedBox(height: 32.0),
              ],
              SizedBox(
                width: contentWidth,
                height: 48.0,
                child: ElevatedButton(
                  //多分この下にパスワードを保存する処理を追加する
                  onPressed: () => _validateAndSubmit(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 100.0),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text('変更'),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const LoginPage();
                    }));
                  },
                  child: const Text('ログインへ戻る')),
            ],
          ),
        ),
      ),
    );
  }
}
