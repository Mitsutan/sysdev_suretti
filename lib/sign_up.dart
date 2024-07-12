import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '新規登録',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nicknameController = TextEditingController();
  String? _errorMessage;

  void _register() {
    setState(() {
      // エラーメッセージのリセット
      _errorMessage = null;

      // 入力値のチェック
      if (_emailController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _nicknameController.text.isEmpty) {
        _errorMessage = 'すべてのフィールドを入力してください';
        return;
      }

      if (_passwordController.text.length < 8 || _passwordController.text.length > 32) {
        _errorMessage = 'パスワードは8桁以上32桁以内で入力してください';
        return;
      }

      // その他のバリデーションや登録処理をここに追加
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text('新規登録'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 50),
              Text(
                'メールアドレス',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  // labelText: 'メールアドレス',
                  hintText: '例)abc@example.com',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'パスワード',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  // labelText: 'パスワード',
                  hintText: '8桁以上32桁以内',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              Text(
                'ニックネーム',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  // labelText: 'ニックネーム',
                  hintText: '例)すれちがいおにいさん',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: TextButton(
                  onPressed: () {
                    // ログイン画面へ遷移する処理をここに追加
                  },
                  child: Text(
                    'ログイン画面へ',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              if (_errorMessage != null) ...[
                Center(
                 child:Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
                SizedBox(height: 16.0),
              ],
              Center(
                child: ElevatedButton(
                  onPressed: _register,
                  child: Text('登録する'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // primary を backgroundColor に変更
                    padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
