import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ログイン',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  Future<void> _login() async {
    setState(() {
      _errorMessage = null;
    });

    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
      _errorMessage = 'メールアドレスとパスワードを入力してください';
    });
    return;
  }

    if (password.length < 8 || password.length > 32) {
      setState(() {
        _errorMessage = 'パスワードは8桁以上32桁以内で入力してください';
      });
      return;
    }

    // Supabaseを使用したログイン処理
    final response = await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.session == null) {
      setState(() {
        _errorMessage = 'ログインに失敗しました';
      });
      return;
    }

    // ログイン成功時の処理
    Navigator.pushReplacementNamed(context, '/map');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text('ログイン'),
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
              SizedBox(height: 8.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: '例) abc@example.com',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'パスワード',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: '8桁以上32桁以内',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              if (_errorMessage != null) ...[
                Center(
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                SizedBox(height: 16.0),
              ],
              Center(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        // 新規ユーザー登録画面へ遷移する処理をここに追加
                      },
                      child: Text(
                        '新規ユーザー登録はこちら',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // パスワードを忘れた方画面へ遷移する処理をここに追加
                      },
                      child: Text(
                        'パスワードを忘れた方はこちら',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _login,
                      child: Text('ログイン'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}