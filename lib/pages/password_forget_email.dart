// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'dart:math';

// class PasswordResetRequestScreen extends StatefulWidget {
//   @override
//   _PasswordResetRequestScreenState createState() =>
//       _PasswordResetRequestScreenState();
// }

// class _PasswordResetRequestScreenState
//     extends State<PasswordResetRequestScreen> {
//   final _emailController = TextEditingController();
//   final supabase = Supabase.instance.client;

//   Future<void> _submitEmail() async {
//     final email = _emailController.text.trim();

//     if (email.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('メールアドレスを入力してください。')),
//       );
//       return;
//     }

//     try {
//       // ランダムな6桁の認証コードを生成
//       final code = _generateRandomCode(6);

//       // Supabaseテーブルにリクエストを挿入
//       final response = await supabase.from('password_reset_requests').insert({
//         'email': email,
//         'code': code,
//       });

//       if (response.error != null) {
//         throw Exception(response.error!.message);
//       }

//       // メール送信を実装する関数を呼び出す（仮）
//       await _sendEmail(email, code);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('認証コードが送信されました。メールをご確認ください。')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('エラーが発生しました: $e')),
//       );
//     }
//   }

//   String _generateRandomCode(int length) {
//     const chars = '0123456789';
//     return List.generate(length, (index) => chars[(chars.length * Math.random()).floor()])
//         .join();
//   }

//   Future<void> _sendEmail(String email, String code) async {
//     // メール送信の実装を記述 (SendGridや別サービスを利用)
//     // この部分は仮置きで、バックエンドでの処理と連携させる
//     print('Sending email to $email with code: $code');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('パスワードリセット'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _emailController,
//               keyboardType: TextInputType.emailAddress,
//               decoration: InputDecoration(
//                 labelText: 'メールアドレス',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _submitEmail,
//               child: Text('送信'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
