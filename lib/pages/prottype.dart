import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String accessToken;

  // ignore: use_super_parameters
  const ResetPasswordScreen({Key? key, required this.accessToken}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _supabase = Supabase.instance.client;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _errorMessage;

  Future<void> _resetPassword() async {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      setState(() {
        _errorMessage = "パスワードが一致しません。";
      });
      return;
    }

    try {
      var response = await _supabase.auth.api.updateUser(
        widget.accessToken,
        UserAttributes(password: password),
      );

      if (response.error != null) {
        setState(() {
          _errorMessage = "エラーが発生しました: ${response.error!.message}";
        });
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('パスワードが正常にリセットされました。'))
        );
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      }
    } catch (error) {
      setState(() {
        _errorMessage = "エラーが発生しました: $error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('パスワードリセット'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: '新しいパスワード'),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(labelText: 'パスワード確認'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetPassword,
              child: const Text('パスワードをリセット'),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 20),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}