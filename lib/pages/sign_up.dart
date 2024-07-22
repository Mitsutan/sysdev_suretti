import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sysdev_suretti/pages/login.dart';

// import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  // static Route<void> route({bool isRegistering = false}) {
  //   return MaterialPageRoute(
  //     builder: (context) => const SignupPage(),
  //   );
  // }

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  String? _errorMessage;

  final supabase = Supabase.instance.client;

  Future<void> _signUp() async {
    log('登録処理開始', name: 'RegisterPage');
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    final email = _emailController.text;
    final password = _passwordController.text;
    final username = _usernameController.text;
    try {
      await supabase.auth.signUp(
          email: email, password: password, data: {'username': username});
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
        return const LoginPage();
      }), (route) => false);
      log('登録完了', name: 'RegisterPage');
    } on AuthException catch (error) {
      log(error.message, name: 'RegisterPage', error: error);
      if (error.message.contains('Failed host lookup')) {
        setState(() {
          _errorMessage = 'サーバに接続できませんでした';
        });
      } else {
        setState(() {
          _errorMessage = '登録に失敗しました';
        });
      }
    } catch (error) {
      log('Unexpected error: $error', name: 'RegisterPage');
      setState(() {
        _errorMessage = '予期せぬエラーが発生しました\n時間をおいて再度お試しください';
      });
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text('登録'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  label: Text('メールアドレス'),
                  hintText: '例)abc@example.com',
                  border: OutlineInputBorder()
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return '必須';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(width: 16, height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  label: Text('パスワード'),
                  hintText: '8桁以上32桁以内',
                  border: OutlineInputBorder()
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return '必須';
                  }
                  if (val.length < 8) {
                    return '8文字以上';
                  }
                  return null;
                },
              ),
              const SizedBox(width: 16, height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  label: Text('ユーザー名'),
                  hintText: '例)すれちがいおにいさん',
                  border: OutlineInputBorder()
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return '必須';
                  }
                  // final isValid = RegExp(r'^[A-Za-z0-9_]{3,24}$').hasMatch(val);
                  // if (!isValid) {
                  //   return '3~24文字のアルファベットか文字で入力してください';
                  // }
                  return null;
                },
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
              const SizedBox(width: 16, height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const LoginPage();
                    }));
                  },
                  child: const Text('ログイン画面へ'),
                ),
              ),
              const SizedBox(width: 16, height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signUp,
                  // style: ElevatedButton.styleFrom(
                  //   backgroundColor: Theme.of(context).colorScheme.primary,
                  // ),
                  child: const Text('登録'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
