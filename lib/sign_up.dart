import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '新規登録',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nicknameController = TextEditingController();
  String? _errorMessage;

  Future<void> _register() async {
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
    });

    try {
      // Supabaseを使用してユーザーを新規登録
      final response = await Supabase.instance.client.auth.signUp(
        email: _emailController.text,
        password: _passwordController.text,
        data: {'username': _nicknameController.text},
      );

      if (response.session == null || response.user == null) {
        setState(() {
          // _errorMessage ='登録に失敗しました';
          _errorMessage = '登録に失敗しました: ${response.session} :::::::::: ${response.user}';
        });
        return;
      }

      setState(() {
        _errorMessage = null;
      });

      // 登録成功時の処理
      // ユーザーIDを取得して、usersテーブルに挿入
      final userId = response.user?.id;
      if (userId != null) {
        final insertResponse = await Supabase.instance.client
            .from('users')
            .insert({
              'auth_id': userId,
              'nickname': _nicknameController.text,
            })
            .select();
        // エラーは例外として処理
        if (insertResponse.isEmpty) {
          throw Exception('User insertion failed');
        } else {
          // 登録成功時の処理
        }
      }
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text('新規登録'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 50),
              const Text(
                'メールアドレス',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: '例)abc@example.com',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'パスワード',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  hintText: '8桁以上32桁以内',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              const Text(
                'ニックネーム',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  hintText: '例)すれちがいおにいさん',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: TextButton(
                  onPressed: () {
                    // ログイン画面へ遷移する処理をここに追加
                  },
                  child: const Text(
                    'ログイン画面へ',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              if (_errorMessage != null) ...[
                Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                  ),
                  onPressed: _register,
                  child: const Text('登録する'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
