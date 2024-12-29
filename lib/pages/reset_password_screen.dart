import 'package:flutter/material.dart';
import 'package:sysdev_suretti/pages/login.dart';
import 'package:sysdev_suretti/pages/reset_link_sent_screen.dart';
import 'package:sysdev_suretti/services/auth_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String? errorMessage;

  ResetPasswordScreen({super.key, this.errorMessage});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final contentWidth = screenWidth - 32.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('パスワード再設定'),
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
                'メールアドレスを入力してください',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32.0),
              TextField(
                controller: emailController,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'メールアドレスを入力',
                ),
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ご登録されたメールアドレスに認証メールを送信します。"),
                ],
              ),
              const SizedBox(height: 32.0),
              if (widget.errorMessage != null) ...[
                Text(
                  widget.errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
                const SizedBox(height: 16.0),
              ],
              SizedBox(
                width: contentWidth,
                height: 48.0,
                child: ElevatedButton(
                  onPressed: () async {
                    String email = emailController.text.trim();
                    if (email.isNotEmpty) {
                      try {
                        // ディープリンクを生成
                        final resetLink = "yourappscheme://reset-password";
                        await _authService.sendPasswordResetEmail(email, resetLink);
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('パスワードリセットリンクを送信しました。')),
                        );
                        
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const ResetLinkSentScreen(),
                        ));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('エラーが発生しました: $e')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('メールアドレスを入力してください。')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 100.0),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text('送信'),
                ),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                    return const LoginPage();
                  }));
                },
                child: const Text('ログインへ戻る'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}