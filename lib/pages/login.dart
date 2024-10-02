import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sysdev_suretti/navigator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _errorMessage;

  final supabase = Supabase.instance.client;

  Future<void> _signIn() async {
    log('ログイン処理開始', name: 'LoginPage');
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

    try {
      await supabase.auth.signInWithPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
        return const Navigation();
      }), (route) => false);
      log('ログイン完了', name: 'LoginPage');
    } on AuthException catch (error) {
      log('AuthException: ${error.message}', error: error);
      if (error.message.contains('Invalid login credentials')) {
        setState(() {
          _errorMessage = 'メールアドレスまたはパスワードが間違っています';
        });
      } else if (error.message.contains('Email not confirmed')) {
        setState(() {
          _errorMessage = 'メールアドレスが確認されていません';
        });
      } else {
        setState(() {
          _errorMessage = 'ログインに失敗しました';
        });
      }
    } catch (_) {
      log('unexpected error');
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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            centerTitle: true,
            title: const Text('ログイン')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                    labelText: 'メールアドレス',
                    hintText: '例) abc@example.com',
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return '必須';
                  }
                  return null;
                },
              ),
              const SizedBox(width: 16, height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                    labelText: 'パスワード',
                    hintText: '8桁以上32桁以内',
                    border: OutlineInputBorder()),
                obscureText: true,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return '必須';
                  }
                  if (val.length < 8 || val.length > 32) {
                    return '8文字以上32文字以内';
                  }
                  return null;
                },
              ),
              const SizedBox(width: 16, height: 16),
              if (_errorMessage != null) ...[
                Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(width: 16, height: 16),
              ],
              Center(
                  child: Column(children: [
                TextButton(onPressed: () {}, child: const Text('パスワードを忘れた場合')),
                ElevatedButton(
                  onPressed: _isLoading ? null : _signIn,
                  child: const Text('ログイン'),
                ),
              ])),
            ],
          ),
        ));
  }
}
